#!/usr/bin/env bats
# Acceptance tests for notify::internal::play.
# OpenSpec change: fix-notify-terminal-freeze — tasks 2.1–2.6.
#
# Contract: openspec/changes/fix-notify-terminal-freeze/specs/notify-prompt-safety/spec.md
#   - Sound playback never blocks the prompt        (2.1, 2.3)
#   - Sound playback never touches the terminal     (2.2)
#   - Sound playback is hard-bounded with SIGKILL   (2.4)
#   - Only one playback runs at a time              (2.5)
#
# CRITICAL: the function under test is zsh code — every invocation goes
# through run_notify_zsh / run_notify_zsh_pty (real `zsh -f` subshells),
# never through bash. Assertions about the player read the marker file
# install_fake_mpg123 records (argv, pid, stdin state, parent comm/cmdline).

load "${BATS_TEST_DIRNAME}/test_helper.bash"

setup() {
  NOTIFY_FIXTURE_HOME="$(make_notify_tmpdir)"
  NOTIFY_FIXTURE_WORK="$(make_notify_tmpdir)"
  NOTIFY_MARKER="${NOTIFY_FIXTURE_HOME}/mpg123.record"
  NOTIFY_DECOY_MARKER="${NOTIFY_FIXTURE_HOME}/decoy.record"
  NOTIFY_WHITELIST_DIR=""
  # Exported so the zsh -f subshell (run_notify_zsh) can resolve
  # ${NOTIFY_DECOY_MARKER} — the singleton test's decoy spawn writes to it.
  export NOTIFY_MARKER NOTIFY_DECOY_MARKER
}

teardown() {
  # Reap every fake player THIS test spawned — pids recorded in the markers,
  # never pkill by name (a peer's suite may run concurrently) — then release
  # fixtures and PATH shims. Runs on pass AND fail.
  notify_kill_recorded_pids "$NOTIFY_MARKER" "$NOTIFY_DECOY_MARKER"
  cleanup_fake_mpg123
  if [[ -n "${NOTIFY_WHITELIST_DIR:-}" && -d "${NOTIFY_WHITELIST_DIR}" ]]; then
    rm -rf "${NOTIFY_WHITELIST_DIR}"
  fi
  cleanup_notify_tmpdir "$NOTIFY_FIXTURE_HOME"
  cleanup_notify_tmpdir "$NOTIFY_FIXTURE_WORK"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 2.1 — presence check
# ─────────────────────────────────────────────────────────────────────────────

@test "2.1 player missing -> status 0, no process spawned" {
  install_fake_mpg123 "$NOTIFY_MARKER" exit
  # A whitelist PATH: no mpg123 anywhere, but bash/tr/readlink/sleep/pgrep
  # available so a BROKEN presence check would fall through to the timeout
  # resolution (warning) and the spawn (marker) instead of passing silently.
  NOTIFY_WHITELIST_DIR="$(make_notify_path_whitelist bash tr readlink sleep pgrep)"
  export NOTIFY_WHITELIST_DIR

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    PATH="${NOTIFY_WHITELIST_DIR}"
    notify::internal::play "/fake/sounds/success.mp3"
    print "status=$?"
  '
  [ "$status" -eq 0 ]
  # Exact match: any extra line — a degrade WARNING from reaching the timeout
  # resolution, an exec error — means the flow did not stop at the presence
  # check as the spec requires.
  [ "$output" = "status=0" ]

  # The stub must never have run: poll long enough for a backgrounded spawn
  # to land, then require the marker to still be absent.
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

# ─────────────────────────────────────────────────────────────────────────────
# Task 2.2 — flags, stdin, disown
# ─────────────────────────────────────────────────────────────────────────────

@test "2.2 flags and stdin: --no-control -q, stdin /dev/null, under timeout, disowned" {
  install_fake_mpg123 "$NOTIFY_MARKER" hang

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    notify::internal::play "/fake/sounds/success.mp3"
    print "status=$?"
    # let the backgrounded stub record argv/stdin/parent
    for i in {1..40}; do
      if [[ -s "${NOTIFY_FAKE_MPG123_LOG}" ]]; then
        break
      fi
      sleep 0.05
    done
    print -- "--- jobs ---"
    jobs
    print -- "--- end jobs ---"
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "status=0"
  # mandatory flags, in order, ahead of the sound path (D1/D2)
  grep -q "^argv: --no-control -q " "$NOTIFY_MARKER"
  # stdin detached from the tty — never the interactive terminal (D2)
  grep -qx "stdin-tty: no" "$NOTIFY_MARKER"
  grep -qx "stdin-link: /dev/null" "$NOTIFY_MARKER"
  # hard-bound wrapper actually present, configured -k 2 8 (D3)
  grep -qx "parent-comm: timeout" "$NOTIFY_MARKER"
  grep -q "timeout -k 2 8 mpg123 --no-control -q " "$NOTIFY_MARKER"
  # disowned: after play returns the job table must be empty — a player left
  # in `jobs` would mean `&!` degraded to a plain `&` (D1)
  jobs_section="${output#*--- jobs ---}"
  if printf "%s\n" "$jobs_section" | grep -q "mpg123"; then
    echo "FAIL: player still present in the job table: ${jobs_section}"
    false
  fi
}

@test "2.2 pty: icanon and echo still enabled after play" {
  install_fake_mpg123 "$NOTIFY_MARKER" exit

  # Real terminal via script(1): the terminal-state results travel through a
  # file in $PWD (the fixture workdir) so the assertions do not depend on
  # how script(1) relays stdout (dialects differ).
  run run_notify_zsh_pty "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    before="$(stty -g)"
    notify::internal::play "/fake/sounds/success.mp3"
    rc=$?
    after="$(stty -g)"
    if [[ "${before}" == "${after}" ]]; then
      state=same
    else
      state=changed
    fi
    icanon=absent
    echo_mode=absent
    modes="$(stty -a)"
    for t in ${=modes}; do
      case "${t}" in
        icanon) icanon=on ;;
        -icanon) icanon=off ;;
        echo) echo_mode=on ;;
        -echo) echo_mode=off ;;
      esac
    done
    {
      print "status=${rc}"
      print "state=${state}"
      print "icanon=${icanon} echo=${echo_mode}"
    } >| pty.results
  '
  [ "$status" -eq 0 ]
  grep -qx "status=0" "$NOTIFY_FIXTURE_WORK/pty.results"
  grep -qx "state=same" "$NOTIFY_FIXTURE_WORK/pty.results"
  grep -qx "icanon=on echo=on" "$NOTIFY_FIXTURE_WORK/pty.results"
  # Under a pty the stub's stdin would be the TTY if </dev/null were missing:
  poll=no
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    if [ -f "$NOTIFY_MARKER" ]; then
      poll=yes
      break
    fi
    sleep 0.1
  done
  [ "$poll" = "yes" ]
  grep -qx "stdin-tty: no" "$NOTIFY_MARKER"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 2.3 — always 0, non-blocking
