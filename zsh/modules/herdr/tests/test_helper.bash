#!/usr/bin/env bash
# Test helper for the herdr module bats suite.
#
# CRITICAL: herdr's zsh functions use zsh-only parameter expansions
# (${PWD:t}, ${PWD:h:t}, ${name:l}). In bash these are valid *substring*
# expansions that silently evaluate to empty strings, so every test MUST
# execute the real code inside a zsh subshell — never call the functions
# from bash and never reimplement them.

set -e

# Repo root, resolved from this file (tests/ -> herdr -> modules -> zsh -> root).
HERDR_TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
# Module dir, resolved from this file (tests/ -> herdr).
HERDR_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HERDR_TEST_ROOT HERDR_MODULE_DIR

# Print the zsh prelude: stubs the noisy dotfiles globals (so sourcing does
# not drag in the whole dotfiles stack) and sources the module files under test.
herdr_zsh_prelude() {
  cat <<PRELUDE
# ── stubs for the dotfiles stack ──
message_error() { print -u2 -- "ERROR: \$*"; }
message_success() { print -- "SUCCESS: \$*"; }
message_warning() { print -u2 -- "WARNING: \$*"; }
message_info() { print -- "INFO: \$*"; }
core::exists() { command -v "\$1" >/dev/null 2>&1; }
export ZSH_HERDR_PATH="${HERDR_MODULE_DIR}"
# ── herdr module files under test ──
source "${HERDR_MODULE_DIR}/config/base.zsh"
source "${HERDR_MODULE_DIR}/internal/base.zsh"
source "${HERDR_MODULE_DIR}/internal/workspace.zsh"
source "${HERDR_MODULE_DIR}/internal/pane.zsh"
source "${HERDR_MODULE_DIR}/internal/worktree.zsh"
source "${HERDR_MODULE_DIR}/pkg/lifecycle.zsh"
source "${HERDR_MODULE_DIR}/pkg/project.zsh"
source "${HERDR_MODULE_DIR}/pkg/config-editor.zsh"
source "${HERDR_MODULE_DIR}/pkg/plugin.zsh"
source "${HERDR_MODULE_DIR}/pkg/worktree.zsh"
PRELUDE
}

# Run a zsh snippet with HOME=$1 and PWD=$2 (the cd happens INSIDE the zsh
# subshell because the code reads $PWD/${PWD:t} live), feeding optional stdin
# $4 through a PIPE. Prints stdout and returns zsh's exit code — use bats'
# `run` to capture both without tripping errexit.
#
# NOTE: piped stdin CANNOT drive zsh's `read -q` prompts — `read -q` reads
# from the terminal only, so with a pipe it fails ("not interactive and
# can't open terminal") and leaves REPLY empty (and empty counts as "yes"
# in workspace_attach_or_create). Use run_herdr_zsh_pty below for any
# snippet that reaches a `read -q` prompt.
run_herdr_zsh() {
  local home_dir="$1"
  local work_dir="$2"
  local snippet="$3"
  local stdin_data="${4-}"
  local quoted_dir zsh_code
  printf -v quoted_dir '%q' "$work_dir"
  zsh_code="$(herdr_zsh_prelude)
cd -- ${quoted_dir} || exit 90
${snippet}"
  printf '%s' "$stdin_data" | HOME="$home_dir" zsh -f -c "$zsh_code"
}

# ── pty mode for prompt-driven snippets ───────────────────────────────────
# zsh's `read -q` (internal/workspace.zsh:80, hrd::internal::
# workspace_attach_or_create) reads from the TERMINAL, never from piped
# stdin: without a controlling terminal it fails with "not interactive and
# can't open terminal" and leaves REPLY empty — and empty REPLY counts as
# "yes" at workspace_attach_or_create:82, so a piped-'n' decline case would
# silently take the ATTACH path. The only way to drive the prompt for real
# is to run the zsh subshell under a pty, which script(1) provides.
#
# script(1) has two dialects:
#   util-linux:  script -qec "<command>" /dev/null
#   BSD/macOS:   script -q /dev/null "<command>"
# The dialect is probed ONCE per process by herdr_detect_pty_style with a
# command that must succeed, and the probe result is cached in
# HERDR_PTY_STYLE. If neither form works, the probe prints an explicit
# error naming both attempts and run_herdr_zsh_pty returns 89. It never
# skips and never passes: a prompt test that cannot run must fail loudly,
# because a skip would read as a pass (the very hole run.sh's guards exist
# to prevent).

