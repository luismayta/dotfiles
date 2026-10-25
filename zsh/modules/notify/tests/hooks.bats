#!/usr/bin/env bats
# Hook registration + module-disable acceptance tests for the notify module.
# OpenSpec change: fix-notify-terminal-freeze — tasks 6.1, 6.2.
#
# Contract: openspec/changes/fix-notify-terminal-freeze/specs/notify-prompt-safety/spec.md
#   - "Hooks register exactly once"          (Sourced twice scenario)
#   - "Disabled module registers no hooks"   (Module disabled at load scenario)
# Design: D9 (test harness mirrors the herdr module convention).
#
# CRITICAL: everything under test here is zsh (plugin.zsh's `__ZSH_NOTIFY_LOADED`
# guard, `add-zsh-hook`, and the zshrc module loop's zsh-only
# `${ZSH_DISABLED_MODULES// /,}` substitution and `*(/N)` glob qualifiers), so
# every case runs through run_notify_zsh — a real `zsh -f` subshell. Per the
# helper's header, the helper prelude only sources config/base.zsh +
# internal/base.zsh; plugin.zsh and everything it chains (config/main,
# internal/main, pkg/main, adapters) is sourced INSIDE the snippet.
#
# Anti-vacuous design:
#   - every case asserts EXACT marker values (`grep -qxF`), never substrings;
#   - the disabled case is paired with a control case running the same loop
#     WITHOUT ZSH_DISABLED_MODULES, proving the loop/fixture/source path is
#     live — so a "0 hooks" result can only come from the disable token;
#   - the disabled case additionally asserts `marker:loop_modules=notify`
#     (the loop's glob really matched the module) and
#     `marker:plugin_zsh_present=yes` (the `[ -e plugin.zsh ]` branch was
#     live), pinning the skip to the token-match test itself.

load "${BATS_TEST_DIRNAME}/test_helper.bash"

