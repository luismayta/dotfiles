#!/usr/bin/env bats
#
# hrd::project launcher exit-code coverage against the MOCKED herdr binary.
# OpenSpec refactor-herdr-module, task 1.6; spec: herdr-test-suite,
# "Launcher exit-code coverage against mocked herdr".
#
# The four spec scenarios, each asserting the EXACT exit code:
#   attach to an existing workspace -> 0
#   create a new workspace          -> 0
#   decline creation                -> 0
#   hard workspace-create failure   -> 1
#
# Label contract: EXPECTED_LABEL is computed INDEPENDENTLY from the fixture
# path (a bash mirror of derive_project_name's documented branch-3 + slug
# rules) and fed to the mock, so if derivation ever drifts from the fixture
# the create-path assertions fail loudly instead of matching by luck.
#
# How the prompt-driven cases actually reach their branches (verified in
# this sandbox: zsh 5.9.1, util-linux script 2.42.2 — see task report):
#   * `read -q` reads from the TERMINAL (zsh manual: "Input is read from
#     the terminal unless one of -u or -p is present"), never from piped
#     stdin: without a terminal it fails with "not interactive and can't
#     open terminal" and leaves $REPLY empty — and empty counts as "yes"
#     in workspace_attach_or_create, so piped stdin can never reach the
#     decline branch. The two prompt cases therefore run through
#     run_herdr_zsh_pty (test_helper.bash), which executes the zsh
#     subshell under a script(1) pty with the dialect probed at runtime
#     (util-linux `script -qec` vs BSD/macOS `script -q /dev/null`) and
#     fails loudly — never skips — if no pty runner works.
#   * Keystroke delivery is PROVEN, not assumed: zsh 5.9's `read -q`
#     answers EOF / undelivered input with REPLY='n' as well (verified),
#     so "REPLY=[n] + no focus + exit 0" alone would let the decline case
#     pass on a dead prompt. Both prompt cases therefore feed TWO
#     keystrokes and PROBE_SNIPPET reads the second one as a sentinel
#     after the launcher returns: SENTINEL_REPLY=[y] only happens if the
#     pty delivered input in order, and the per-branch mock-log assertions
#     (focus invoked vs never invoked) are what separate attach from
#     decline.
#   * The helper mock's `workspace list` JSON originally closed with `]}`
#     instead of `]}}`; jq failed with "Unfinished JSON term at EOF",
#     workspace_exists never matched, and both prompt cases silently fell
#     through to the create path (exit 0 by luck). Fixed in
#     test_helper.bash.

load test_helper

# This bats build does not define `fail` in the test process (verified with
# `type fail`; only the pretty formatter defines it), so provide a local
# equivalent: print the diagnostic to stderr and return 1 — under
# `assertion || fail "..."` the non-zero status fails the test.
fail() {
  printf '%s\n' "$*" >&2
  return 1
}

# Mirror of hrd::internal::derive_project_name's documented rules for the
# third derivation branch ({parent_dir}-{current_dir}) plus slug normalization
# (non-alphanumeric -> '-', collapse repeated hyphens, strip leading/trailing
# hyphen, lowercase), computed from the fixture path WITHOUT calling the code
# under test so derivation drift breaks the suite.
derive_expected_label() {
  local work_dir="$1" parent_base current raw
  parent_base="$(basename "$(dirname "$work_dir")")"
  current="$(basename "$work_dir")"
  raw="${parent_base}-${current}"
  raw="$(printf '%s' "$raw" | sed 's/[^A-Za-z0-9]/-/g')"
  while [[ "$raw" == *--* ]]; do raw="${raw//--/-}"; done
  raw="${raw#-}"
  raw="${raw%-}"
  printf '%s\n' "${raw,,}"
}

# Zsh snippet used by BOTH prompt-driven cases: run the launcher, snapshot
# its exit status and the REPLY the production prompt recorded (REPLY is a
# zsh global — workspace_attach_or_create never localizes it), then consume
# ONE more keystroke as a delivery sentinel, print all three, and exit with
# the launcher's status so bats' `run` sees the real exit code.
#
# Why the sentinel: zsh 5.9's `read -q` reports EOF / undelivered input as
# REPLY='n' too (verified), so REPLY=[n] alone cannot prove that OUR 'n'
# was delivered — the decline case would pass on a dead prompt. The sentinel
# must come back [y], which only happens when the pty delivered both fed
# keystrokes to the terminal in order.
PROBE_SNIPPET='hrd::project
herdr_rc=$?
herdr_reply=$REPLY
read -q "?sentinel? "
sentinel_reply=$REPLY
print ""
print "HERDR_RC=$herdr_rc HERDR_REPLY=[$herdr_reply] SENTINEL_REPLY=[$sentinel_reply]"
exit $herdr_rc'