# script(1) binary (overridable, e.g. HERDR_SCRIPT_BIN=/nonexistent to
# exercise the no-pty failure path).
HERDR_SCRIPT_BIN="${HERDR_SCRIPT_BIN:-script}"
# Detected dialect: "util-linux" | "bsd" | "" (empty until probed).
HERDR_PTY_STYLE="${HERDR_PTY_STYLE:-}"

# Probe script(1) dialects. On success sets HERDR_PTY_STYLE and returns 0;
# on failure prints an explicit error to stderr and returns 1.
herdr_detect_pty_style() {
  [[ -n "$HERDR_PTY_STYLE" ]] && return 0

  local ul_status bsd_status bin_note=""
  if command -v "$HERDR_SCRIPT_BIN" >/dev/null 2>&1; then
    # `|| status=$?` keeps the probe from tripping this file's `set -e`.
    ul_status=0
    "$HERDR_SCRIPT_BIN" -qec 'exit 0' /dev/null </dev/null >/dev/null 2>&1 || ul_status=$?
    bsd_status=0
    "$HERDR_SCRIPT_BIN" -q /dev/null 'exit 0' </dev/null >/dev/null 2>&1 || bsd_status=$?
  else
    ul_status=127
    bsd_status=127
    bin_note=" (NOT FOUND on PATH — override with HERDR_SCRIPT_BIN)"
  fi

  if [[ "$ul_status" -eq 0 ]]; then
    HERDR_PTY_STYLE="util-linux"
    return 0
  fi
  if [[ "$bsd_status" -eq 0 ]]; then
    HERDR_PTY_STYLE="bsd"
    return 0
  fi

  {
    printf 'ERROR: herdr test harness: no working pty runner — prompt-driven tests cannot run.\n'
    printf '  probed binary: %s%s\n' "$HERDR_SCRIPT_BIN" "$bin_note"
    printf '  util-linux form: %s -qec "exit 0" /dev/null -> exit %s\n' "$HERDR_SCRIPT_BIN" "$ul_status"
    printf '  BSD/macOS form:  %s -q /dev/null "exit 0"  -> exit %s\n' "$HERDR_SCRIPT_BIN" "$bsd_status"
    printf '  zsh `read -q` (internal/workspace.zsh) reads only from a real terminal,\n'
    printf '  so the attach/decline launcher tests need a pty and cannot run here.\n'
    printf '  Failing loudly instead of skipping: a skipped test would read as a pass.\n'
  } >&2
  return 1
}