# ─────────────────────────────────────────────────────────────────────────────

@test "2.3 returns in <1 s against a 30 s stub, status 0" {
  install_fake_mpg123 "$NOTIFY_MARKER" hang

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    t0=$EPOCHREALTIME
    notify::internal::play "/fake/sounds/success.mp3"
    rc=$?
    t1=$EPOCHREALTIME
    print "status=${rc}"
    if (( t1 - t0 < 1 )); then
      print "fast=yes"
    else
      print "fast=no"
    fi
    printf "elapsed=%.3f\n" "$(( t1 - t0 ))"
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "status=0"
  printf "%s\n" "$output" | grep -qx "fast=yes"
}

@test "2.3 player exits non-zero -> status 0 and the next precmd_functions entry still runs" {
  install_fake_mpg123 "$NOTIFY_MARKER" fail

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    notify::internal::play "/fake/sounds/error.mp3"
    print "play_status=$?"

    # The precmd chain: a hook that returns non-zero aborts the rest — play
    # must not, no matter that the player exited 1.
    hook_ran=no
    next_hook() { hook_ran=yes; }
    precmd_functions=(notify::internal::play next_hook)
    for h in "${precmd_functions[@]}"; do
      "${h}" "/fake/sounds/error.mp3" || break
    done
    print "hook_ran=${hook_ran}"
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "play_status=0"
  printf "%s\n" "$output" | grep -qx "hook_ran=yes"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 2.4 — timeout -k 2 8 bound, and the no-timeout degrade path
# ─────────────────────────────────────────────────────────────────────────────

@test "2.4 SIGKILL fallback: trap-TERM player dies at the bound; play returned in <1 s" {
  install_fake_mpg123 "$NOTIFY_MARKER" ignore-term

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    t0=$EPOCHREALTIME
    notify::internal::play "/fake/sounds/success.mp3"
    rc=$?
    t1=$EPOCHREALTIME
    print "status=${rc}"
    if (( t1 - t0 < 1 )); then
      print "fast=yes"
    else
      print "fast=no"
    fi
    # Poll until the player is gone. Deadline 10.5 s from the call: the
    # 8 s + 2 s grace bound plus detection slack (poll granularity + pgrep
    # latency — a kill delivered at exactly 10.0 s can only be OBSERVED
    # after 10.0 s). The `timeout -k 2 8` in the marker pins the bound
    # itself; this loop pins that the SIGKILL actually lands.
    gone_at="TIMEOUT"
    while (( EPOCHREALTIME < t0 + 10.5 )); do
      if ! pgrep -u "$UID" -x mpg123 >/dev/null 2>&1; then
        gone_at=$(printf "%.3f" "$(( EPOCHREALTIME - t0 ))")
        break
      fi
      sleep 0.05
    done
    print "gone_at=${gone_at}"
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "status=0"
  printf "%s\n" "$output" | grep -qx "fast=yes"
  gone_at="$(printf "%s\n" "$output" | sed -n "s/^gone_at=//p")"
  [ -n "$gone_at" ]
  [ "$gone_at" != "TIMEOUT" ]
  # gone within the 10 s hard bound, whole seconds (8 s + 2 s grace)
  [ "${gone_at%%.*}" -le 10 ]
  # the bound was the configured one: SIGTERM at 8 s, SIGKILL at +2 s (D3)
  grep -qx "parent-comm: timeout" "$NOTIFY_MARKER"
  grep -q "timeout -k 2 8 mpg123 " "$NOTIFY_MARKER"
}

@test "2.4 no timeout/gtimeout -> detached spawn still happens, warned exactly once" {
  install_fake_mpg123 "$NOTIFY_MARKER" exit
  # Whitelist PATH: mpg123 present (fake dir first), timeout/gtimeout absent
  # — exactly the degrade branch of design D3/D8's risk note.
  NOTIFY_WHITELIST_DIR="$(make_notify_path_whitelist bash tr readlink sleep pgrep)"
  export NOTIFY_WHITELIST_DIR

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    PATH="${NOTIFY_MPG123_DIR}:${NOTIFY_WHITELIST_DIR}"
    notify::internal::play "/fake/sounds/success.mp3"
    print "status1=$?"
    notify::internal::play "/fake/sounds/success.mp3"
    print "status2=$?"
    for i in {1..40}; do
      if [[ -s "${NOTIFY_FAKE_MPG123_LOG}" ]]; then
        break
      fi
      sleep 0.05
    done
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "status1=0"
  printf "%s\n" "$output" | grep -qx "status2=0"
  # one-time warning: exactly one WARNING line across BOTH calls
  [ "$(grep -c "^WARNING:" <<<"$output")" -eq 1 ]
  # degraded but still detached: the player ran with the terminal-safe flags
  grep -q "^argv: --no-control -q " "$NOTIFY_MARKER"
  # ...without any bound wrapper (this is the degrade path, not a regression
  # to a stray wrapper name)
  ! grep -q "^parent-comm: timeout" "$NOTIFY_MARKER"
  ! grep -q "^parent-comm: gtimeout" "$NOTIFY_MARKER"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 2.5 — singleton guard
# ─────────────────────────────────────────────────────────────────────────────

@test "2.5 instance already running -> no second spawn, status 0" {
  install_fake_mpg123 "$NOTIFY_MARKER" hang

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    # A live player for this user, spawned directly; its own decoy record is
    # the proof that the instance existed for the guard to see.
    saved_log="${NOTIFY_FAKE_MPG123_LOG}"
    NOTIFY_FAKE_MPG123_LOG="${NOTIFY_DECOY_MARKER}"
    "${NOTIFY_MPG123_DIR}/mpg123" </dev/null >/dev/null 2>&1 &!
    NOTIFY_FAKE_MPG123_LOG="${saved_log}"
    visible=no
    for i in {1..50}; do
      if pgrep -u "$UID" -x mpg123 >/dev/null 2>&1; then
        visible=yes
        break
      fi
      sleep 0.05
    done
    print "visible=${visible}"
    notify::internal::play "/fake/sounds/success.mp3"
    print "status=$?"
    # a (buggy) spawn would land in the main marker shortly after
    for i in {1..10}; do
      if [[ -f "${NOTIFY_FAKE_MPG123_LOG}" ]]; then
        break
      fi
      sleep 0.05
    done
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "visible=yes"
  printf "%s\n" "$output" | grep -qx "status=0"
  # play must NOT have spawned: main marker absent, decoy recorded the
  # already-running instance
  [ ! -f "$NOTIFY_MARKER" ]
  grep -q "^pid:" "$NOTIFY_DECOY_MARKER"
}

@test "2.5 five rapid calls -> at most one live player, one spawn" {
  install_fake_mpg123 "$NOTIFY_MARKER" hang

  run run_notify_zsh "$NOTIFY_FIXTURE_HOME" "$NOTIFY_FIXTURE_WORK" '
    notify::internal::play "/fake/sounds/success.mp3"
    # The first spawn must become visible to the guard before the burst: the
    # fake rewrites its comm ~60 ms after fork and real prompt-to-prompt
    # gaps are at least this long (D4 — the live check reflects reality).
    settled=no
    for i in {1..50}; do
      if pgrep -u "$UID" -x mpg123 >/dev/null 2>&1; then
        settled=yes
        break
      fi
      sleep 0.05
    done
    print "settled=${settled}"
    # four more calls, back to back
    notify::internal::play "/fake/sounds/success.mp3"
    notify::internal::play "/fake/sounds/success.mp3"
    notify::internal::play "/fake/sounds/success.mp3"
    notify::internal::play "/fake/sounds/success.mp3"
    # let any (buggy) raced spawn land, then count
    sleep 0.5
    print "live=$(pgrep -c -u "$UID" -x mpg123)"
  '
  [ "$status" -eq 0 ]
  printf "%s\n" "$output" | grep -qx "settled=yes"
  printf "%s\n" "$output" | grep -qx "live=1"
  # exactly one spawn recorded across the five calls
  run grep -c "^argv:" "$NOTIFY_MARKER"
  [ "$status" -eq 0 ]
  [ "$output" = "1" ]
}
