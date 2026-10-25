#!/usr/bin/env bash
# shellcheck disable=SC2016
# Test helper for the notify module bats suite.
#
# CRITICAL (same rationale as the herdr helper): notify's zsh functions must
# execute inside a zsh subshell — every test runs the real code through
# run_notify_zsh (or run_notify_zsh_pty for anything that needs a terminal),
# never calls the functions from bash and never reimplements them.

set -e

# Repo root, resolved from this file (tests/ -> notify -> modules -> zsh -> root).
NOTIFY_TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
# Module dir, resolved from this file (tests/ -> notify).
NOTIFY_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export NOTIFY_TEST_ROOT NOTIFY_MODULE_DIR

# Print the zsh prelude: stubs the noisy dotfiles globals (so sourcing does
# not drag in the whole dotfiles stack), preloads zsh/regex exactly as
# internal/main.zsh does, and sources the module files under test. Snippets
# that need more (internal/main.zsh, plugin.zsh, the adapters) source them
# themselves inside the zsh subshell.
notify_zsh_prelude() {
  cat <<PRELUDE
# ── stubs for the dotfiles stack ──
message_error() { print -u2 -- "ERROR: \$*"; }
message_success() { print -- "SUCCESS: \$*"; }
message_warning() { print -u2 -- "WARNING: \$*"; }
message_info() { print -- "INFO: \$*"; }
core::exists() { command -v "\$1" >/dev/null 2>&1; }
# core::ensure / core::install: recording no-ops — startup must never install
# packages; export NOTIFY_STUB_CORE_LOG to capture any call for assertion.
core::ensure() { if [[ -n "\${NOTIFY_STUB_CORE_LOG:-}" ]]; then printf 'ensure %s\n' "\$1" >>"\$NOTIFY_STUB_CORE_LOG"; fi; }
core::install() { if [[ -n "\${NOTIFY_STUB_CORE_LOG:-}" ]]; then printf 'install %s\n' "\$1" >>"\$NOTIFY_STUB_CORE_LOG"; fi; }
export ZSH_NOTIFY_PATH="${NOTIFY_MODULE_DIR}"
# zmodload zsh/regex (internal/main.zsh:9) so [[ ... -regex-match ... ]] works
# even in snippets that skip internal/main.zsh.
zmodload zsh/regex
# zmodload zsh/datetime (mirrors the notify load path's line in
# internal/main.zsh) so EPOCHSECONDS/EPOCHREALTIME — the clock the hooks read
# — exist in every snippet, test-side only (product code never loads it here).
zmodload zsh/datetime
# Clock control for the threshold tests: EPOCHSECONDS is a READ-ONLY special,
# so the tests pin timediff by overriding the STORED start time instead.
# align_second waits until a tick just happened (<=10 ms ago) so the
# override+completed pair below cannot straddle the next tick — the integer
# difference is then exactly N (10: no notification, 11: dispatch).
notify::test::align_second() {
  local s0=$EPOCHSECONDS
  while (( EPOCHSECONDS == s0 )); do
    sleep 0.01
  done
}
# ── notify module files under test ──
source "${NOTIFY_MODULE_DIR}/config/base.zsh"
source "${NOTIFY_MODULE_DIR}/internal/base.zsh"
PRELUDE
}

# Run a zsh snippet with HOME=$1 and PWD=$2 (the cd happens INSIDE the zsh
# subshell because the code reads $PWD live), feeding optional stdin $4
# through a PIPE. Prints stdout and returns zsh's exit code — use bats' `run`
# to capture both without tripping errexit.
run_notify_zsh() {
  local home_dir="$1"
  local work_dir="$2"
  local snippet="$3"
  local stdin_data="${4-}"
  local quoted_dir zsh_code
  printf -v quoted_dir '%q' "$work_dir"
  zsh_code="$(notify_zsh_prelude)
cd -- ${quoted_dir} || exit 90
${snippet}"
  printf '%s' "$stdin_data" | HOME="$home_dir" zsh -f -c "$zsh_code"
}

# ── PATH shims ──────────────────────────────────────────────────────────────