# Run a zsh snippet with HOME=$1 and PWD=$2 under a REAL PTY (script(1)),
# feeding $4 as the pty's stdin so zsh's `read -q` prompts can consume it —
# use this instead of run_herdr_zsh for prompt-driven snippets.
#
# The child's exit code travels through a status file rather than script's
# own exit status: script(1) dialects differ in whether they propagate the
# command's exit code (and here the command is a runner script whose own
# status is that of its last `printf`), so the file is the only
# dialect-independent channel. Returns the zsh snippet's exit code —
# 89 if no pty runner is available, 88 if the runner never produced a
# status — both with an explicit error on stderr.
#
# PATH hygiene (found the hard way): script(1) spawns $SHELL -c "<command>",
# and on this box SHELL=zsh WITHOUT -f sources ~/.zshenv, whose uv/nix lines
# prepend ~/.local/bin — which contains the REAL herdr — ahead of the caller's
# PATH, silently un-shadowing the mock. Two defenses: (1) run script with
# SHELL=/bin/sh so the wrapper shell sources no rc files at all; (2) the
# runner re-imposes the caller's exact PATH (HERDR_TEST_PATH) before starting
# zsh, which covers dialects that ignore $SHELL.
run_herdr_zsh_pty() {
  local home_dir="$1"
  local work_dir="$2"
  local snippet="$3"
  local stdin_data="${4-}"

  herdr_detect_pty_style || return 89

  local quoted_dir zsh_code
  printf -v quoted_dir '%q' "$work_dir"
  zsh_code="$(herdr_zsh_prelude)
cd -- ${quoted_dir} || exit 90
${snippet}"

  local worktmp code_file runner_file status_file
  worktmp="$(mktemp -d)" || {
    printf 'ERROR: herdr test harness: mktemp -d failed; cannot run pty snippet.\n' >&2
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
# Generated by the herdr bats helper: re-impose the caller's environment
# (script(1)'s wrapper shell may have rewritten PATH — see the helper's
# comment), run the fixture zsh snippet and record its exit status (see
# run_herdr_zsh_pty for why a status file is used).
if [ -n "${HERDR_TEST_PATH:-}" ]; then
  PATH="$HERDR_TEST_PATH"
  export PATH
fi
HOME="$HERDR_TEST_HOME"
export HOME
zsh -f "$HERDR_TEST_CODE"
printf '%s' "$?" > "$HERDR_TEST_STATUS"
RUNNER
  chmod +x "$runner_file"

  local script_status=0
  case "$HERDR_PTY_STYLE" in
    util-linux)
      printf '%s' "$stdin_data" \
        | HERDR_TEST_HOME="$home_dir" HERDR_TEST_CODE="$code_file" \
          HERDR_TEST_STATUS="$status_file" HERDR_TEST_PATH="$PATH" \
          SHELL=/bin/sh \
          "$HERDR_SCRIPT_BIN" -qec "$runner_file" /dev/null \
        || script_status=$?
      ;;
    bsd)
      printf '%s' "$stdin_data" \
        | HERDR_TEST_HOME="$home_dir" HERDR_TEST_CODE="$code_file" \
          HERDR_TEST_STATUS="$status_file" HERDR_TEST_PATH="$PATH" \
          SHELL=/bin/sh \
          "$HERDR_SCRIPT_BIN" -q /dev/null "$runner_file" \
        || script_status=$?
      ;;
    *)
      # Unreachable: herdr_detect_pty_style ran first and only yields the
      # two dialects above. Fail loudly rather than fall through silently.
      printf 'ERROR: herdr test harness: unknown HERDR_PTY_STYLE %q\n' "$HERDR_PTY_STYLE" >&2
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
    printf 'ERROR: herdr test harness: pty command never produced a child exit status.\n'
    printf '  script binary: %s (dialect: %s, script exit: %s)\n' \
      "$HERDR_SCRIPT_BIN" "$HERDR_PTY_STYLE" "$script_status"
    printf '  The prompt-driven launcher tests cannot run without a working pty;\n'
    printf '  failing loudly instead of skipping (a skipped test would read as a pass).\n'
  } >&2
  rm -rf "$worktmp"
  return 88
}