setup() {
  # Two separate tmpdirs: HOME_DIR must not be WORK_DIR's parent, otherwise
  # derive_project_name would take the core-/HOME branch instead of branch 3.
  FIXTURE_ROOT="$(make_herdr_tmpdir)"
  WORK_DIR="$FIXTURE_ROOT/project"
  mkdir -p "$WORK_DIR"
  HOME_DIR="$(make_herdr_tmpdir)"
  install_mock_herdr
  MOCK_LOG="$FIXTURE_ROOT/herdr-calls.log"
  export HERDR_MOCK_LOG="$MOCK_LOG"
  : >"$MOCK_LOG"
  unset HERDR_MOCK_LIST_LABELS HERDR_MOCK_CREATE_FAIL \
    HERDR_MOCK_CREATE_ID HERDR_MOCK_FOCUS_EXIT
  EXPECTED_LABEL="$(derive_expected_label "$WORK_DIR")"
}

teardown() {
  cleanup_mock_herdr
  cleanup_herdr_tmpdir "$FIXTURE_ROOT"
  cleanup_herdr_tmpdir "$HOME_DIR"
}

# Spec scenario: "Attaching to existing workspace returns 0".
# Mock setup: workspace list CONTAINS the derived label; the pty feeds 'y'
# to the attach prompt (plus the sentinel 'y' PROBE_SNIPPET reads after the
# launcher returns). Branch proof — attach is distinguished from decline and
# from create by observable side effects:
#   * `herdr workspace focus ws_<label>` WAS invoked (switch_workspace ran)
#   * `workspace create` was NEVER invoked (no fall-through to create)
#   * the prompt text is present (workspace_exists matched), REPLY is the
#     fed 'y', the sentinel keystroke arrived, and the exit status is 0
#     both as the process status and as HERDR_RC inside the output.
@test "hrd::project: attaching to an existing workspace exits 0" {
  export HERDR_MOCK_LIST_LABELS="$EXPECTED_LABEL"

  run run_herdr_zsh_pty "$HOME_DIR" "$WORK_DIR" "$PROBE_SNIPPET" 'yy'

  [ "$status" -eq 0 ] || fail "expected exit 0 for attach, got $status: $output"
  [[ "$output" == *"HERDR_RC=0"* ]] ||
    fail "hrd::project did not exit 0 inside the zsh snippet: $output"
  [[ "$output" == *"A herdr workspace \"${EXPECTED_LABEL}\" already exists"* ]] ||
    fail "attach prompt never shown — workspace_exists did not match mocked label '${EXPECTED_LABEL}' (create-path fall-through?): $output"
  [[ "$output" == *"HERDR_REPLY=[y]"* ]] ||
    fail "attach prompt never received the fed 'y' keystroke (read -q REPLY): $output"
  [[ "$output" == *"SENTINEL_REPLY=[y]"* ]] ||
    fail "sentinel keystroke not delivered through the pty — keystroke delivery broken, attach proof void: $output"
  grep -qFx "workspace list" "$MOCK_LOG" ||
    fail "launcher never consulted herdr workspace list"
  grep -qFx "workspace focus ws_${EXPECTED_LABEL}" "$MOCK_LOG" ||
    fail "attach branch never invoked 'herdr workspace focus ws_${EXPECTED_LABEL}'; log:
$(cat "$MOCK_LOG")"
  if grep -qF "workspace create" "$MOCK_LOG"; then
    fail "attach case fell through to the create path; log:
$(cat "$MOCK_LOG")"
  fi
}