# Install a fake `mpg123` at the front of PATH (dir kept in
# NOTIFY_MPG123_DIR). Records one entry per invocation to $1 — argv, its pid
# (the handle for kill/alive assertions, since pgrep can also miss a script),
# the stdin state (tty vs /dev/null vs pipe, via readlink of fd 0) and the
# PARENT process's comm + cmdline (proof of the `timeout -k 2 8` wrapper, or
# of the unbounded degrade path) — then runs the mode given as $2:
#   exit        instant exit 0 (the happy path / the "was it spawned" marker)
#   hang        ~30 s of 1 s sleep slices (the slow player — play must return
#               in <1 s; slices so a killed fake orphans at most a 1 s sleep)
#   fail        exit 1 (the non-zero player — play must still return 0)
#   ignore-term trap '' TERM, then loop — only SIGKILL can end it (timeout -k)
# The recording is also the spawn marker: file absent => player never ran.
# The shim rewrites its own comm to `mpg123` (see the MOCK body), so
# `pgrep -u "$UID" -x mpg123` sees it exactly like the real player.
install_fake_mpg123() {
  local record_file="$1"
  local mode="${2:-exit}"
  case "$mode" in
    exit | hang | fail | ignore-term) ;;
    *)
      printf 'ERROR: install_fake_mpg123: unknown mode %q (want: exit|hang|ignore-term)\n' "$mode" >&2
      return 2
      ;;
  esac
  NOTIFY_MPG123_DIR="$(mktemp -d)"
  cat >"${NOTIFY_MPG123_DIR}/mpg123" <<'MOCK'
#!/usr/bin/env bash
# Fake mpg123 installed by install_fake_mpg123. Scenario via env vars:
#   NOTIFY_FAKE_MPG123_LOG   file to append one invocation record to
#   NOTIFY_FAKE_MPG123_MODE  exit | fail | hang | ignore-term
# Rename this process's comm to mpg123: for a shebang script the kernel sets
# comm to the INTERPRETER (bash), so `pgrep -x mpg123` would never see the
# fake — and the singleton guard / SIGKILL-death assertions depend on it.
printf 'mpg123' >/proc/self/comm 2>/dev/null || true
{
  printf 'argv:'
  printf ' %q' "$@"
  printf '\n'
  printf 'pid: %s\n' "$$"
  if [ -t 0 ]; then
    printf 'stdin-tty: yes\n'
  else
    printf 'stdin-tty: no\n'
  fi
  printf 'stdin-link: %s\n' "$(readlink /proc/self/fd/0 2>/dev/null || printf unknown)"
  printf 'parent-comm: %s\n' "$(tr -d '\0' <"/proc/${PPID}/comm" 2>/dev/null || printf unknown)"
  printf 'parent-cmdline: %s\n' "$(tr '\0' ' ' <"/proc/${PPID}/cmdline" 2>/dev/null || printf unknown)"
} >>"${NOTIFY_FAKE_MPG123_LOG:?}"
# Terminal-control regression probe (design D2): the real player grabs the
# tty unless told not to — emulate that by clearing icanon+echo on the
# controlling terminal whenever --no-control is ABSENT. play() must always
# pass the flag, so this never fires under correct code; under a pty, code
# that drops the flag leaves the modes cleared and the pty test fails.
case " $* " in
  *" --no-control "*) ;;
  *)
    stty -icanon -echo </dev/tty >/dev/null 2>&1 || true
    ;;
esac
case "${NOTIFY_FAKE_MPG123_MODE:-exit}" in
  hang)
    # ~30 s total in 1 s slices: SIGKILL-ing this script orphans at most a
    # 1 s `sleep`, never a 30 s one (same rationale as ignore-term below).
    end=$((SECONDS + 30))
    while ((SECONDS < end)); do sleep 1; done
    ;;
  fail)
    exit 1
    ;;
  ignore-term)
    trap '' TERM
    # Never exec: the process must keep the mpg123 name (pgrep -x) so the
    # singleton guard tests see it. 1 s slices cap any orphaned sleep's
    # lifetime at 1 s if SIGKILL ends the script first.
    while :; do sleep 1; done
    ;;
  *)
    exit 0
    ;;
esac
MOCK
  chmod +x "${NOTIFY_MPG123_DIR}/mpg123"
  PATH="${NOTIFY_MPG123_DIR}:${PATH}"
  NOTIFY_FAKE_MPG123_LOG="$record_file"
  NOTIFY_FAKE_MPG123_MODE="$mode"
  export PATH NOTIFY_MPG123_DIR NOTIFY_FAKE_MPG123_LOG NOTIFY_FAKE_MPG123_MODE
}

# Remove the fake mpg123 dir installed by install_fake_mpg123 and drop it
# (and its scenario env) from the environment.
cleanup_fake_mpg123() {
  if [[ -n "${NOTIFY_MPG123_DIR:-}" && -d "$NOTIFY_MPG123_DIR" ]]; then
    PATH="${PATH#"${NOTIFY_MPG123_DIR}:"}"
    export PATH
    rm -rf "$NOTIFY_MPG123_DIR"
    unset NOTIFY_MPG123_DIR NOTIFY_FAKE_MPG123_LOG NOTIFY_FAKE_MPG123_MODE
  fi
}