# ── pty mode for EXTERNAL commands (the bin/ shims) ─────────────────────────
# The bin/ shims re-enter zsh THEMSELVES (`exec zsh -f -c 'source zshrc;
# hrdw::...'`), so they cannot run through run_herdr_zsh_pty, which executes
# a PRELUDE snippet inside ONE zsh subshell. This variant runs an arbitrary
# external command under the same script(1) pty — arguments:
#   $1 fixture HOME   $2 work dir (the runner cds there)   $3 stdin fed to
#   the pty (the `read -q` keystroke)   $4... the command to run
#
# Everything else mirrors run_herdr_zsh_pty deliberately:
#   * PATH hygiene — script(1)'s wrapper shell can source ~/.zshenv and put
#     the REAL ~/.local/bin herdr ahead of the mock, so SHELL=/bin/sh is set
#     AND the runner re-imposes the caller's exact PATH (HERDR_TEST_PATH);
#   * the child's exit code travels via a status file (script(1) dialects
#     differ in propagating it — see run_herdr_zsh_pty);
#   * returns 89 without a working pty runner, 88 on harness errors, and
#     prints explicit errors — it never skips (a skip reads as a pass).
run_herdr_cmd_pty() {
  local home_dir="$1"
  local work_dir="$2"
  local stdin_data="$3"
  shift 3

  herdr_detect_pty_style || return 89

  if [[ $# -lt 1 ]]; then
    printf 'ERROR: herdr test harness: run_herdr_cmd_pty: no command given ($4...).\n' >&2
    return 88
  fi

  local worktmp runner_file status_file
  worktmp="$(mktemp -d)" || {
    printf 'ERROR: herdr test harness: mktemp -d failed; cannot run pty command.\n' >&2
    return 88
  }
  runner_file="$worktmp/runner.sh"
  status_file="$worktmp/child.status"

  {
    printf '%s\n' '#!/bin/sh'
    printf '%s\n' '# Generated by the herdr bats helper (run_herdr_cmd_pty): re-impose the'
    printf '%s\n' "# caller's environment exactly like run_herdr_zsh_pty's runner (PATH"
    printf '%s\n' '# hygiene + fixture HOME), cd to the fixture dir, run the given command'
    printf '%s\n' '# and record its exit status in the status file.'
    printf '%s\n' 'if [ -n "${HERDR_TEST_PATH:-}" ]; then'
    printf '%s\n' '  PATH="$HERDR_TEST_PATH"'
    printf '%s\n' '  export PATH'
    printf '%s\n' 'fi'
    printf '%s\n' 'HOME="$HERDR_TEST_HOME"'
    printf '%s\n' 'export HOME'
    # A failed cd records 90 (same code run_herdr_zsh_pty's snippet uses)
    # instead of vanishing before the status file is written.
    printf 'if ! cd -- %q; then printf "%%s" 90 > "$HERDR_TEST_STATUS"; exit 0; fi\n' \
      "$work_dir"
    # The command itself, shell-quoted argument by argument — no eval, so
    # paths/args with spaces survive.
    printf '%q' "$1"
    shift
    local arg
    for arg in "$@"; do
      printf ' %q' "$arg"
    done
    printf '\n'
    printf 'printf "%%s" "$?" > "$HERDR_TEST_STATUS"\n'
  } >"$runner_file"
  chmod +x "$runner_file"

  local script_status=0
  case "$HERDR_PTY_STYLE" in
    util-linux)
      printf '%s' "$stdin_data" \
        | HERDR_TEST_HOME="$home_dir" HERDR_TEST_STATUS="$status_file" \
          HERDR_TEST_PATH="$PATH" \
          SHELL=/bin/sh \
          "$HERDR_SCRIPT_BIN" -qec "$runner_file" /dev/null \
        || script_status=$?
      ;;
    bsd)
      printf '%s' "$stdin_data" \
        | HERDR_TEST_HOME="$home_dir" HERDR_TEST_STATUS="$status_file" \
          HERDR_TEST_PATH="$PATH" \
          SHELL=/bin/sh \
          "$HERDR_SCRIPT_BIN" -q /dev/null "$runner_file" \
        || script_status=$?
      ;;
    *)
      printf 'ERROR: herdr test harness: unknown HERDR_PTY_STYLE %q\n' "$HERDR_PTY_STYLE" >&2
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
    printf 'ERROR: herdr test harness: pty command never produced a child exit status.\n'
    printf '  script binary: %s (dialect: %s, script exit: %s)\n' \
      "$HERDR_SCRIPT_BIN" "$HERDR_PTY_STYLE" "$script_status"
    printf '  The prompt-driven bin/ shim tests cannot run without a working pty;\n'
    printf '  failing loudly instead of skipping (a skipped test would read as a pass).\n'
  } >&2
  rm -rf "$worktmp"
  return 88
}