setup() {
  NOTIFY_FIXTURE_HOME="$(make_notify_tmpdir)"
  # Fixture module tree for the zshrc loop (zsh/zshrc:57-66). The loop globs
  # "${DOTFILES_ZSH_PATH}"/modules/*(/N) and the (/) qualifier does NOT match
  # symlinks-to-directories (verified against zsh 5.9), so modules/notify must
  # be a REAL directory whose entries are symlinks to the real module files —
  # `[ -e ]` and `source` follow those transparently, and the loop still sees
  # exactly one module named "notify" instead of sourcing the other ~40
  # modules under `zsh -f`.
  NOTIFY_FIXTURE_ROOT="$(make_notify_tmpdir)"
  mkdir -p "${NOTIFY_FIXTURE_ROOT}/modules/notify"
  local entry
  for entry in "${NOTIFY_MODULE_DIR}"/*; do
    ln -s "$entry" "${NOTIFY_FIXTURE_ROOT}/modules/notify/"
  done
  export NOTIFY_FIXTURE_ROOT
}

teardown() {
  cleanup_notify_tmpdir "$NOTIFY_FIXTURE_HOME"
  cleanup_notify_tmpdir "$NOTIFY_FIXTURE_ROOT"
  unset NOTIFY_FIXTURE_ROOT
}

# ── snippet builders (bash → zsh source text) ───────────────────────────────

# The zshrc module loader, verbatim from zsh/zshrc:57-66 (including the exact
# disabled-token match test ",${ZSH_DISABLED_MODULES// /,}," == *",${__module_name},"*).
emit_zshrc_module_loop() {
  cat <<'ZSHRC_LOOP'
for __module_dir in "${DOTFILES_ZSH_PATH}"/modules/*(/N); do
  if [ -e "${__module_dir}/plugin.zsh" ]; then
    # Skip if module is in ZSH_DISABLED_MODULES (space or comma separated)
    __module_name="${__module_dir:t}"
    if [[ -n "${ZSH_DISABLED_MODULES:-}" ]] && [[ ",${ZSH_DISABLED_MODULES// /,}," == *",${__module_name},"* ]]; then
      continue
    fi
    source "${__module_dir}/plugin.zsh"
  fi
done
unset __module_name __module_dir
ZSHRC_LOOP
}

# Shared marker tail: printed after the action under test (double source or
# module loop) so every assertion below reads an exact marker line.
emit_hook_markers() {
  cat <<'MARKERS'
print -- "marker:loaded_guard=${__ZSH_NOTIFY_LOADED:-<unset>}"
print -- "marker:zsh_notify_path=${ZSH_NOTIFY_PATH:-<unset>}"
_m=( ${(M)preexec_functions:#notify::command::store} )
print -- "marker:preexec_store_count=${#_m}"
_c=( ${(M)precmd_functions:#notify::command::completed} )
print -- "marker:precmd_completed_count=${#_c}"
_ma=( ${(M)preexec_functions:#notify::*} )
print -- "marker:preexec_notify_total=${#_ma}"
_mb=( ${(M)precmd_functions:#notify::*} )
print -- "marker:precmd_notify_total=${#_mb}"
if whence -w notify::command::store >/dev/null 2>&1; then
  print -- "marker:store_fn=present"
else
  print -- "marker:store_fn=absent"
fi
MARKERS
}

# Task 6.1 snippet: source plugin.zsh TWICE in one `zsh -f` shell, then emit
# the hook markers. `unset __ZSH_NOTIFY_LOADED` first so the markers prove the
# two sources below are what set it.
build_double_source_snippet() {
  printf '%s\n' \
    'unset __ZSH_NOTIFY_LOADED' \
    'source "${NOTIFY_MODULE_DIR}/plugin.zsh"' \
    'source "${NOTIFY_MODULE_DIR}/plugin.zsh"'
  emit_hook_markers
}

# Task 6.2 snippet: the zshrc module loop over the fixture tree, with the
# disabled-token preamble parameterised ($1 = "yes" → ZSH_DISABLED_MODULES=notify).
build_loop_snippet() {
  local disable="${1:-no}"
  if [[ "$disable" == "yes" ]]; then
    printf '%s\n' 'ZSH_DISABLED_MODULES=notify'
  else
    printf '%s\n' 'unset ZSH_DISABLED_MODULES'
  fi
  printf '%s\n' \
    'unset __ZSH_NOTIFY_LOADED' \
    'unset ZSH_NOTIFY_PATH' \
    'DOTFILES_ZSH_PATH="${NOTIFY_FIXTURE_ROOT}"'
  # Pre-loop visibility markers: what the loop's glob sees and whether its
  # `[ -e plugin.zsh ]` branch would be live (anti-vacuous guards).
  cat <<'PREAMBLE'
modules_seen=()
for _d in "${DOTFILES_ZSH_PATH}"/modules/*(/N); do
  modules_seen+=( "${_d:t}" )
done
print -- "marker:loop_modules=${(j:,:)modules_seen}"
if [[ -e "${DOTFILES_ZSH_PATH}/modules/notify/plugin.zsh" ]]; then
  print -- "marker:plugin_zsh_present=yes"
else
  print -- "marker:plugin_zsh_present=no"
fi
PREAMBLE
  emit_zshrc_module_loop
  emit_hook_markers
}

# ── assertion helpers ───────────────────────────────────────────────────────

# Assert an EXACT marker line (`marker:$1=$2`, whole-line fixed match) in the
# captured output; dump the full output on failure.
assert_marker() {
  local name="$1" expected="$2"
  if ! printf '%s\n' "$output" | grep -qxF "marker:${name}=${expected}"; then
    printf 'FAIL: missing exact marker line: marker:%s=%s\n' "$name" "$expected" >&2
    printf '%s\n' "--- captured output ---" "$output" >&2
    return 1
  fi
}

# How many times plugin.zsh's load banner was printed: 0 = never sourced,
# 1 = sourced once (the __ZSH_NOTIFY_LOADED guard blocked the second source),
# 2+ = the guard failed.
banner_count() {
  printf '%s\n' "$output" | grep -cF 'Loading module: notify' || :
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 6.1 — double sourcing (spec: "Hooks register exactly once")
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Sourced twice" — WHEN plugin.zsh is sourced twice in one
# shell session THEN each hook array SHALL contain exactly one notify entry.
# The __ZSH_NOTIFY_LOADED guard (plugin.zsh:11-12) plus add-zsh-hook's dedupe
# must hold.
@test "6.1 double sourcing plugin.zsh registers each hook exactly once" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_HOME" \
    "$(build_double_source_snippet)"
  [ "$status" -eq 0 ]
  # The load banner printed exactly once: first source ran, second source hit
  # the early-return guard (a count of 0 would mean the load never happened).
  [ "$(banner_count)" -eq 1 ]
  assert_marker loaded_guard 1
  assert_marker preexec_store_count 1
  assert_marker precmd_completed_count 1
  # No notify entry in either array beyond the expected one (catches a hook
  # registered into the wrong array or duplicated under another name).
  assert_marker preexec_notify_total 1
  assert_marker precmd_notify_total 1
  # The registered function actually exists (pkg/base.zsh was loaded).
  assert_marker store_fn present
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 6.2 — the zshrc module loop (spec: "Disabled module registers no hooks")
# ─────────────────────────────────────────────────────────────────────────────

# ANTI-VACUOUS CONTROL for the disabled case below: the identical loop over
# the identical fixture, only ZSH_DISABLED_MODULES absent. Proves the glob,
# the `[ -e ]` branch, and `source` all work — so the disabled case's "0
# hooks" can only be caused by the disable token, never by a dead fixture.
@test "6.2 control: module loop without ZSH_DISABLED_MODULES loads notify and registers hooks" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_HOME" \
    "$(build_loop_snippet no)"
  [ "$status" -eq 0 ]
  assert_marker loop_modules notify
  assert_marker plugin_zsh_present yes
  [ "$(banner_count)" -eq 1 ]
  assert_marker loaded_guard 1
  # plugin.zsh set ZSH_NOTIFY_PATH to the fixture module dir it was sourced from.
  assert_marker zsh_notify_path "${NOTIFY_FIXTURE_ROOT}/modules/notify"
  assert_marker preexec_store_count 1
  assert_marker precmd_completed_count 1
  assert_marker preexec_notify_total 1
  assert_marker precmd_notify_total 1
  assert_marker store_fn present
}

# Spec scenario: "Module disabled at load" — WHEN ZSH_DISABLED_MODULES=notify
# and the module loop in zsh/zshrc runs THEN neither hook SHALL be registered
# and no notification machinery SHALL load.
@test "6.2 disabled: module loop skips plugin.zsh — no hooks, no notify machinery" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_HOME" \
    "$(build_loop_snippet yes)"
  [ "$status" -eq 0 ]
  # The loop's glob DID match the module and its `[ -e plugin.zsh ]` branch
  # was live: the skip below comes from the token-match test, not a dead tree.
  assert_marker loop_modules notify
  assert_marker plugin_zsh_present yes
  # plugin.zsh never executed: guard unset, no load banner, path unset.
  assert_marker loaded_guard '<unset>'
  [ "$(banner_count)" -eq 0 ]
  assert_marker zsh_notify_path '<unset>'
  # Neither hook registered, and no notify::* entry at all in either array.
  assert_marker preexec_store_count 0
  assert_marker precmd_completed_count 0
  assert_marker preexec_notify_total 0
  assert_marker precmd_notify_total 0
  # pkg-level machinery (notify::command::store) never defined.
  assert_marker store_fn absent
}