# Install a `date` marker shim at the front of PATH (dir kept in
# NOTIFY_DATE_DIR): appends `date` to $1 on every invocation, then execs the
# REAL date, so code under test keeps working while the test can assert
# "zero date forks per prompt cycle" on the marker file.
install_date_marker() {
  local record_file="$1"
  # Resolve the real binary BEFORE the shim shadows it (type -P = files only).
  local real_date
  real_date="$(type -P date || true)"
  if [[ -z "$real_date" ]]; then
    printf 'ERROR: install_date_marker: no real date binary found on PATH.\n' >&2
    return 1
  fi
  NOTIFY_DATE_DIR="$(mktemp -d)"
  cat >"${NOTIFY_DATE_DIR}/date" <<'SHIM'
#!/usr/bin/env bash
# date marker shim installed by install_date_marker.
printf 'date\n' >>"${NOTIFY_FAKE_DATE_LOG:?}"
exec "${NOTIFY_FAKE_DATE_REAL:?}" "$@"
SHIM
  chmod +x "${NOTIFY_DATE_DIR}/date"
  PATH="${NOTIFY_DATE_DIR}:${PATH}"
  NOTIFY_FAKE_DATE_LOG="$record_file"
  NOTIFY_FAKE_DATE_REAL="$real_date"
  export PATH NOTIFY_DATE_DIR NOTIFY_FAKE_DATE_LOG NOTIFY_FAKE_DATE_REAL
}

# Remove the date marker shim installed by install_date_marker.
cleanup_date_marker() {
  if [[ -n "${NOTIFY_DATE_DIR:-}" && -d "$NOTIFY_DATE_DIR" ]]; then
    PATH="${PATH#"${NOTIFY_DATE_DIR}:"}"
    export PATH
    rm -rf "$NOTIFY_DATE_DIR"
    unset NOTIFY_DATE_DIR NOTIFY_FAKE_DATE_LOG NOTIFY_FAKE_DATE_REAL
  fi
}

# ── whitelist PATH + spawned-player reaping ─────────────────────────────────

# Build a temp dir holding symlinks ONLY to the named tools and print its
# path, so a test can set `PATH=$dir` to a PATH that deliberately lacks
# mpg123 (task 2.1 "player missing") or timeout/gtimeout (task 2.4 degrade
# path). Refuses to link mpg123 so a "player missing" whitelist can never
# accidentally contain the stub. Caller owns the dir — remove it with rm -rf.
make_notify_path_whitelist() {
  local dir t src
  dir="$(mktemp -d)"
  for t in "$@"; do
    if [[ "$t" == "mpg123" ]]; then
      printf 'ERROR: make_notify_path_whitelist: mpg123 must never be whitelisted (it is what the test strips)\n' >&2
      rm -rf "$dir"
      return 2
    fi
    # type -P = file lookup only (no functions/aliases), resolved BEFORE the
    # dir shadows nothing — symlinks are stable regardless.
    src="$(type -P "$t" || true)"
    if [[ -z "$src" ]]; then
      printf 'ERROR: make_notify_path_whitelist: %s not found on PATH\n' "$t" >&2
      rm -rf "$dir"
      return 2
    fi
    ln -s "$src" "$dir/$t"
  done
  printf '%s\n' "$dir"
}