# Install a mock `herdr` binary at the front of PATH (dir kept in
# HERDR_MOCK_DIR); the scenario is driven by HERDR_MOCK_* env vars set per test.
install_mock_herdr() {
  HERDR_MOCK_DIR="$(mktemp -d)"
  cat >"${HERDR_MOCK_DIR}/herdr" <<'MOCK'
#!/usr/bin/env bash
# Mock herdr CLI. Scenario via HERDR_MOCK_* env vars:
#   HERDR_MOCK_LIST_LABELS  space-separated "label" or "label:id" tokens
#                           (workspace list output; id defaults to ws_<label>)
#   HERDR_MOCK_WORKTREE_BRANCHES
#                           space-separated "branch" or "branch:path" tokens
#                           (worktree list output; path defaults to
#                           /tmp/herdr-wt-<branch-leaf>). Needed because
#                           branch_exists/resolve_path read `worktree list`,
#                           and the bin/ parity suite's exists-prompt cases
#                           must make branch_exists TRUE on the SHIM path,
#                           where a zsh function injected into a prelude
#                           snippet cannot reach (the shim spawns its own
#                           zsh — see run_herdr_cmd_pty).
#   HERDR_MOCK_CREATE_FAIL  non-empty -> `workspace create` exits 1
#   HERDR_MOCK_CREATE_ID    workspace_id returned by create (default ws_new)
#   HERDR_MOCK_LOG          if set, append every invocation's argv to this file
if [[ -n "${HERDR_MOCK_LOG:-}" ]]; then
  printf '%s\n' "$*" >>"$HERDR_MOCK_LOG"
fi
case "${1:-} ${2:-}" in
  "workspace list")
    json='{"result":{"workspaces":['
    sep=""
    for token in ${HERDR_MOCK_LIST_LABELS:-}; do
      label="${token%%:*}"
      if [[ "$token" == *:* ]]; then
        id="${token#*:}"
      else
        id="ws_${label}"
      fi
      json+="${sep}{\"label\":\"${label}\",\"workspace_id\":\"${id}\"}"
      sep=","
    done
    # Structure opened above is {"result":{"workspaces":[ ... ]}} — BOTH the
    # array bracket and the two enclosing objects must be closed, otherwise
    # jq fails with "Unfinished JSON term at EOF" and workspace_exists can
    # never match (which silently pushes the prompt-driven launcher cases
    # into the create path).
    json+=']}}'
    printf '%s\n' "$json"
    ;;
  "workspace create")
    if [[ -n "${HERDR_MOCK_CREATE_FAIL:-}" ]]; then
      echo "mock herdr: workspace create failed" >&2
      exit 1
    fi
    printf '{"result":{"workspace":{"workspace_id":"%s"}}}\n' "${HERDR_MOCK_CREATE_ID:-ws_new}"
    ;;
  "workspace focus")
    exit "${HERDR_MOCK_FOCUS_EXIT:-0}"
    ;;
  "worktree list")
    # Structure mirrors the "workspace list" case above: the array bracket
    # and BOTH enclosing objects must be closed, or jq fails with
    # "Unfinished JSON term at EOF" and branch_exists/resolve_path can never
    # match (which silently pushes the exists-prompt cases into the create
    # path). Empty HERDR_MOCK_WORKTREE_BRANCHES -> "worktrees":[] (no match,
    # same observable behavior as the old `{"result":{}}` fall-through).
    json='{"result":{"worktrees":['
    sep=""
    for token in ${HERDR_MOCK_WORKTREE_BRANCHES:-}; do
      branch="${token%%:*}"
      if [[ "$token" == *:* ]]; then
        path="${token#*:}"
      else
        path="/tmp/herdr-wt-${branch##*/}"
      fi
      json+="${sep}{\"branch\":\"${branch}\",\"path\":\"${path}\"}"
      sep=","
    done
    json+=']}}'
    printf '%s\n' "$json"
    ;;
  *)
    # Any other subcommand (pane/tab/...) succeeds with an empty result.
    printf '{"result":{}}\n'
    ;;
esac
MOCK
  chmod +x "${HERDR_MOCK_DIR}/herdr"
  PATH="${HERDR_MOCK_DIR}:${PATH}"
  export PATH HERDR_MOCK_DIR
}

# Remove the mock `herdr` dir installed by install_mock_herdr and drop it from PATH.
cleanup_mock_herdr() {
  if [[ -n "${HERDR_MOCK_DIR:-}" && -d "${HERDR_MOCK_DIR}" ]]; then
    PATH="${PATH#"${HERDR_MOCK_DIR}:"}"
    export PATH
    rm -rf "${HERDR_MOCK_DIR}"
    unset HERDR_MOCK_DIR
  fi
}

# Create a temp fixture directory (fake $HOME, $PWD, git repo, ...); prints its path.
make_herdr_tmpdir() {
  mktemp -d
}

# Remove a temp fixture directory created by make_herdr_tmpdir.
cleanup_herdr_tmpdir() {
  if [[ -n "${1:-}" && -d "${1:-}" ]]; then
    rm -rf "$1"
  fi
}
