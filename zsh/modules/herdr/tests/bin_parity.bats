#!/usr/bin/env bats
#
# bin/ shim <-> zsh-function parity suite — OpenSpec refactor-herdr-module,
# task 3.7; design: openspec/changes/refactor-herdr-module/design.md Risk 2
# (guards a-d). This is the mitigation for the highest-risk Phase-3 step:
# the bin/ unification introduces zsh re-entry from bash, a mechanism whose
# failure modes (lost args, drifted exit codes, wrong path math) are invisible
# to `zsh -n`, to shellcheck (bin/ is excluded at .pre-commit-config.yaml),
# and to the rename cross-check. The one live external consumer is the
# gh-dash keybinding (zsh/modules/github/data/gh-dash/config.yaml:89 runs
# `hrdw-create "{{.PrNumber}}"`).
#
# ── THE HARNESS RECIPE (re-derived and verified empirically before these
# assertions were written; see the task report for the captured runs) ────────
#
# The shims re-enter zsh by sourcing THIS CHECKOUT's zsh/zshrc, and a naive
# bats run silently tests the WRONG thing. Three traps, three defenses:
#
#   1. zsh/system/core/config/paths.zsh:14 prepends $HOME/.local/bin to PATH
#      while the zshrc loads — under a real $HOME that dir holds the real
#      25 MB herdr, AHEAD of the mock, so the mock would never be reached.
#      DEFENSE: a fixture HOME (SHIM_HOME) with NO .local/bin (mktemp -d
#      fresh dir; asserted in the argv-parity test). The REAL herdr's dir can
#      still sit later in the inherited PATH — irrelevant because the mock is
#      installed at the FRONT of PATH by install_mock_herdr, and inside the
#      shim's zsh `whence -p herdr` resolves to the mock (verified: the mock
#      is the only writer of HERDR_MOCK_LOG, and the recorded argv below is
#      non-empty on every shim invocation).
#   2. zsh/zshrc:10 hardcodes DOTFILES="${HOME}/.dotfiles" — under a fixture
#      HOME with no .dotfiles the shim would load NOTHING ("hrdw::create:
#      none"); under a REAL $HOME it would load a DIFFERENT checkout than
#      this worktree. DEFENSE: setup_file() symlinks SHIM_HOME/.dotfiles ->
#      $HERDR_TEST_ROOT (THIS worktree), so the shim executes exactly the
#      code the bats prelude sources.
#   3. The mock must sit at the FRONT of PATH, and script(1)'s wrapper shell
#      must not be allowed to un-shadow it (see run_herdr_cmd_pty).
#
# Cost: every shim invocation is a REAL zshrc load, not a fast stub. Measured
# on the verification box: ~20 s cold on a PRISTINE fixture HOME (compinit
# dump, plugin caches, antidote clone), then ~4 s warm / ~6 s under a pty.
# The fixture HOME is therefore created ONCE per file (setup_file) and shared
# — HOME state never feeds these assertions (labels derive from $PWD + the
# prefix map; herdr state comes exclusively from the mock). One cold load per
# file, then warm runs; this file uses five zshrc-loading shim invocations
# (argv, non-git, no-args, decline, 'y'-proof) plus three instant --help runs
# (which exit BEFORE zsh re-entry).
#
# ── How the prompt-driven cases are driven (read -q needs a terminal) ──────
# `read -q` at internal/workspace.zsh reads only from a terminal. Piped stdin
# fails and leaves REPLY empty — and EMPTY counts as "yes" — so a piped
# decline would silently take the OPEN path. The shim path reaches read -q
# through its OWN `exec zsh`, so it goes through run_herdr_cmd_pty (helper),
# which runs the shim binary itself under script(1) with the same PATH
# hygiene as run_herdr_zsh_pty. VERIFIED working on this box: feeding 'n'
# yields exit 0 with only `worktree list` in the log; feeding 'y' yields a
# recorded `worktree open`.
#
# Keystroke-delivery trap and its proof: zsh 5.9's read -q answers EOF with
# REPLY='n' as well, so 'n'-=>-decline ALONE would pass on a dead prompt.
# The complementary 'y' case is the delivery proof: a dead prompt cannot
# produce the recorded `worktree open` (EOF => decline => no open). Each
# direction failing proves the other is real:
#   dead pty  -> the 'y' test fails (no worktree open)
#   stuck 'y' -> the decline test fails (worktree open recorded)
#
# ── Known divergence pinned here (observable-delta #5) ─────────────────────
# `-h/--help` exists ONLY on the shim path: the shims check the flag before
# re-entering zsh, while the zsh functions have no help handling —
# `hrdw::create --help` treats the flag as a BRANCH NAME and attempts to
# create feature/--help. The design records this as observable-delta #5; the
# "known divergence" test below pins it in BOTH directions instead of hiding
# it, so fixing or worsening it fails loudly and forces the design update.