# Spec scenario: "Creating a workspace returns 0".
# Mock setup: workspace list is EMPTY -> workspace_attach_or_create returns 1
# -> create path: herdr workspace create, jq workspace_id, 3-pane layout,
# message_success as the final command (its status is the launcher's exit).
@test "hrd::project: creating a new workspace exits 0" {
  run run_herdr_zsh "$HOME_DIR" "$WORK_DIR" 'hrd::project' ''

  [ "$status" -eq 0 ] || fail "expected exit 0 for create, got $status: $output"
  grep -qFx "workspace create --label ${EXPECTED_LABEL} --cwd ${WORK_DIR} --focus" "$MOCK_LOG" ||
    fail "workspace create not invoked with the derived label '${EXPECTED_LABEL}'; log:
$(cat "$MOCK_LOG")"
  grep -q "pane split" "$MOCK_LOG" ||
    fail "setup_3_pane_layout did not split any pane; log:
$(cat "$MOCK_LOG")"
  [[ "$output" == *"SUCCESS: Project workspace '${EXPECTED_LABEL}' created."* ]] ||
    fail "message_success line missing (launcher did not reach the end of the create path): $output"
}

# Spec scenario: "Declining creation returns 0".
# Mock setup: workspace list CONTAINS the derived label; the pty feeds 'n'
# to the prompt (plus the sentinel 'y' PROBE_SNIPPET reads afterwards).
# Decline is a distinct path from attach (both must exit 0), so it keeps its
# own case with its own keystroke — never collapsed into the attach case.
# Branch proof — decline is distinguished from attach by observable side
# effects:
#   * `herdr workspace focus` was NEVER invoked (switch_workspace skipped)
#   * `workspace create` was NEVER invoked (no fall-through to create)
#   * the prompt text is present, REPLY is the fed 'n', the sentinel
#     keystroke 'y' arrived (which makes a dead prompt impossible: EOF
#     also reports REPLY=[n], so only the sentinel pins real delivery),
#     and the exit status is 0 as both the process status and HERDR_RC.
@test "hrd::project: declining creation exits 0" {
  export HERDR_MOCK_LIST_LABELS="$EXPECTED_LABEL"

  run run_herdr_zsh_pty "$HOME_DIR" "$WORK_DIR" "$PROBE_SNIPPET" 'ny'

  [ "$status" -eq 0 ] || fail "expected exit 0 for decline, got $status: $output"
  [[ "$output" == *"HERDR_RC=0"* ]] ||
    fail "hrd::project did not exit 0 inside the zsh snippet: $output"
  [[ "$output" == *"A herdr workspace \"${EXPECTED_LABEL}\" already exists"* ]] ||
    fail "decline prompt never shown — workspace_exists did not match mocked label '${EXPECTED_LABEL}' (create-path fall-through?): $output"
  [[ "$output" == *"HERDR_REPLY=[n]"* ]] ||
    fail "decline prompt never received the fed 'n' keystroke (read -q REPLY): $output"
  [[ "$output" == *"SENTINEL_REPLY=[y]"* ]] ||
    fail "sentinel keystroke not delivered through the pty — keystroke delivery broken, decline proof void: $output"
  grep -qFx "workspace list" "$MOCK_LOG" ||
    fail "launcher never consulted herdr workspace list"
  if grep -qF "workspace focus" "$MOCK_LOG"; then
    fail "decline case wrongly invoked 'herdr workspace focus' (attach branch taken); log:
$(cat "$MOCK_LOG")"
  fi
  if grep -qF "workspace create" "$MOCK_LOG"; then
    fail "decline case fell through to the create path; log:
$(cat "$MOCK_LOG")"
  fi
}

# Spec scenario: "Hard failure returns 1".
# Mock setup: workspace list EMPTY and `herdr workspace create` forced to fail
# -> hrd::project hits message_error and returns 1 (helper.zsh:119-122).
@test "hrd::project: hard workspace-create failure exits 1" {
  export HERDR_MOCK_CREATE_FAIL=1

  run run_herdr_zsh "$HOME_DIR" "$WORK_DIR" 'hrd::project' ''

  [ "$status" -eq 1 ] || fail "expected exit 1 for hard failure, got $status: $output"
  grep -qFx "workspace create --label ${EXPECTED_LABEL} --cwd ${WORK_DIR} --focus" "$MOCK_LOG" ||
    fail "workspace create was never attempted; log:
$(cat "$MOCK_LOG")"
  [[ "$output" == *"Failed to create workspace '${EXPECTED_LABEL}'"* ]] ||
    fail "message_error branch not taken for label '${EXPECTED_LABEL}': $output"
}
