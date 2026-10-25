#!/usr/bin/env bats
# Acceptance tests for the prompt hooks in notify::internal (store/completed
# called through the pkg wrapper) — OpenSpec fix-notify-terminal-freeze
# tasks 5.1–5.5.
#
# Contract: openspec/changes/fix-notify-terminal-freeze/specs/notify-prompt-safety/spec.md
#   - Skip-list filters interactive commands          (5.1)
#   - Completion notifications keep the 10-second threshold (5.3)
#   - Exit status is captured through the hook wrapper (5.4)
#   - Prompt hooks avoid per-prompt process forks     (5.2)
#
# Clock control: EPOCHSECONDS is a READ-ONLY zsh special (zsh/datetime), so
# the threshold tests drive timediff through the STORED start time — after
# notify::test::align_second pins the clock to a fresh second, overriding
# `_zsh_notify_start_time = EPOCHSECONDS - N` makes completed() compute
# exactly N (10: no notification, 11: dispatch). That pins the strict `>`
# boundary without sleeping 10 s and without stubbing anything the code reads.

load "${BATS_TEST_DIRNAME}/test_helper.bash"

setup() {
  NOTIFY_FIXTURE_HOME="$(make_notify_tmpdir)"
  NOTIFY_FIXTURE_WORK="$(make_notify_tmpdir)"
  NOTIFY_MARKER="${NOTIFY_FIXTURE_HOME}/mpg123.record"
  NOTIFY_DATE_MARKER="${NOTIFY_FIXTURE_HOME}/date.marker"
  # A real dispatch must never reach the system mpg123: the fake is always
  # first on PATH so play() spawns the recorder instead.
  install_fake_mpg123 "$NOTIFY_MARKER" exit
}

teardown() {
  notify_kill_recorded_pids "$NOTIFY_MARKER"
  cleanup_fake_mpg123
  cleanup_date_marker
  cleanup_notify_tmpdir "$NOTIFY_FIXTURE_HOME"
  cleanup_notify_tmpdir "$NOTIFY_FIXTURE_WORK"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 5.1 — skip-list conditional and recording
# ─────────────────────────────────────────────────────────────────────────────

@test "5.1 internal/base.zsh uses the documented [[ -regex-match ]] conditional" {
  local base_file="${NOTIFY_MODULE_DIR}/internal/base.zsh"
  # Presence: the documented double-bracket form (D6)
  grep -Fq 'if [[ "${1}" -regex-match "${_ZSH_NOTIFY_RE_SKIP_COMMANDS}" ]]; then' "$base_file"
  # Absence: the old single-bracket form is gone. Anchored on `if [ ` so the
  # new `[[ ` line cannot match it (it contains `[ ` as a substring).
  run grep -Fq 'if [ "${1}" -regex-match' "$base_file"
  [ "$status" -eq 1 ]
}

@test "5.1 ssh/vim/tmux commands are skipped (no notification)" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"
    notify::internal::popup() { print -r -- "POPUP|${1}|${2}|${3}"; }
    notify::command::store "ssh myhost"
    notify::command::store "vim notes.txt"
    notify::command::store "tmux attach -t work"
    # Read BEFORE completed(): the hook unsets the record on its way out, so
    # post-hook state cannot distinguish "skipped" from "recorded then wiped".
    print "last=${_zsh_notify_last_command:-UNSET}"
    print "start=${_zsh_notify_start_time:-EMPTY}"
    notify::command::completed
    print "done"
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "last=UNSET"
  printf "%s\n" "$output" | grep -qx "start=EMPTY"
  # no completion notification for any of the three
  ! grep -q "^POPUP|" <<<"$output"
}

@test "5.1 non-matching command is recorded" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"
    notify::command::store "ls -la /tmp"
    print "last=${_zsh_notify_last_command:-UNSET}"
    print "start=${_zsh_notify_start_time:-EMPTY}"
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "last=ls -la /tmp"
  # the start time is an epoch-seconds value (EPOCHSECONDS, no date fork)
  start="$(printf "%s\n" "$output" | sed -n "s/^start=//p")"
  [[ "$start" =~ ^[0-9]+$ ]]
  [ "$start" -gt 1700000000 ]
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 5.3 — the strict 10-second threshold
# ─────────────────────────────────────────────────────────────────────────────