load "${BATS_TEST_DIRNAME}/test_helper.bash"

# This bats build does not define `fail` in the test process (verified in
# hrd_project_exit_codes.bats), so provide a local equivalent: print the
# diagnostic to stderr and return 1 — under `assertion || fail "..."` the
# non-zero status fails the test.
fail() {
  printf '%s\n' "$*" >&2
  return 1
}

# The full argv BOTH paths must record, derived INDEPENDENTLY from the
# fixture shape: repos live at <root>/codiplab/mytool, so with
# config/base.zsh's default map (which maps codiplab -> cl among its
# newline-separated entries — setup() unsets any env override) the project
# context is `cl`, the branch leaf is `RD-21` after
# ensure_branch_prefix adds feature/, and internal/worktree.zsh builds
# `worktree create --cwd . --branch <branch> --focus --label <label>`
# in that exact order. Byte-equality against this string is the core
# assertion: it pins --branch, --label, --cwd and --focus together, and the
# two logs are then compared to EACH OTHER as well.
EXPECTED_CREATE_ARGV='worktree create --cwd . --branch feature/RD-21 --focus --label cl-mytool/RD-21'

# The fixture HOME is per-FILE, not per-test (see the header's cost note):
# created here, used by every test via $SHIM_HOME, removed in teardown_file.
# export is load-bearing: bats runs setup_file OUTSIDE the tests' shell, so
# only exported variables reach the tests and teardown_file (verified: a
# non-exported SHIM_HOME reads as unset in tests).
setup_file() {
  SHIM_HOME="$(make_herdr_tmpdir)"
  export SHIM_HOME
  ln -s "$HERDR_TEST_ROOT" "$SHIM_HOME/.dotfiles"
}

setup() {
  # Force config/base.zsh's default parent map on BOTH paths so the derived
  # label is identical no matter what the outer environment exports.
  unset ZSH_HERDR_PARENT_PREFIX_MAP

  # Two clean repos with IDENTICAL {parent}/{name} shape so both paths derive
  # the same label while the recordings stay unambiguous (each path gets its
  # own repo AND its own mock log). Neither repo is under SHIM_HOME, so
  # derive_project_name takes the {parent}-{dir} branch on both paths.
  SHIM_ROOT="$(make_herdr_tmpdir)"
  ZSH_ROOT="$(make_herdr_tmpdir)"
  SHIM_REPO="$SHIM_ROOT/codiplab/mytool"
  ZSH_REPO="$ZSH_ROOT/codiplab/mytool"
  NONGIT_DIR="$(make_herdr_tmpdir)"
  mkdir -p "$SHIM_REPO" "$ZSH_REPO"
  git -C "$SHIM_REPO" init -q >/dev/null 2>&1
  git -C "$ZSH_REPO" init -q >/dev/null 2>&1

  install_mock_herdr
  SHIM_LOG="$SHIM_ROOT/herdr-shim.log"
  ZSH_LOG="$ZSH_ROOT/herdr-zsh.log"
  : >"$SHIM_LOG"
  : >"$ZSH_LOG"
  export HERDR_MOCK_LOG="$SHIM_LOG"
  unset HERDR_MOCK_LIST_LABELS HERDR_MOCK_CREATE_FAIL \
    HERDR_MOCK_CREATE_ID HERDR_MOCK_FOCUS_EXIT HERDR_MOCK_WORKTREE_BRANCHES
}

