#!/usr/bin/env bats
# Phase 2 naming + legacy-fallback coverage for the herdr module.
# OpenSpec change: refactor-herdr-module — tasks 2.5, 2.6, 2.7, plus the
# PART 0 double-miss-warning correctness fix in internal/workspace.zsh.
#
# Contract: openspec/changes/refactor-herdr-module/specs/workspace-naming/spec.md
#
# CRITICAL: the functions under test use zsh-only expansions (${PWD:t},
# ${PWD:h:t}, ${name:l}) that are valid-but-EMPTY substring expansions in
# bash, so every call below goes through run_herdr_zsh (or the pty variant
# for `read -q` prompts) — a real `zsh -f` subshell that cds to a fixture
# dir with a controlled $HOME. Never call the zsh functions from this file's
# bash (harness rule, test_helper.bash:4-8).
#
# PREFIX-MAP POLICY: setup() UNSETS ZSH_HERDR_PARENT_PREFIX_MAP so the zsh
# child starts clean. Tests that want the DEFAULT map rely on the
# config/base.zsh default (three newline-separated pairs:
# codiplab=cl / luismayta=lm / hadenlabs=hdx — applied by the prelude's
# `${VAR:-default}`, which this file states explicitly rather than passing
# the map through the environment). Tests that need a CUSTOM map (empty
# prefix, a parent containing a space, a HOME-basename key) set
# ZSH_HERDR_PARENT_PREFIX_MAP INSIDE the zsh snippet BEFORE the call — the
# herdr delegator reads ${ZSH_HERDR_PARENT_PREFIX_MAP:-} at call time.
#
# Fixtures: setup() creates a fresh fake $HOME and a fixture root per test;
# teardown() removes both (plus the mock) after EVERY test, pass or fail.

load "${BATS_TEST_DIRNAME}/test_helper.bash"

# This bats build does not define `fail` in the test process (verified in
# hrd_project_exit_codes.bats), so provide a local equivalent: print the
# diagnostic to stderr and return 1 — under `assertion || fail "..."` the
# non-zero status fails the test.
fail() {
  printf '%s\n' "$*" >&2
  return 1
}

# git fixture for the hrdw::* call-site tests (task 2.5): a bare `git init`
# satisfies hrd::internal::worktree::is_git_repo (rev-parse --git-dir needs
# no commits); the actual herdr worktree commands are mocked.
make_git_repo() {
  mkdir -p "$1"
  git -C "$1" init -q >/dev/null 2>&1
}

setup() {
  # Deterministic default map: config/base.zsh's `${VAR:-...}` (which
  # defaults to codiplab=cl / luismayta=lm / hadenlabs=hdx) only yields the
  # default when the variable is unset in the environment.
  unset ZSH_HERDR_PARENT_PREFIX_MAP
  # HOME_DIR must not be the fixture root: a work dir whose PARENT is HOME
  # would take the core-{dir} branch instead of {parent}-{dir}.
  HOME_DIR="$(make_herdr_tmpdir)"
  WORK_ROOT="$(make_herdr_tmpdir)"
  install_mock_herdr
  MOCK_LOG="$WORK_ROOT/herdr-calls.log"
  export HERDR_MOCK_LOG="$MOCK_LOG"
  : >"$MOCK_LOG"
  unset HERDR_MOCK_LIST_LABELS HERDR_MOCK_CREATE_FAIL \
    HERDR_MOCK_CREATE_ID HERDR_MOCK_FOCUS_EXIT
}

teardown() {
  cleanup_mock_herdr
  cleanup_herdr_tmpdir "$WORK_ROOT"
  cleanup_herdr_tmpdir "$HOME_DIR"
}

