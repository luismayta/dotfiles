#!/usr/bin/env bats
# Acceptance tests for install-free startup and the zsh/datetime load path —
# OpenSpec change fix-notify-terminal-freeze, tasks 3.1, 3.2, 3.3 and the
# zmodload half of task 5.2.
#
# Contract: openspec/changes/fix-notify-terminal-freeze/specs/notify-prompt-safety/spec.md
#   - "Module startup performs no package installation": missing mpg123, and
#     missing gomplate with ZSH_NOTIFY_PROVIDER=noti, SHALL emit
#     message_warning (naming the missing binary AND the explicit install
#     path) instead of calling core::ensure; module loading SHALL complete.
#   - "Prompt hooks avoid per-prompt process forks": zmodload zsh/datetime
#     sits on the notify load path (design D7), so EPOCHSECONDS is a usable
#     integer right after sourcing internal/main.zsh under `zsh -f`.
#
# The prelude in test_helper.bash stubs core::ensure/core::install as
# RECORDING no-ops keyed on NOTIFY_STUB_CORE_LOG: any call appends to the
# log file, so "startup performed no install" is asserted as "the log file
# does not exist" — a call can never be swallowed silently.
#
# CRITICAL: every snippet below runs the real code inside a `zsh -f`
# subshell via run_notify_zsh — never calls module functions from bash.

load "${BATS_TEST_DIRNAME}/test_helper.bash"

setup() {
  FIXTURE_HOME="$(make_notify_tmpdir)"
  CORE_LOG="$FIXTURE_HOME/core-install.log"
  export NOTIFY_STUB_CORE_LOG="$CORE_LOG"
}

teardown() {
  unset NOTIFY_STUB_CORE_LOG
  unset ZSH_NOTIFY_PROVIDER
  cleanup_notify_tmpdir "$FIXTURE_HOME"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 3.1 — missing mpg123: warn, never install
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Missing mpg123 at load" — WHEN the module loads without
# mpg123 on PATH THEN a warning SHALL be emitted, no package manager SHALL
# be invoked, and module loading SHALL complete.
@test "3.1 missing mpg123 -> warning names binary + install path, no install, load completes" {
  local empty_bin="$FIXTURE_HOME/empty-bin"
  local q_bin q_plugin snippet
  mkdir -p "$empty_bin"
  # PATH reduced to an EMPTY dir: no mpg123, no gomplate, no package manager
  # reachable — if startup tried to install anything it could not even run,
  # and the recording stub below proves it never tried.
  printf -v q_bin '%q' "$empty_bin"
  printf -v q_plugin '%q' "$NOTIFY_MODULE_DIR/plugin.zsh"
  snippet="PATH=${q_bin}
source ${q_plugin} && print -r -- LOADED"

  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"

  [ "$status" -eq 0 ]
  [[ "$output" == *LOADED* ]]
  # the warning names the missing binary ...
  [[ "$output" == *"mpg123 missing"* ]]
  # ... and the explicit install path (core::ensure was replaced by
  # detection + message_warning, never by an automatic install)
  [[ "$output" == *"core::install mpg123"* ]]
  # no core::ensure / core::install call happened on the load path
  [ ! -e "$CORE_LOG" ]
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 3.2 — missing gomplate with the noti provider: warn, never install
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Missing gomplate with noti provider" — WHEN
# ZSH_NOTIFY_PROVIDER=noti and gomplate is absent THEN the module SHALL warn
# and continue without installing anything (module sources end-to-end with
# status 0).
@test "3.2 provider=noti + gomplate missing -> warning, no install, load completes" {
  local bin="$FIXTURE_HOME/bin"
  local q_bin q_plugin snippet
  mkdir -p "$bin"
  # mpg123 present (symlinked), gomplate absent (not in this dir) ...
  ln -s "$(type -P mpg123)" "$bin/mpg123"
  export ZSH_NOTIFY_PROVIDER=noti
  printf -v q_bin '%q' "$bin"
  printf -v q_plugin '%q' "$NOTIFY_MODULE_DIR/plugin.zsh"
  snippet="PATH=${q_bin}
source ${q_plugin} && print -r -- LOADED"

  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"

  [ "$status" -eq 0 ]
  [[ "$output" == *LOADED* ]]
  [[ "$output" == *"gomplate missing"* ]]
  [[ "$output" == *"core::install gomplate"* ]]
  # mpg123 IS on PATH here, so its warning must NOT fire
  [[ "$output" != *"mpg123 missing"* ]]
  # no install attempted
  [ ! -e "$CORE_LOG" ]
}

# Branch guard for the same task: the gomplate check runs only in the noti
# branch — with another provider the module loads without requiring it.
@test "3.2 branch guard: provider=notify-send never checks gomplate at load" {
  local bin="$FIXTURE_HOME/bin"
  local q_bin q_plugin snippet
  mkdir -p "$bin"
  ln -s "$(type -P mpg123)" "$bin/mpg123"
  export ZSH_NOTIFY_PROVIDER=notify-send
  printf -v q_bin '%q' "$bin"
  printf -v q_plugin '%q' "$NOTIFY_MODULE_DIR/plugin.zsh"
  snippet="PATH=${q_bin}
source ${q_plugin} && print -r -- LOADED"

  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"

  [ "$status" -eq 0 ]
  [[ "$output" == *LOADED* ]]
  [[ "$output" != *gomplate* ]]
  [[ "$output" != *"mpg123 missing"* ]]
  [ ! -e "$CORE_LOG" ]
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 3.3 — no core::ensure / core::install left on the load path
# ─────────────────────────────────────────────────────────────────────────────

# The three cases above are the runtime proof (the recording stub would
# have logged any call from config/main, internal/main or pkg). The static
# proof is the grep asserted in the group report:
#   grep -rn "core::ensure" zsh/modules/notify/
# matches nothing outside the test helper's recording stub — in particular
# nothing in internal/main.zsh or plugin.zsh.

# ─────────────────────────────────────────────────────────────────────────────
# Task 5.2 (zmodload half) — zsh/datetime on the notify load path
# ─────────────────────────────────────────────────────────────────────────────

# Spec requirement "Prompt hooks avoid per-prompt process forks" needs
# EPOCHSECONDS from zsh/datetime; design D7 + migration step 1 pin the
# zmodload in internal/main.zsh (zshrc only loads it in the darwin compinit
# branch, so notify must not rely on that).
@test "5.2 sourcing internal/main.zsh under zsh -f leaves EPOCHSECONDS a usable integer" {
  local q_main snippet
  printf -v q_main '%q' "$NOTIFY_MODULE_DIR/internal/main.zsh"
  snippet="source ${q_main} || exit 1
[[ \"\$EPOCHSECONDS\" == <-> ]] || exit 2
print -r -- \"EPOCH=\$EPOCHSECONDS\""

  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"

  [ "$status" -eq 0 ]
  [[ "$output" =~ EPOCH=[0-9]+ ]]
}