teardown() {
  cleanup_mock_herdr
  cleanup_herdr_tmpdir "$SHIM_ROOT"
  cleanup_herdr_tmpdir "$ZSH_ROOT"
  cleanup_herdr_tmpdir "$NONGIT_DIR"
}

# Remove the shared fixture HOME. The zshrc load kicks off ANTIDOTE
# background `git fetch --unshallow` processes that can outlive the shim
# (verified on this box: four fetches still running right after the shim
# exited), so a single rm -rf can hit ENOTEMPTY while they write — which is
# exactly how the first run of this file failed. Retry briefly; if the
# fixture never clears, fail loudly instead of masking it.
teardown_file() {
  [[ -n "${SHIM_HOME:-}" ]] || return 0
  local i
  for ((i = 0; i < 15; i++)); do
    if rm -rf "$SHIM_HOME" 2>/dev/null; then
      SHIM_HOME=""
      return 0
    fi
    sleep 1
  done
  printf 'ERROR: herdr parity suite: fixture HOME %s never cleared (background zshrc loads still writing?)\n' \
    "$SHIM_HOME" >&2
  return 1
}

# ─────────────────────────────────────────────────────────────────────────────
# (a) argv parity — the core assertion (Risk 2 mitigation a)
# ─────────────────────────────────────────────────────────────────────────────

# Running `hrdw-create RD-21` (shim: bash -> exec zsh -> zshrc -> hrdw::create)
# and `hrdw::create RD-21` (harness: zsh -f + prelude) in their own clean
# repos of identical shape must record the SAME `herdr worktree create` argv,
# byte for byte, including --branch feature/RD-21, the {context}/{leaf}
# --label, --cwd and --focus. Non-empty logs are asserted explicitly: only
# the mock writes HERDR_MOCK_LOG, so a non-empty recorded create line IS the
# proof the mock (not the real 25 MB herdr) served the invocation.
@test "3.7 argv parity: hrdw-create RD-21 and hrdw::create RD-21 record identical herdr worktree create argv" {
  # Recipe invariant: if the fixture HOME ever grew a .local/bin, paths.zsh:14
  # would put the REAL herdr ahead of the mock and every assertion below
  # could pass or fail against the wrong backend.
  [ ! -e "$SHIM_HOME/.local/bin" ] ||
    fail "fixture HOME must not contain .local/bin (paths.zsh:14 would un-shadow the real herdr): $SHIM_HOME/.local/bin"

  cd "$SHIM_REPO" || fail "cannot cd to $SHIM_REPO"
  export HERDR_MOCK_LOG="$SHIM_LOG"
  run env HOME="$SHIM_HOME" "$HERDR_MODULE_DIR/bin/hrdw-create" RD-21
  [ "$status" -eq 0 ] ||
    fail "shim hrdw-create RD-21 exited $status (zsh re-entry failed?): $output"

  export HERDR_MOCK_LOG="$ZSH_LOG"
  run run_herdr_zsh "$SHIM_HOME" "$ZSH_REPO" 'hrdw::create RD-21'
  [ "$status" -eq 0 ] ||
    fail "hrdw::create RD-21 exited $status: $output"

  local shim_count zsh_count shim_argv zsh_argv
  shim_count="$(grep -c '^worktree create ' "$SHIM_LOG" || true)"
  zsh_count="$(grep -c '^worktree create ' "$ZSH_LOG" || true)"
  [ "$shim_count" -eq 1 ] ||
    fail "shim path recorded $shim_count 'worktree create' invocations (want exactly 1); log:
$(cat "$SHIM_LOG")"
  [ "$zsh_count" -eq 1 ] ||
    fail "zsh path recorded $zsh_count 'worktree create' invocations (want exactly 1); log:
$(cat "$ZSH_LOG")"
  shim_argv="$(grep '^worktree create ' "$SHIM_LOG")"
  zsh_argv="$(grep '^worktree create ' "$ZSH_LOG")"

  # Mock-reached proof: the full expected argv line exists in both logs.
  [ "$shim_argv" = "$EXPECTED_CREATE_ARGV" ] ||
    fail "shim argv mismatch — got [$shim_argv], want [$EXPECTED_CREATE_ARGV]"
  [ "$zsh_argv" = "$EXPECTED_CREATE_ARGV" ] ||
    fail "zsh argv mismatch — got [$zsh_argv], want [$EXPECTED_CREATE_ARGV]"

  # The parity assertion proper: full normalized argv, not a substring.
  [ "$shim_argv" = "$zsh_argv" ] ||
    fail "argv parity broken — shim [$shim_argv] != zsh [$zsh_argv]"

  # The mock was consulted for existence checks before creating (flow proof,
  # and a non-empty log guards against a vacuous suite).
  grep -qF 'worktree list' "$SHIM_LOG" ||
    fail "shim path never consulted 'herdr worktree list' (mock not reached?); log:
$(cat "$SHIM_LOG")"
  grep -qF 'worktree list' "$ZSH_LOG" ||
    fail "zsh path never consulted 'herdr worktree list'; log:
$(cat "$ZSH_LOG")"

  # No REAL worktree was ever created (the mock fakes creation; the real
  # herdr would add entries here).
  local wt_count
  wt_count="$(git -C "$SHIM_REPO" worktree list | wc -l)"
  [ "$wt_count" -eq 1 ] ||
    fail "shim path created a REAL git worktree (want only the main worktree): $(git -C "$SHIM_REPO" worktree list)"
  wt_count="$(git -C "$ZSH_REPO" worktree list | wc -l)"
  [ "$wt_count" -eq 1 ] ||
    fail "zsh path created a REAL git worktree (want only the main worktree): $(git -C "$ZSH_REPO" worktree list)"
}