# ─────────────────────────────────────────────────────────────────────────────
# PART 0 — double-miss warning correctness fix (workspace.zsh) + call site 1
# (pkg/helper.zsh:105, hrd::project)
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Explicit argument takes priority" — `hrd::project custom`
# supplies the candidate label, so the directory's derived labels
# (cl-mytool / codiplab-mytool) are NOT the labels that were looked up: the
# resolver's context gate rejects the legacy fallback for `custom`, so
# naming codiplab-mytool in a warning would name a label that was never
# tried. Correct behavior: stay silent. (With the pre-fix condition —
# gated on new_label != legacy_label alone — this case DID warn with a
# misleading message.)
@test "PART 0: hrd::project with an explicit argument emits NO double-miss warning" {
  local work_dir="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$work_dir"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::project custom' ''

  [ "$status" -eq 0 ] || fail "hrd::project custom should exit 0, got $status: $output"
  [[ "$output" != *"no workspace matches the new or legacy label"* ]] ||
    fail "explicit-argument path wrongly emitted the double-miss warning: $output"
  [[ "$output" != *codiplab-mytool* ]] ||
    fail "warning named a legacy label that was never looked up: $output"
  grep -qFx "workspace create --label custom --cwd ${work_dir} --focus" "$MOCK_LOG" ||
    fail "hrd::project custom did not create the workspace under the EXACT explicit label; log:
$(cat "$MOCK_LOG")"
}

