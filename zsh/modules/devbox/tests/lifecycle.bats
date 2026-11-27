#!/usr/bin/env bats
# Lifecycle acceptance tests for the devbox module (default disable + reversal).
# OpenSpec change: review-zsh-modules-lifecycle — task 2.2.
#
# Contract: openspec/changes/review-zsh-modules-lifecycle/specs/zsh-module-lifecycle/spec.md
#   - "Changed default disables module cleanly" (Disabled state / Enabled state)
#   - "Disabled modules are reversible per fresh shell" (Force-enable one module)
# Design: decision 5 (guard assignment below the enabled check) and
# decision 6 (devbox flips to DISABLE, reversible via ZSH_DEVBOX_ENABLED=true).
#
# CRITICAL: everything under test is zsh (plugin.zsh's config-driven
# `$ZSH_DEVBOX_ENABLED || return` and the `__ZSH_DEVBOX_LOADED` guard), so
# every case runs through run_devbox_zsh — a real `zsh -f` subshell.
#
# Anti-vacuous design (modeled on zsh/modules/notify/tests/hooks.bats):
#   - every case asserts EXACT marker values (grep -qxF), never substrings;
#   - the default-disabled case is paired with a control case that opts in
#     through the identical prelude/source path, proving the fixture and
#     source chain are live — so "functions undefined" can only come from the
#     disabled default, never from a dead fixture;
#   - the control additionally asserts `marker:enabled=true`, pinning the opt-in
#     to the variable rather than to a broken default.

DEVBOX_TEST_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../.." && pwd)"
DEVBOX_MODULE_DIR="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
export DEVBOX_TEST_ROOT DEVBOX_MODULE_DIR

# ── snippet builders (bash → zsh source text) ───────────────────────────────

# Prelude: stubs for the dotfiles core stack. core::exists / core::nix::exists
# answer "present" so sourcing internal/main.zsh can never trigger the
# install-on-failure path (a test must never install packages); if the stubs
# were dead, core::install below would print a loud marker instead of curling.
devbox_zsh_prelude() {
  cat <<'PRELUDE'
message_error() { print -u2 -- "ERROR: $*"; }
message_success() { print -- "SUCCESS: $*"; }
message_warning() { print -u2 -- "WARNING: $*"; }
message_info() { print -- "INFO: $*"; }
core::exists() { return 0; }
core::nix::exists() { return 0; }
core::ensure() { return 0; }
core::install() { print -u2 -- "STUB-CORE-INSTALL: $*"; return 1; }
PRELUDE
}

# Shared marker tail: printed after the source under test so every assertion
# below reads an exact marker line.
emit_devbox_markers() {
  cat <<'MARKERS'
print -- "marker:loaded_guard=${__ZSH_DEVBOX_LOADED:-<unset>}"
print -- "marker:enabled=${ZSH_DEVBOX_ENABLED:-<unset>}"
for __fn in devbox::install devbox::sync devbox::shell devbox::init; do
  if (( $+functions[$__fn] )); then
    print -- "marker:fn:${__fn}=defined"
  else
    print -- "marker:fn:${__fn}=undefined"
  fi
done
MARKERS
}

# Run a zsh snippet (plus the prelude) in a real `zsh -f` subshell; optional
# leading env assignments are passed through `env` (the reversal case uses this
# to export ZSH_DEVBOX_ENABLED exactly like a $CUSTOMRC export would).
run_devbox_zsh() {
  local snippet="$1"
  shift
  local zsh_code
  zsh_code="$(devbox_zsh_prelude)
${snippet}"
  env "$@" zsh -f -c "$zsh_code"
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

# ─────────────────────────────────────────────────────────────────────────────
# 2.2 control — opted in (anti-vacuous pairing for the default-disabled case)
# ─────────────────────────────────────────────────────────────────────────────

@test "2.2 control: opted-in devbox loads — guard set, public functions defined" {
  run run_devbox_zsh 'ZSH_DEVBOX_ENABLED=true
unset __ZSH_DEVBOX_LOADED
source "${DEVBOX_MODULE_DIR}/plugin.zsh"
print -- "marker:plugin_exit=$?"
'"$(emit_devbox_markers)"
  [ "$status" -eq 0 ]
  assert_marker plugin_exit 0
  assert_marker enabled true
  assert_marker loaded_guard 1
  assert_marker "fn:devbox::install" defined
  assert_marker "fn:devbox::sync" defined
  assert_marker "fn:devbox::shell" defined
  assert_marker "fn:devbox::init" defined
}

# ─────────────────────────────────────────────────────────────────────────────
# 2.2 default-disabled — no opt-in: guard unset, public functions undefined
# ─────────────────────────────────────────────────────────────────────────────

@test "2.2 default-disabled: devbox stays off — guard unset, public functions undefined" {
  run run_devbox_zsh 'unset ZSH_DEVBOX_ENABLED
unset __ZSH_DEVBOX_LOADED
source "${DEVBOX_MODULE_DIR}/plugin.zsh"
print -- "marker:plugin_exit=$?"
'"$(emit_devbox_markers)"
  [ "$status" -eq 0 ]
  assert_marker enabled false
  assert_marker loaded_guard '<unset>'
  assert_marker "fn:devbox::install" undefined
  assert_marker "fn:devbox::sync" undefined
  assert_marker "fn:devbox::shell" undefined
  assert_marker "fn:devbox::init" undefined
}

# ─────────────────────────────────────────────────────────────────────────────
# 2.2 reversal — `export ZSH_DEVBOX_ENABLED=true` before startup (as in $CUSTOMRC)
# ─────────────────────────────────────────────────────────────────────────────

@test "2.2 reversal: exported ZSH_DEVBOX_ENABLED=true before startup re-enables devbox" {
  run run_devbox_zsh 'unset __ZSH_DEVBOX_LOADED
source "${DEVBOX_MODULE_DIR}/plugin.zsh"
print -- "marker:plugin_exit=$?"
'"$(emit_devbox_markers)" \
    ZSH_DEVBOX_ENABLED=true
  [ "$status" -eq 0 ]
  assert_marker plugin_exit 0
  assert_marker enabled true
  assert_marker loaded_guard 1
  assert_marker "fn:devbox::install" defined
  assert_marker "fn:devbox::sync" defined
  assert_marker "fn:devbox::shell" defined
  assert_marker "fn:devbox::init" defined
}