# ─────────────────────────────────────────────────────────────────────────────
# (b) exit-code parity (Risk 2 mitigation b)
# ─────────────────────────────────────────────────────────────────────────────

# Non-git directory: both paths must fail with 'Not a git repository'
# (helper.zsh hrdw::create's is_git_repo guard) and the SAME exit status.
@test "3.7 exit-code parity: non-git directory fails identically on both paths" {
  cd "$NONGIT_DIR" || fail "cannot cd to $NONGIT_DIR"
  export HERDR_MOCK_LOG="$SHIM_LOG"
  run env HOME="$SHIM_HOME" "$HERDR_MODULE_DIR/bin/hrdw-create" RD-21
  local shim_status=$status
  [ "$shim_status" -ne 0 ] ||
    fail "shim hrdw-create must exit non-zero outside a git repo; output: $output"
  [[ "$output" == *"Not a git repository"* ]] ||
    fail "shim path missing 'Not a git repository': $output"

  export HERDR_MOCK_LOG="$ZSH_LOG"
  run run_herdr_zsh "$SHIM_HOME" "$NONGIT_DIR" 'hrdw::create RD-21'
  local zsh_status=$status
  [ "$zsh_status" -ne 0 ] ||
    fail "hrdw::create must exit non-zero outside a git repo; output: $output"
  [[ "$output" == *"Not a git repository"* ]] ||
    fail "zsh path missing 'Not a git repository': $output"

  [ "$shim_status" -eq "$zsh_status" ] ||
    fail "exit-code parity broken for non-git dir: shim=$shim_status zsh=$zsh_status"

  if grep -q '^worktree create ' "$SHIM_LOG" || grep -q '^worktree create ' "$ZSH_LOG"; then
    fail "a worktree create was recorded despite the non-git guard; shim log:
$(cat "$SHIM_LOG")
zsh log: $(cat "$ZSH_LOG")"
  fi
}