# Spec scenario: the double-miss warning itself (design Risk 4, task 2.4) —
# with NO argument under a MAPPED parent, the candidate IS this directory's
# new derived label, the context gate passes, so BOTH labels genuinely were
# looked up and both must be named. The message pins the exact labels.
@test "PART 0: genuine double-miss under a mapped parent names both tried labels" {
  local work_dir="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$work_dir"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::project' ''

  [ "$status" -eq 0 ] || fail "hrd::project create path should exit 0, got $status: $output"
  [[ "$output" == *"WARNING: no workspace matches the new or legacy label; creating a new one (tried 'cl-mytool' and 'codiplab-mytool')"* ]] ||
    fail "double-miss warning missing or naming the wrong labels: $output"
  grep -qFx "workspace create --label cl-mytool --cwd ${work_dir} --focus" "$MOCK_LOG" ||
    fail "create did not use the mapped label cl-mytool; log:
$(cat "$MOCK_LOG")"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 2.5 — the four naming call sites in pkg/helper.zsh
# (lines 105 hrd::project, 277 hrdw::create, 342 hrdw::open, 377 hrdw::remove)
# Line 105 is exercised by the two PART 0 cases above (explicit argument and
# directory derivation) and by the legacy-attach case below.
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Legacy label resolves existing workspace" + "Existing
# workspace is never recreated" through hrd::project (helper.zsh:105):
# only the LEGACY label exists, yet the launcher must attach — prompting on
# the new candidate label, resolving the legacy entry's workspace_id
# THROUGH THE CHOKE POINT (focus ws_legacy, never ws_new), and NEVER
# invoking `workspace create`.
@test "2.5 hrd::project attaches to a legacy-labelled workspace through the choke point" {
  local work_dir="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$work_dir"
  export HERDR_MOCK_LIST_LABELS="codiplab-mytool:ws_legacy"

  run run_herdr_zsh_pty "$HOME_DIR" "$work_dir" 'hrd::project' 'y'

  [ "$status" -eq 0 ] || fail "attach path should exit 0, got $status: $output"
  [[ "$output" == *"A herdr workspace \"cl-mytool\" already exists"* ]] ||
    fail "attach prompt missing — workspace_exists did not match for the new candidate 'cl-mytool' (create fall-through?): $output"
  grep -qFx "workspace focus ws_legacy" "$MOCK_LOG" ||
    fail "focus was not invoked with the LEGACY id ws_legacy — the legacy label did not resolve through the choke point; log:
$(cat "$MOCK_LOG")"
  if grep -qF "workspace create" "$MOCK_LOG"; then
    fail "legacy-labelled workspace was RECREATED (design Risk 4); log:
$(cat "$MOCK_LOG")"
  fi
}

# Spec scenario (task 2.5): hrdw::create (helper.zsh:277) derives the
# {project_context}/{branch_leaf} label with the MAPPED context
# (cl-mytool/RD-21, NOT codiplab-mytool/RD-21), feeds it to worktree
# create, and then resolves that label to the LEGACY worktree workspace's
# id through the choke point — proven by the 3-pane layout running against
# ws_wt_legacy (without a resolved id there is no `pane split` at all).
@test "2.5 hrdw::create builds the {mapped-context}/{leaf} label and consumes the legacy workspace id" {
  local repo_dir="$WORK_ROOT/codiplab/mytool"
  make_git_repo "$repo_dir"
  # Only the LEGACY worktree label exists: new candidate cl-mytool/RD-21
  # must fall back to codiplab-mytool/RD-21 inside resolve_workspace_id.
  export HERDR_MOCK_LIST_LABELS="codiplab-mytool/RD-21:ws_wt_legacy"

  run run_herdr_zsh "$HOME_DIR" "$repo_dir" 'hrdw::create RD-21'

  [ "$status" -eq 0 ] || fail "hrdw::create should exit 0, got $status: $output"
  grep -qFx "worktree create --cwd . --branch feature/RD-21 --focus --label cl-mytool/RD-21" "$MOCK_LOG" ||
    fail "worktree create did not receive the MAPPED-context label 'cl-mytool/RD-21'; log:
$(cat "$MOCK_LOG")"
  [[ "$output" == *"SUCCESS: Worktree 'cl-mytool/RD-21' created and opened"* ]] ||
    fail "success line does not carry the {mapped-context}/{leaf} label: $output"
  grep -q "pane split" "$MOCK_LOG" ||
    fail "no pane layout ran — resolve_workspace_id did NOT resolve the legacy worktree label to ws_wt_legacy through the choke point; log:
$(cat "$MOCK_LOG")"
}

# Spec scenario (task 2.5): hrdw::open (helper.zsh:342) derives the display
# label {project_context}/{branch_leaf} with the MAPPED context
# (cl-mytool/RD-21), then opens the branch through the worktree helpers.
@test "2.5 hrdw::open derives the mapped context for the {context}/{leaf} display" {
  local repo_dir="$WORK_ROOT/codiplab/mytool"
  make_git_repo "$repo_dir"

  run run_herdr_zsh "$HOME_DIR" "$repo_dir" 'hrdw::open RD-21'

  [ "$status" -eq 0 ] || fail "hrdw::open should exit 0, got $status: $output"
  [[ "$output" == *"INFO: Opening worktree: cl-mytool/RD-21"* ]] ||
    fail "display label missing or not built from the MAPPED context: $output"
  grep -qFx "worktree open --path feature/RD-21 --focus" "$MOCK_LOG" ||
    fail "worktree open was not invoked for the auto-prefixed branch; log:
$(cat "$MOCK_LOG")"
}

# Spec scenario (task 2.5): hrdw::remove (helper.zsh:377, the fzf branch)
# derives the context for the confirmation prompt with the MAPPED value
# (cl-mytool/RD-21 — the branch leaf reused verbatim), resolves the selected
# branch to a workspace id, and removes only after the confirmation.
#
# Driving this branch needs data the helper mock cannot express (`worktree
# list` entries) plus an fzf selection, so the zsh snippet defines a
# `herdr` FUNCTION that answers only `worktree list` and delegates every
# other argv to the PATH mock via `command herdr`, plus an `fzf` function
# that replays a canned selection. Both live entirely inside the zsh
# subshell — the bash side still never calls any zsh function.
# The prompt is a `read -q`, so this case runs under the pty harness.
@test "2.5 hrdw::remove derives the mapped context for the confirmation prompt" {
  local repo_dir="$WORK_ROOT/codiplab/mytool"
  make_git_repo "$repo_dir"

  local snippet='herdr() {
  if [[ "${1:-} ${2:-}" == "worktree list" ]]; then
    print -r -- "{\"result\":{\"worktrees\":[{\"branch\":\"feature/RD-21\",\"path\":\"/tmp/wt-rd21\",\"open_workspace_id\":\"ws_wt\"}]}}"
  else
    command herdr "$@"
  fi
}
fzf() { cat >/dev/null; print -r -- "feature/RD-21 | /tmp/wt-rd21 | clean"; }
hrdw::remove'

  run run_herdr_zsh_pty "$HOME_DIR" "$repo_dir" "$snippet" 'y'

  [ "$status" -eq 0 ] || fail "hrdw::remove should exit 0, got $status: $output"
  [[ "$output" == *"Remove worktree \"cl-mytool/RD-21\" (workspace: ws_wt)?"* ]] ||
    fail "confirmation prompt missing or not built from the MAPPED context: $output"
  grep -qFx "worktree remove --workspace ws_wt" "$MOCK_LOG" ||
    fail "confirmed removal never reached herdr workspace remove; log:
$(cat "$MOCK_LOG")"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 2.6 — prefix map and fallback identity
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Mapped parent uses short prefix" — parent `codiplab`, dir
# `base-template`, the config DEFAULT map (setup() unsets any environment
# override, so the prelude's `${VAR:-...}` applies — the three-line default
# codiplab=cl / luismayta=lm / hadenlabs=hdx) -> cl-base-template, and the
# full parent name must NOT appear in the label.
@test "2.6 codiplab/base-template derives cl-base-template under the default map" {
  mkdir -p "$WORK_ROOT/codiplab/base-template"

  # Print the map too: it proves the DEFAULT map was in scope for this run,
  # so a wrong result cannot hide behind a missing/overridden map.
  run run_herdr_zsh "$HOME_DIR" "$WORK_ROOT/codiplab/base-template" \
    'print -r -- "map=${ZSH_HERDR_PARENT_PREFIX_MAP}"
print -r -- "name=$(hrd::internal::derive_project_name)"'

  [ "$status" -eq 0 ] || fail "derivation should exit 0, got $status: $output"
  local expected=$'map=codiplab=cl\nluismayta=lm\nhadenlabs=hdx\nname=cl-base-template'
  [ "$output" = "$expected" ] ||
    fail "expected [$expected], got [$output]"
  local name_line
  name_line="$(printf '%s\n' "$output" | grep '^name=')"
  [[ "$name_line" != *codiplab* ]] ||
    fail "full parent name leaked into the label: $name_line"
}

# Spec scenario: "Mapped parent uses short prefix" — the SECOND default-map
# entry: parent `luismayta`, dir `dotfiles` -> lm-dotfiles under the config
# DEFAULT map (setup() unsets any environment override, so the prelude's
# `${VAR:-...}` applies). The full parent name must NOT appear in the label.
@test "2.6 luismayta/dotfiles derives lm-dotfiles under the default map" {
  mkdir -p "$WORK_ROOT/luismayta/dotfiles"

  # Print the map too: it proves the DEFAULT map was in scope for this run,
  # so a wrong result cannot hide behind a missing/overridden map.
  run run_herdr_zsh "$HOME_DIR" "$WORK_ROOT/luismayta/dotfiles" \
    'print -r -- "map=${ZSH_HERDR_PARENT_PREFIX_MAP}"
print -r -- "name=$(hrd::internal::derive_project_name)"'

  [ "$status" -eq 0 ] || fail "derivation should exit 0, got $status: $output"
  local expected=$'map=codiplab=cl\nluismayta=lm\nhadenlabs=hdx\nname=lm-dotfiles'
  [ "$output" = "$expected" ] ||
    fail "expected [$expected], got [$output]"
  local name_line
  name_line="$(printf '%s\n' "$output" | grep '^name=')"
  [[ "$name_line" != *luismayta* ]] ||
    fail "full parent name leaked into the label: $name_line"
}

# Spec scenario: "Mapped parent uses short prefix" — the THIRD default-map
# entry: parent `hadenlabs`, dir `project` -> hdx-project under the config
# DEFAULT map (setup() unsets any environment override, so the prelude's
# `${VAR:-...}` applies). The full parent name must NOT appear in the label.
@test "2.6 hadenlabs/project derives hdx-project under the default map" {
  mkdir -p "$WORK_ROOT/hadenlabs/project"

  # Print the map too: it proves the DEFAULT map was in scope for this run,
  # so a wrong result cannot hide behind a missing/overridden map.
  run run_herdr_zsh "$HOME_DIR" "$WORK_ROOT/hadenlabs/project" \
    'print -r -- "map=${ZSH_HERDR_PARENT_PREFIX_MAP}"
print -r -- "name=$(hrd::internal::derive_project_name)"'

  [ "$status" -eq 0 ] || fail "derivation should exit 0, got $status: $output"
  local expected=$'map=codiplab=cl\nluismayta=lm\nhadenlabs=hdx\nname=hdx-project'
  [ "$output" = "$expected" ] ||
    fail "expected [$expected], got [$output]"
  local name_line
  name_line="$(printf '%s\n' "$output" | grep '^name=')"
  [[ "$name_line" != *hadenlabs* ]] ||
    fail "full parent name leaked into the label: $name_line"
}

# Spec scenario: "Unmapped parent keeps full name" — parent `sideproject`
# has no map entry, so {parent}-{dir} is used unchanged: sideproject-tool.
# The second line runs the EMPTY-map derivation — which IS the pre-Phase-2
# algorithm (Phase 2 moved that exact logic into core::workspace::derive_name
# with no map) — and must be byte-identical to what the herdr delegator
# produces WITH the default map in scope.
@test "2.6 unmapped sideproject/tool derives sideproject-tool byte-identical to the legacy derivation" {
  mkdir -p "$WORK_ROOT/sideproject/tool"

  run run_herdr_zsh "$HOME_DIR" "$WORK_ROOT/sideproject/tool" \
    'print -r -- "new=$(hrd::internal::derive_project_name)"
print -r -- "legacy=$(core::workspace::derive_name "" "")"'

  [ "$status" -eq 0 ] || fail "derivation should exit 0, got $status: $output"
  local expected=$'new=sideproject-tool\nlegacy=sideproject-tool'
  [ "$output" = "$expected" ] ||
    fail "expected byte-identical [$expected], got [$output]"
}

# Spec scenario: "Full-parent-name fallback" — a map entry with an EMPTY
# prefix (codiplab=) does not match (an entry with an empty prefix does not
# match, core helper contract), so the derivation must fall through to the
# full parent name. Map set INSIDE the snippet before the call.
@test "2.6 an empty mapped prefix falls through to the full parent name" {
  mkdir -p "$WORK_ROOT/codiplab/base-template"

  run run_herdr_zsh "$HOME_DIR" "$WORK_ROOT/codiplab/base-template" \
    'ZSH_HERDR_PARENT_PREFIX_MAP="codiplab="
hrd::internal::derive_project_name'

  [ "$status" -eq 0 ] || fail "derivation should exit 0, got $status: $output"
  [ "$output" = "codiplab-base-template" ] ||
    fail "empty prefix must fall back to the full parent name, got: $output"
}

# Spec scenario: "Explicit parent prefix map" (newline delimiter) — a parent
# directory name CONTAINS a space (`My Work=ok`); space/comma delimiters
# would corrupt this key, the newline delimiter parses it and maps to ok-*.
# Map set INSIDE the snippet before the call.
@test "2.6 a mapped parent containing a space parses on the newline delimiter" {
  mkdir -p "$WORK_ROOT/My Work/api"

  run run_herdr_zsh "$HOME_DIR" "$WORK_ROOT/My Work/api" \
    "ZSH_HERDR_PARENT_PREFIX_MAP='My Work=ok'
hrd::internal::derive_project_name"

  [ "$status" -eq 0 ] || fail "derivation should exit 0, got $status: $output"
  [ "$output" = "ok-api" ] ||
    fail "expected ok-api from the 'My Work=ok' map entry, got: $output"
}

# Spec scenario: "Home directory yields core" + "Direct child of home yields
# core prefix" — the HOME branches are mutually exclusive with the {parent}-
# {dir} branch, so the map (keyed on the HOME basename here, to prove even
# a direct hit would be ignored) must have NO effect: core / core-scratch.
# Map set INSIDE the snippet before the call.
@test "2.6 HOME and parent==HOME branches ignore the prefix map" {
  mkdir -p "$HOME_DIR/scratch"

  run run_herdr_zsh "$HOME_DIR" "$HOME_DIR" \
    'ZSH_HERDR_PARENT_PREFIX_MAP="${HOME:t}=zz"
hrd::internal::derive_project_name'
  [ "$status" -eq 0 ] || fail "PWD==HOME derivation should exit 0, got $status: $output"
  [ "$output" = "core" ] || fail "PWD==HOME must derive core, got: $output"
  [[ "$output" != *zz* ]] || fail "map leaked into the HOME branch: $output"

  run run_herdr_zsh "$HOME_DIR" "$HOME_DIR/scratch" \
    'ZSH_HERDR_PARENT_PREFIX_MAP="${HOME:t}=zz"
hrd::internal::derive_project_name'
  [ "$status" -eq 0 ] || fail "parent==HOME derivation should exit 0, got $status: $output"
  [ "$output" = "core-scratch" ] || fail "parent==HOME must derive core-scratch, got: $output"
  [[ "$output" != *zz* ]] || fail "map leaked into the parent==HOME branch: $output"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 2.7 — legacy fallback and tmux parity (all three resolution cases on
# BOTH consumption paths: workspace_exists AND resolve_workspace_id)
# ─────────────────────────────────────────────────────────────────────────────

# Resolution case 1: the NEW label is present. Both consumption paths must
# resolve it directly — workspace_exists true, resolve_workspace_id returns
# the new entry's id, the label resolver returns the candidate unchanged.
@test "2.7 new label present: both consumption paths resolve the new label id" {
  local work_dir="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$work_dir"
  export HERDR_MOCK_LIST_LABELS="cl-mytool:ws_new_form"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::internal::resolve_workspace_label "cl-mytool"'
  [ "$status" -eq 0 ] || fail "label resolver should succeed, got $status: $output"
  [ "$output" = "cl-mytool" ] || fail "expected candidate cl-mytool, got: $output"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::internal::workspace_exists "cl-mytool"'
  [ "$status" -eq 0 ] || fail "workspace_exists should be true for the new label, got $status"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::internal::resolve_workspace_id "cl-mytool"'
  [ "$status" -eq 0 ] || fail "resolve_workspace_id should exit 0, got $status: $output"
  [ "$output" = "ws_new_form" ] || fail "expected id ws_new_form, got: $output"
}

# Resolution case 2 (design Risk 4): the NEW label is absent, the LEGACY
# {parent}-{dir} label is present. BOTH consumption paths must land on the
# legacy entry — exists true, id = ws_legacy — and nothing may ever be
# created: `workspace create` must be absent from the mock log entirely.
@test "2.7 legacy label present: both paths resolve the legacy id and never create" {
  local work_dir="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$work_dir"
  export HERDR_MOCK_LIST_LABELS="codiplab-mytool:ws_legacy"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::internal::resolve_workspace_label "cl-mytool"'
  [ "$status" -eq 0 ] || fail "label resolver should fall back to the legacy label, got $status: $output"
  [ "$output" = "codiplab-mytool" ] || fail "expected legacy label codiplab-mytool, got: $output"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::internal::workspace_exists "cl-mytool"'
  [ "$status" -eq 0 ] || fail "workspace_exists must be true via the legacy fallback, got $status"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::internal::resolve_workspace_id "cl-mytool"'
  [ "$status" -eq 0 ] || fail "resolve_workspace_id should exit 0, got $status: $output"
  [ "$output" = "ws_legacy" ] || fail "expected the LEGACY id ws_legacy, got: $output"

  if grep -qF "workspace create" "$MOCK_LOG"; then
    fail "legacy-labeled workspace was recreated (design Risk 4 — fallback half-landing); log:
$(cat "$MOCK_LOG")"
  fi
}

# Resolution case 3: BOTH labels absent. workspace_exists reports false
# (exit 1) and resolve_workspace_id returns NOTHING with status 0 (the
# documented contract callers rely on) — on top of the same mocked list.
@test "2.7 both absent: workspace_exists fails and resolve_workspace_id returns empty with status 0" {
  local work_dir="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$work_dir"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::internal::workspace_exists "cl-mytool"'
  [ "$status" -eq 1 ] || fail "workspace_exists should fail when neither label exists, got $status"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" 'hrd::internal::resolve_workspace_id "cl-mytool"'
  [ "$status" -eq 0 ] || fail "resolve_workspace_id must keep status 0 on a double miss, got $status: $output"
  [ -z "$output" ] || fail "resolve_workspace_id must return no id on a double miss, got: $output"
}

# Resolution case 3 (warning half): the double-miss warning fires ONLY when
# the two labels differ — mapped parent (cl-mytool vs codiplab-mytool) it
# fires naming both labels; unmapped parent (identical labels) it must stay
# silent, or every genuinely new project becomes noise.
@test "2.7 both absent: double-miss warning fires only for a mapped parent" {
  local mapped="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$mapped"
  local unmapped="$WORK_ROOT/sideproject/tool"
  mkdir -p "$unmapped"

  run run_herdr_zsh "$HOME_DIR" "$mapped" \
    'hrd::internal::workspace_attach_or_create "cl-mytool"'
  [ "$status" -eq 1 ] || fail "attach_or_create must return 1 on a double miss, got $status"
  [[ "$output" == *"WARNING: no workspace matches the new or legacy label; creating a new one (tried 'cl-mytool' and 'codiplab-mytool')"* ]] ||
    fail "mapped-parent double-miss warning missing or naming the wrong labels: $output"

  run run_herdr_zsh "$HOME_DIR" "$unmapped" \
    'hrd::internal::workspace_attach_or_create "sideproject-tool"'
  [ "$status" -eq 1 ] || fail "attach_or_create must return 1 on a double miss, got $status"
  [[ "$output" != *"no workspace matches the new or legacy label"* ]] ||
    fail "unmapped parent (labels identical) must NOT warn: $output"
}

# Spec scenario (choke-point contract, workspace.zsh resolver): a worktree
# label is "{project_context}/{branch_leaf}" and contains a slash. The
# legacy form substitutes ONLY the context and reuses the leaf verbatim:
# candidate cl-mytool/RD-21 falls back to codiplab-mytool/RD-21 — the slash
# is never slugified or stripped (slugification would yield
# codiplab-mytool-rd-21). The literal reading also holds: a candidate that
# IS the legacy slash label matches directly.
@test "2.7 worktree label with a slash: legacy form reuses the leaf verbatim" {
  local work_dir="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$work_dir"
  export HERDR_MOCK_LIST_LABELS="codiplab-mytool/RD-21:ws_wt_legacy"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" \
    'hrd::internal::resolve_workspace_label "cl-mytool/RD-21"'
  [ "$status" -eq 0 ] || fail "legacy slash label should resolve, got $status: $output"
  [ "$output" = "codiplab-mytool/RD-21" ] ||
    fail "expected exactly codiplab-mytool/RD-21 (slash + leaf verbatim), got: $output"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" \
    'hrd::internal::workspace_exists "cl-mytool/RD-21"'
  [ "$status" -eq 0 ] || fail "workspace_exists should be true for the legacy slash label, got $status"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" \
    'hrd::internal::resolve_workspace_id "cl-mytool/RD-21"'
  [ "$status" -eq 0 ] || fail "resolve_workspace_id should exit 0, got $status: $output"
  [ "$output" = "ws_wt_legacy" ] || fail "expected ws_wt_legacy, got: $output"

  # The legacy slash label itself is a direct match (first lookup step).
  run run_herdr_zsh "$HOME_DIR" "$work_dir" \
    'hrd::internal::resolve_workspace_label "codiplab-mytool/RD-21"'
  [ "$status" -eq 0 ] || fail "direct legacy slash label should resolve, got $status: $output"
  [ "$output" = "codiplab-mytool/RD-21" ] || fail "direct match mangled: $output"
}

# Pre-existing semantics (a naive reimplementation regresses this): a
# workspace present WITH its label but WITHOUT a workspace_id field must
# still make workspace_exists TRUE, and resolve_workspace_id must return
# nothing with status 0 (label resolves, id select yields nothing).
#
# The helper mock's token format ALWAYS emits a workspace_id key, so a
# label-only entry cannot be expressed through HERDR_MOCK_LIST_LABELS — the
# zsh snippet defines a `herdr` function returning label-only JSON. This is
# still fully inside the zsh subshell; the bash side only asserts.
@test "2.7 a label with no workspace_id field still counts as existing" {
  local work_dir="$WORK_ROOT/codiplab/mytool"
  mkdir -p "$work_dir"
  local label_only='herdr() {
  if [[ "${1:-} ${2:-}" == "workspace list" ]]; then
    print -r -- "{\"result\":{\"workspaces\":[{\"label\":\"cl-mytool\"}]}}"
  else
    command herdr "$@"
  fi
}'

  run run_herdr_zsh "$HOME_DIR" "$work_dir" "${label_only}
hrd::internal::workspace_exists \"cl-mytool\""
  [ "$status" -eq 0 ] ||
    fail "workspace_exists must be true for a label WITHOUT a workspace_id field, got $status: $output"

  run run_herdr_zsh "$HOME_DIR" "$work_dir" "${label_only}
hrd::internal::resolve_workspace_id \"cl-mytool\""
  [ "$status" -eq 0 ] ||
    fail "resolve_workspace_id must exit 0 when the label exists but carries no id, got $status: $output"
  [ -z "$output" ] ||
    fail "resolve_workspace_id must return no id when the field is absent, got: $output"
}

# tmux parity (task 2.7 / requirement #19): tx::internal::derive_project_name
# delegates with an EMPTY map, so even with the herdr prefix map present in
# the environment tmux MUST return the FULL parent name. The three lines
# compare tmux against the herdr delegator with the empty map (must be
# byte-identical) while the herdr-with-map line shows the contrast.
# Key assertion: tmux=codiplab-base-template, NOT cl-base-template.
@test "2.7 tmux parity: mapped parent still yields the FULL parent name" {
  mkdir -p "$WORK_ROOT/codiplab/base-template"

  run run_herdr_zsh "$HOME_DIR" "$WORK_ROOT/codiplab/base-template" \
    'source "${HERDR_MODULE_DIR}/../tmux/internal/base.zsh"
mapped="$(hrd::internal::derive_project_name)"
tmux_out="$(tx::internal::derive_project_name)"
ZSH_HERDR_PARENT_PREFIX_MAP=""
empty="$(hrd::internal::derive_project_name)"
print -r -- "mapped=$mapped"
print -r -- "tmux=$tmux_out"
print -r -- "empty=$empty"'

  [ "$status" -eq 0 ] || fail "parity snippet should exit 0, got $status: $output"
  local expected=$'mapped=cl-base-template\ntmux=codiplab-base-template\nempty=codiplab-base-template'
  [ "$output" = "$expected" ] || fail "expected [$expected], got [$output]"
  # The key guarantee, asserted on the tmux line alone for a clear failure:
  local tmux_line
  tmux_line="$(printf '%s\n' "$output" | grep '^tmux=')"
  [ "$tmux_line" = "tmux=codiplab-base-template" ] ||
    fail "tmux must return the FULL parent name even with the map in scope, got: $tmux_line"
  [[ "$tmux_line" != *cl-* ]] ||
    fail "tmux leaked the herdr prefix map into its output: $tmux_line"
}

# tmux parity, unmapped parent: with no map entry, herdr (default map) and
# tmux (empty map) and the empty-map herdr delegation must all produce the
# byte-identical legacy label — the pre-Phase-2 output for this input.
@test "2.7 tmux parity: unmapped parent matches herdr byte for byte" {
  mkdir -p "$WORK_ROOT/sideproject/tool"

  run run_herdr_zsh "$HOME_DIR" "$WORK_ROOT/sideproject/tool" \
    'source "${HERDR_MODULE_DIR}/../tmux/internal/base.zsh"
mapped="$(hrd::internal::derive_project_name)"
tmux_out="$(tx::internal::derive_project_name)"
ZSH_HERDR_PARENT_PREFIX_MAP=""
empty="$(hrd::internal::derive_project_name)"
print -r -- "mapped=$mapped"
print -r -- "tmux=$tmux_out"
print -r -- "empty=$empty"'

  [ "$status" -eq 0 ] || fail "parity snippet should exit 0, got $status: $output"
  local expected=$'mapped=sideproject-tool\ntmux=sideproject-tool\nempty=sideproject-tool'
  [ "$output" = "$expected" ] || fail "expected [$expected], got [$output]"
}

# tmux parity, HOME branches: PWD==HOME and parent==HOME produce core /
# core-scratch on BOTH delegators, with the default map in scope.
@test "2.7 tmux parity: HOME branches match herdr byte for byte" {
  mkdir -p "$HOME_DIR/scratch"
  local parity='source "${HERDR_MODULE_DIR}/../tmux/internal/base.zsh"
mapped="$(hrd::internal::derive_project_name)"
tmux_out="$(tx::internal::derive_project_name)"
print -r -- "mapped=$mapped"
print -r -- "tmux=$tmux_out"'

  run run_herdr_zsh "$HOME_DIR" "$HOME_DIR" "$parity"
  [ "$status" -eq 0 ] || fail "HOME parity snippet should exit 0, got $status: $output"
  local expected=$'mapped=core\ntmux=core'
  [ "$output" = "$expected" ] || fail "expected [$expected], got [$output]"

  run run_herdr_zsh "$HOME_DIR" "$HOME_DIR/scratch" "$parity"
  [ "$status" -eq 0 ] || fail "parent==HOME parity snippet should exit 0, got $status: $output"
  expected=$'mapped=core-scratch\ntmux=core-scratch'
  [ "$output" = "$expected" ] || fail "expected [$expected], got [$output]"
}