# SIGKILL every fake player pid recorded as `pid: N` in the given marker
# files (those pids belong to players THIS test spawned — never pkill by
# name, a peer's suite may run concurrently) and wait until they are really
# gone. Tolerates missing files and already-dead pids: the hard bound or the
# test itself may have killed the player first. Always returns 0 so a reaped
# player never fails teardown.
notify_kill_recorded_pids() {
  local f pid i alive
  local -a pids=()
  for f in "$@"; do
    [[ -f "$f" ]] || continue
    while IFS=: read -r _key pid; do
      # IFS=: leaves the space after "pid: " in the field — trim it so the
      # digits-only regex can match and the pid is actually killable.
      pid="${pid#"${pid%%[![:space:]]*}"}"
      pid="${pid%"${pid##*[![:space:]]}"}"
      if [[ "${pid:-}" =~ ^[0-9]+$ ]]; then
        pids+=("$pid")
      fi
    done < <(grep '^pid:' "$f" || true)
  done
  for pid in "${pids[@]}"; do
    kill -9 "$pid" 2>/dev/null || true
  done
  # Up to 2 s for SIGKILL to land and init to reap the zombie.
  for ((i = 0; i < 20; i++)); do
    alive=0
    for pid in "${pids[@]}"; do
      if kill -0 "$pid" 2>/dev/null; then
        alive=1
      fi
    done
    if [[ "$alive" -eq 0 ]]; then
      return 0
    fi
    sleep 0.1
  done
  return 0
}

# ── pty mode (real terminal: icanon/echo assertions) ────────────────────────
# The "terminal modes preserved" scenario (play under a pty with icanon and
# echo enabled) needs a REAL terminal, which script(1) provides. Same two
# dialects and same hard-fail discipline as herdr's run_herdr_zsh_pty:
#
# script(1) has two dialects:
#   util-linux:  script -qec "<command>" /dev/null
#   BSD/macOS:   script -q /dev/null "<command>"
# The dialect is probed ONCE per process by notify_detect_pty_style with a
# command that must succeed, and the probe result is cached in
# NOTIFY_PTY_STYLE. If neither form works, the probe prints an explicit
# error naming both attempts and run_notify_zsh_pty returns 89. It never
# skips and never passes: a pty test that cannot run must fail loudly,
# because a skip would read as a pass (the very hole run.sh's guards exist
# to prevent).

# script(1) binary (overridable, e.g. NOTIFY_SCRIPT_BIN=/nonexistent to
# exercise the no-pty failure path).
NOTIFY_SCRIPT_BIN="${NOTIFY_SCRIPT_BIN:-script}"
# Detected dialect: "util-linux" | "bsd" | "" (empty until probed).
NOTIFY_PTY_STYLE="${NOTIFY_PTY_STYLE:-}"

# Probe script(1) dialects. On success sets NOTIFY_PTY_STYLE and returns 0;
# on failure prints an explicit error to stderr and returns 1.
notify_detect_pty_style() {
  [[ -n "$NOTIFY_PTY_STYLE" ]] && return 0

  local ul_status bsd_status bin_note=""
  if command -v "$NOTIFY_SCRIPT_BIN" >/dev/null 2>&1; then
    # `|| status=$?` keeps the probe from tripping this file's `set -e`.
    ul_status=0
    "$NOTIFY_SCRIPT_BIN" -qec 'exit 0' /dev/null </dev/null >/dev/null 2>&1 || ul_status=$?
    bsd_status=0
    "$NOTIFY_SCRIPT_BIN" -q /dev/null 'exit 0' </dev/null >/dev/null 2>&1 || bsd_status=$?
  else
    ul_status=127
    bsd_status=127
    bin_note=" (NOT FOUND on PATH — override with NOTIFY_SCRIPT_BIN)"
  fi

  if [[ "$ul_status" -eq 0 ]]; then
    NOTIFY_PTY_STYLE="util-linux"
    return 0
  fi
  if [[ "$bsd_status" -eq 0 ]]; then
    NOTIFY_PTY_STYLE="bsd"
    return 0
  fi

  {
    printf 'ERROR: notify test harness: no working pty runner — terminal-mode tests cannot run.\n'
    printf '  probed binary: %s%s\n' "$NOTIFY_SCRIPT_BIN" "$bin_note"
    printf '  util-linux form: %s -qec "exit 0" /dev/null -> exit %s\n' "$NOTIFY_SCRIPT_BIN" "$ul_status"
    printf '  BSD/macOS form:  %s -q /dev/null "exit 0"  -> exit %s\n' "$NOTIFY_SCRIPT_BIN" "$bsd_status"
    printf '  The icanon/echo preservation scenario needs a real pty and cannot run here.\n'
    printf '  Failing loudly instead of skipping: a skipped test would read as a pass.\n'
  } >&2
  return 1
}

# Run a zsh snippet with HOME=$1 and PWD=$2 under a REAL PTY (script(1)),
# feeding $4 as the pty's stdin — use this instead of run_notify_zsh for any
# snippet that inspects or drives the terminal (stty, icanon/echo checks).
#
# The child's exit code travels through a status file rather than script's
# own exit status: script(1) dialects differ in whether they propagate the
# command's exit code (and here the command is a runner script whose own
# status is that of its last `printf`), so the file is the only
# dialect-independent channel. Returns the zsh snippet's exit code —
# 89 if no pty runner is available, 88 if the runner never produced a
# status — both with an explicit error on stderr.
#
# PATH hygiene (cloned from herdr's run_herdr_zsh_pty — found the hard way
# there): script(1) spawns $SHELL -c "<command>", and a login-ish SHELL can
# source rc files that prepend ~/.local/bin ahead of the caller's PATH,
# silently un-shadowing a PATH shim (the fake mpg123). Two defenses:
# (1) run script with SHELL=/bin/sh so the wrapper shell sources no rc files
# at all; (2) the runner re-imposes the caller's exact PATH
# (NOTIFY_TEST_PATH) before starting zsh, which covers dialects that ignore
# $SHELL.
run_notify_zsh_pty() {
  local home_dir="$1"
  local work_dir="$2"
  local snippet="$3"
  local stdin_data="${4-}"

  notify_detect_pty_style || return 89

  local quoted_dir zsh_code
  printf -v quoted_dir '%q' "$work_dir"
  zsh_code="$(notify_zsh_prelude)
cd -- ${quoted_dir} || exit 90
${snippet}"

  local worktmp code_file runner_file status_file
  worktmp="$(mktemp -d)" || {
    printf 'ERROR: notify test harness: mktemp -d failed; cannot run pty snippet.\n' >&2
    return 88
  }
  code_file="$worktmp/snippet.zsh"
  runner_file="$worktmp/runner.sh"
  status_file="$worktmp/child.status"
  printf '%s' "$zsh_code" >"$code_file"
  # Runner: POSIX sh, executable so the path works as script(1)'s command
  # under BOTH dialects (sh -c parses it; direct exec honors the shebang).
  # Paths, fixture HOME and the caller's PATH arrive via the environment —
  # no quoting hazards.
  cat >"$runner_file" <<'RUNNER'
#!/bin/sh
# Generated by the notify bats helper: re-impose the caller's environment
# (script(1)'s wrapper shell may have rewritten PATH — see the helper's
# comment), run the fixture zsh snippet and record its exit status (see
# run_notify_zsh_pty for why a status file is used).
if [ -n "${NOTIFY_TEST_PATH:-}" ]; then
  PATH="$NOTIFY_TEST_PATH"
  export PATH
fi
HOME="$NOTIFY_TEST_HOME"
export HOME
zsh -f "$NOTIFY_TEST_CODE"
printf '%s' "$?" > "$NOTIFY_TEST_STATUS"
RUNNER
  chmod +x "$runner_file"

  local script_status=0
  case "$NOTIFY_PTY_STYLE" in
    util-linux)
      printf '%s' "$stdin_data" \
        | NOTIFY_TEST_HOME="$home_dir" NOTIFY_TEST_CODE="$code_file" \
          NOTIFY_TEST_STATUS="$status_file" NOTIFY_TEST_PATH="$PATH" \
          SHELL=/bin/sh \
          "$NOTIFY_SCRIPT_BIN" -qec "$runner_file" /dev/null \
        || script_status=$?
      ;;
    bsd)
      printf '%s' "$stdin_data" \
        | NOTIFY_TEST_HOME="$home_dir" NOTIFY_TEST_CODE="$code_file" \
          NOTIFY_TEST_STATUS="$status_file" NOTIFY_TEST_PATH="$PATH" \
          SHELL=/bin/sh \
          "$NOTIFY_SCRIPT_BIN" -q /dev/null "$runner_file" \
        || script_status=$?
      ;;
    *)
      # Unreachable: notify_detect_pty_style ran first and only yields the
      # two dialects above. Fail loudly rather than fall through silently.
      printf 'ERROR: notify test harness: unknown NOTIFY_PTY_STYLE %q\n' "$NOTIFY_PTY_STYLE" >&2
      rm -rf "$worktmp"
      return 88
      ;;
  esac

  local child_status
  child_status="$(cat "$status_file" 2>/dev/null || true)"
  if [[ "$child_status" =~ ^[0-9]+$ ]]; then
    rm -rf "$worktmp"
    return "$child_status"
  fi

  {
    printf 'ERROR: notify test harness: pty command never produced a child exit status.\n'
    printf '  script binary: %s (dialect: %s, script exit: %s)\n' \
      "$NOTIFY_SCRIPT_BIN" "$NOTIFY_PTY_STYLE" "$script_status"
    printf '  The terminal-mode tests cannot run without a working pty;\n'
    printf '  failing loudly instead of skipping (a skipped test would read as a pass).\n'
  } >&2
  rm -rf "$worktmp"
  return 88
}

# Create a temp fixture directory (fake $HOME, $PWD, ...); prints its path.
make_notify_tmpdir() {
  mktemp -d
}

# Remove a temp fixture directory created by make_notify_tmpdir.
cleanup_notify_tmpdir() {
  if [[ -n "${1:-}" && -d "$1" ]]; then
    rm -rf "$1"
  fi
}