# Missing branch-name: both paths must fail with the implementation's own
# usage message and the SAME exit status.
@test "3.7 exit-code parity: missing branch-name fails identically on both paths" {
  cd "$SHIM_REPO" || fail "cannot cd to $SHIM_REPO"
  export HERDR_MOCK_LOG="$SHIM_LOG"
  run env HOME="$SHIM_HOME" "$HERDR_MODULE_DIR/bin/hrdw-create"
  local shim_status=$status
  [ "$shim_status" -ne 0 ] ||
    fail "shim hrdw-create with no args must exit non-zero; output: $output"
  [[ "$output" == *"Usage: hrdw::create <branch-name>"* ]] ||
    fail "shim path missing the implementation usage message: $output"

  export HERDR_MOCK_LOG="$ZSH_LOG"
  run run_herdr_zsh "$SHIM_HOME" "$ZSH_REPO" 'hrdw::create'
  local zsh_status=$status
  [ "$zsh_status" -ne 0 ] ||
    fail "hrdw::create with no args must exit non-zero; output: $output"
  [[ "$output" == *"Usage: hrdw::create <branch-name>"* ]] ||
    fail "zsh path missing the usage message: $output"

  [ "$shim_status" -eq "$zsh_status" ] ||
    fail "exit-code parity broken for no-args usage: shim=$shim_status zsh=$zsh_status"

  if grep -q '^worktree create ' "$SHIM_LOG" || grep -q '^worktree create ' "$ZSH_LOG"; then
    fail "a worktree create was recorded despite the usage guard; shim log:
$(cat "$SHIM_LOG")
zsh log: $(cat "$ZSH_LOG")"
  fi
}

# Declining the exists-prompt: BOTH paths exit 0 and create nothing.
# HERDR_MOCK_WORKTREE_BRANCHES makes branch_exists true (feature/RD-21
# recorded for the fixture repos). Keystroke delivery is proven by the
# complementary 'y' test below — on its own a dead pty would also decline
# (EOF leaves REPLY='n'), see the header.
@test "3.7 exit-code parity: declining the exists-prompt exits 0 without creating on both paths" {
  export HERDR_MOCK_WORKTREE_BRANCHES="feature/RD-21:/wt/rd21"

  # zsh path via the prelude pty runner.
  export HERDR_MOCK_LOG="$ZSH_LOG"
  run run_herdr_zsh_pty "$SHIM_HOME" "$ZSH_REPO" 'hrdw::create RD-21' 'n'
  [ "$status" -eq 0 ] ||
    fail "hrdw::create decline must exit 0, got $status: $output"
  [[ "$output" == *"already exists"* ]] ||
    fail "exists-prompt never shown on the zsh path (branch_exists missed the mocked branch): $output"
  [[ "$output" == *"Open it? (Y/n)"* ]] ||
    fail "prompt text missing on the zsh path: $output"
  if grep -q '^worktree create ' "$ZSH_LOG" || grep -q '^worktree open ' "$ZSH_LOG"; then
    fail "decline on the zsh path created or opened a worktree; log:
$(cat "$ZSH_LOG")"
  fi

  # shim path: the shim's OWN exec zsh under the pty (run_herdr_cmd_pty).
  export HERDR_MOCK_LOG="$SHIM_LOG"
  run run_herdr_cmd_pty "$SHIM_HOME" "$SHIM_REPO" 'n' \
    "$HERDR_MODULE_DIR/bin/hrdw-create" RD-21
  [ "$status" -eq 0 ] ||
    fail "shim hrdw-create decline must exit 0, got $status: $output"
  [[ "$output" == *"already exists"* ]] ||
    fail "exists-prompt never shown on the shim path (wrong checkout loaded, or mock not reached?): $output"
  [[ "$output" == *"Open it? (Y/n)"* ]] ||
    fail "prompt text missing on the shim path: $output"
  if grep -q '^worktree create ' "$SHIM_LOG" || grep -q '^worktree open ' "$SHIM_LOG"; then
    fail "decline on the shim path created or opened a worktree; log:
$(cat "$SHIM_LOG")"
  fi
}