@test "5.3 timediff == 10 -> no notification" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"
    notify::internal::popup() { print -r -- "POPUP|${1}|${2}|${3}"; }
    print "threshold=${_ZSH_NOTIFY_TIME_THRESHOLD}"
    notify::command::store "make build"
    notify::test::align_second
    _zsh_notify_start_time=$(( EPOCHSECONDS - 10 ))
    true
    notify::command::completed
    print "done"
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "threshold=10"
  printf "%s\n" "$output" | grep -qx "done"
  # strict `>`: at exactly the threshold nothing is dispatched
  ! grep -q "^POPUP|" <<<"$output"
  # ...and the sound player was never spawned for it
  found=no
  for _ in 1 2 3 4 5 6; do
    if [ -f "$NOTIFY_MARKER" ]; then
      found=yes
      break
    fi
    sleep 0.05
  done
  [ "$found" = "no" ]
}

@test "5.3 timediff 11 -> success notification dispatched through the provider" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"
    notify::internal::popup() { print -r -- "POPUP|${1}|${2}|${3}"; }
    notify::command::store "make build"
    notify::test::align_second
    _zsh_notify_start_time=$(( EPOCHSECONDS - 11 ))
    true
    notify::command::completed
  '
  [ "$status" -eq 0 ]
  # the popup fired through the success path with the exact duration
  printf "%s\n" "$output" | grep -qx "POPUP|make build|The command succeeded after 11 seconds|success.jpg"
  # ...and the sound went out through the configured theme (provider dispatch)
  poll=no
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    if [ -f "$NOTIFY_MARKER" ]; then
      poll=yes
      break
    fi
    sleep 0.05
  done
  [ "$poll" = "yes" ]
  grep -q "r2d2/success.mp3" "$NOTIFY_MARKER"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 5.4 — $? through the pkg wrapper (pkg/base.zsh -> internal/base.zsh:18)
# ─────────────────────────────────────────────────────────────────────────────

@test "5.4 failing command -> error notification carries its exit code" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"
    notify::internal::popup() { print -r -- "POPUP|${1}|${2}|${3}"; }
    notify::command::store "make all"
    notify::test::align_second
    _zsh_notify_start_time=$(( EPOCHSECONDS - 11 ))
    (exit 42)
    notify::command::completed
  '
  [ "$status" -eq 0 ]
  # error path, exit code 42 intact through pkg/base.zsh -> internal:18
  printf "%s\n" "$output" | grep -qx "POPUP|make all|The command failed after 11 seconds with code: 42|error.png"
}

@test "5.4 succeeding command -> success path" {
  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"
    notify::internal::popup() { print -r -- "POPUP|${1}|${2}|${3}"; }
    notify::command::store "make ok"
    notify::test::align_second
    _zsh_notify_start_time=$(( EPOCHSECONDS - 11 ))
    (exit 0)
    notify::command::completed
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "POPUP|make ok|The command succeeded after 11 seconds|success.jpg"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 5.2 — no date fork across a preexec+precmd cycle
# ─────────────────────────────────────────────────────────────────────────────

@test "5.2 no date fork per prompt cycle" {
  # The date marker is installed as late as possible: only THIS cycle's
  # hooks are under measurement (bats' own date usage would land outside
  # the install->assert window by construction).
  install_date_marker "$NOTIFY_DATE_MARKER"

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"
    notify::internal::popup() { print -r -- "POPUP|${1}|${2}|${3}"; }
    notify::command::store "make build"
    notify::test::align_second
    _zsh_notify_start_time=$(( EPOCHSECONDS - 11 ))
    true
    notify::command::completed
  '
  [ "$status" -eq 0 ]
  # anti-vacuous: the full cycle really ran — store + completed + dispatch
  printf "%s\n" "$output" | grep -qx "POPUP|make build|The command succeeded after 11 seconds|success.jpg"
  # the hook cycle forked no `date`: the marker shim never fired
  [ ! -f "$NOTIFY_DATE_MARKER" ]
}