# Keystroke-delivery proof for the prompt cases above (both paths): feeding
# 'y' must take the OPEN path — recorded `worktree open --path /wt/rd21
# --focus`. A dead pty (EOF -> REPLY='n') can never produce this line, so a
# green decline test cannot be hiding a dead prompt: if delivery breaks, THIS
# test fails; if the prompt got stuck on 'y', the decline test fails.
@test "3.7 keystroke delivery: 'y' at the exists-prompt opens the worktree on both paths" {
  export HERDR_MOCK_WORKTREE_BRANCHES="feature/RD-21:/wt/rd21"

  export HERDR_MOCK_LOG="$ZSH_LOG"
  run run_herdr_zsh_pty "$SHIM_HOME" "$ZSH_REPO" 'hrdw::create RD-21' 'y'
  [ "$status" -eq 0 ] ||
    fail "hrdw::create accept must exit 0, got $status: $output"
  grep -qFx 'worktree open --path /wt/rd21 --focus' "$ZSH_LOG" ||
    fail "fed 'y' never reached read -q on the zsh path (dead prompt?); log:
$(cat "$ZSH_LOG")"
  if grep -q '^worktree create ' "$ZSH_LOG"; then
    fail "accept wrongly re-created an existing worktree; log:
$(cat "$ZSH_LOG")"
  fi

  export HERDR_MOCK_LOG="$SHIM_LOG"
  run run_herdr_cmd_pty "$SHIM_HOME" "$SHIM_REPO" 'y' \
    "$HERDR_MODULE_DIR/bin/hrdw-create" RD-21
  [ "$status" -eq 0 ] ||
    fail "shim hrdw-create accept must exit 0, got $status: $output"
  grep -qFx 'worktree open --path /wt/rd21 --focus' "$SHIM_LOG" ||
    fail "fed 'y' never reached read -q through the shim's exec zsh (dead prompt?); log:
$(cat "$SHIM_LOG")"
  if grep -q '^worktree create ' "$SHIM_LOG"; then
    fail "shim accept wrongly re-created an existing worktree; log:
$(cat "$SHIM_LOG")"
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# (c) PATH contract (Risk 2 mitigation c)
# ─────────────────────────────────────────────────────────────────────────────

# `command -v hrdw-create` must resolve to the shim when zsh/modules/herdr/bin
# is on PATH — in bash AND in zsh, because the gh-dash keybinding executes
# `hrdw-create` from zsh (gh-dash config.yaml:89). The negative control
# (resolution FAILS without bin/ on PATH) keeps the positive from passing on
# an ambient PATH entry.
@test "3.7 PATH contract: command -v hrdw-create resolves to the shim with bin/ on PATH" {
  run env PATH="$HERDR_MODULE_DIR/bin:$PATH" bash -c 'command -v hrdw-create'
  [ "$status" -eq 0 ] ||
    fail "command -v hrdw-create failed in bash with bin/ on PATH: $output"
  [ "$output" = "$HERDR_MODULE_DIR/bin/hrdw-create" ] ||
    fail "hrdw-create resolved to [$output], want [$HERDR_MODULE_DIR/bin/hrdw-create]"

  run env PATH="$HERDR_MODULE_DIR/bin:$PATH" zsh -f -c 'command -v hrdw-create'
  [ "$status" -eq 0 ] ||
    fail "command -v hrdw-create failed in zsh with bin/ on PATH: $output"
  [ "$output" = "$HERDR_MODULE_DIR/bin/hrdw-create" ] ||
    fail "hrdw-create resolved to [$output] in zsh, want [$HERDR_MODULE_DIR/bin/hrdw-create]"

  # Negative control: without OUR bin/ entry, resolution must not return OUR
  # worktree shim — that is what proves the positives above came from our
  # PATH entry. It asserts "not ours" rather than "fails" because the ambient
  # environment legitimately carries the USER'S dotfiles bin (the real
  # checkout, e.g. ~/.dotfiles/zsh/modules/herdr/bin — observed on this box),
  # and a different checkout resolving there is not a leak of THIS worktree.
  run bash -c 'command -v hrdw-create'
  [ "$output" != "$HERDR_MODULE_DIR/bin/hrdw-create" ] ||
    fail "hrdw-create resolved to OUR shim without our PATH entry — ambient PATH leak, the positive assertions above prove nothing: $output"
}

# -h/--help must work on all three shims: exit 0, print usage, and never
# reach the backend (the shims handle the flag BEFORE zsh re-entry, so no
# zshrc load and no herdr invocation — proven by the log staying empty).
@test "3.7 PATH contract: --help works on all three shims without touching the backend" {
  export HERDR_MOCK_LOG="$SHIM_LOG"
  local shim
  for shim in hrdw-create hrdw-delete hrdw-list; do
    run env HOME="$SHIM_HOME" "$HERDR_MODULE_DIR/bin/$shim" --help
    [ "$status" -eq 0 ] ||
      fail "$shim --help exited $status: $output"
    [[ "$output" == *"Usage: $shim"* ]] ||
      fail "$shim --help did not print its usage line: $output"
  done
  [ ! -s "$SHIM_LOG" ] ||
    fail "--help must exit before zsh re-entry, but the herdr backend was invoked; log:
$(cat "$SHIM_LOG")"
}

# Known divergence, pinned in BOTH directions (observable-delta #5): help is
# shim-only. If the zsh functions ever GAIN help handling, this test fails
# and the design delta must be updated; if the shims ever LOSE it, the first
# half fails. `hrdw::create --help` treats the flag as a branch name and
# attempts to create feature/--help — that is today's recorded behavior.
@test "3.7 known divergence pinned: --help is shim-only, hrdw::create --help treats the flag as a branch name (observable-delta #5)" {
  export HERDR_MOCK_LOG="$SHIM_LOG"
  run env HOME="$SHIM_HOME" "$HERDR_MODULE_DIR/bin/hrdw-create" --help
  [ "$status" -eq 0 ] || fail "shim --help exited $status: $output"
  [[ "$output" == *"Usage: hrdw-create"* ]] ||
    fail "shim --help lost its usage output: $output"
  [ ! -s "$SHIM_LOG" ] ||
    fail "shim --help must not invoke the backend; log: $(cat "$SHIM_LOG")"

  export HERDR_MOCK_LOG="$ZSH_LOG"
  run run_herdr_zsh "$SHIM_HOME" "$ZSH_REPO" 'hrdw::create --help'
  [[ "$output" != *"Usage:"* ]] ||
    fail "hrdw::create NOW prints usage — the known divergence (observable-delta #5) changed; update this pin and design.md: $output"
  grep -q '^worktree create --cwd . --branch feature/--help ' "$ZSH_LOG" ||
    fail "hrdw::create did not treat --help as a branch name (divergence changed?); log:
$(cat "$ZSH_LOG")"
}

# ─────────────────────────────────────────────────────────────────────────────
# (d) no duplicated logic remains (the property that keeps duplication from
# returning — static, but it belongs to this suite's guard set)
# ─────────────────────────────────────────────────────────────────────────────

# Each shim must be a THIN delegator: no `git worktree`, no
# feature/fix/bugfix/hotfix/chore prefix chain, no slug/name derivation, and
# no internal helper references — plus the positive half: the delegation call
# itself is present, so a stub that exits early cannot pass.
@test "3.7 shims contain no duplicated worktree/naming logic and do delegate (static)" {
  local shim file
  for shim in hrdw-create hrdw-delete hrdw-list; do
    file="$HERDR_MODULE_DIR/bin/$shim"
    [ -f "$file" ] || fail "shim missing: $file"

    if grep -qF 'git worktree' "$file"; then
      fail "$shim contains 'git worktree' — worktree logic leaked back into the shim"
    fi
    if grep -qE 'feature/|fix/|bugfix/|hotfix/|chore/' "$file"; then
      fail "$shim contains the git-flow prefix chain — it must live only in internal/worktree.zsh"
    fi
    if grep -qE 'ensure_branch_prefix|derive_label|derive_project_name|derive_name|slug' "$file"; then
      fail "$shim contains name-derivation code — it must live only in the zsh module"
    fi
    if grep -qF 'hrd::internal::' "$file"; then
      fail "$shim references hrd::internal::* directly instead of the hrdw:: entry point"
    fi

    case "$shim" in
      hrdw-create)
        grep -qF 'hrdw::create "$@"' "$file" ||
          fail "$shim no longer delegates via hrdw::create \"\$@\""
        ;;
      hrdw-delete)
        grep -qF 'hrdw::remove "$@"' "$file" ||
          fail "$shim no longer delegates via hrdw::remove \"\$@\""
        ;;
      hrdw-list)
        grep -qF 'hrdw::list "$@"' "$file" ||
          fail "$shim no longer delegates via hrdw::list \"\$@\""
        ;;
    esac
  done
}
