#!/usr/bin/env bats
# Acceptance tests for hrd::internal::derive_project_name.
# OpenSpec change: refactor-herdr-module — tasks 1.3, 1.4, 1.5.
#
# Contract: openspec/changes/refactor-herdr-module/specs/workspace-naming/spec.md
#
# CRITICAL: the function under test uses zsh-only expansions (${PWD:t},
# ${PWD:h:t}, ${name:l}). In bash those are valid-but-EMPTY substring
# expansions, so every call below goes through run_herdr_zsh (a real
# `zsh -f` subshell that cds to a fixture dir with a controlled $HOME) —
# never call the function directly from bats.
#
# Fixtures: setup() creates a fresh fake $HOME per test; teardown() removes
# it after EVERY test (pass or fail) so repeated runs never leak state.

load "${BATS_TEST_DIRNAME}/test_helper.bash"

setup() {
  HERDR_FIXTURE_HOME="$(make_herdr_tmpdir)"
}

teardown() {
  cleanup_herdr_tmpdir "$HERDR_FIXTURE_HOME"
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 1.3 — the three derivation branches
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Home directory yields core" — WHEN cwd is the user's home
# directory THEN the label SHALL be `core`.
@test "1.3 PWD == HOME derives exactly core" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name'
  [ "$status" -eq 0 ]
  [ "$output" = "core" ]
}

# Spec scenario: "Direct child of home yields core prefix" — WHEN cwd is
# <home>/scratch THEN the label SHALL be `core-scratch`.
@test "1.3 parent == HOME derives core-{dir} (core-scratch)" {
  mkdir -p "$HERDR_FIXTURE_HOME/scratch"
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME/scratch" \
    'hrd::internal::derive_project_name'
  [ "$status" -eq 0 ]
  [ "$output" = "core-scratch" ]
}

# Spec scenario: "Nested directory yields parent and dir" — WHEN cwd is
# <home>/work/myproject THEN the label SHALL be `work-myproject`.
@test "1.3 nested directory derives {parent}-{dir} (work-myproject)" {
  mkdir -p "$HERDR_FIXTURE_HOME/work/myproject"
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME/work/myproject" \
    'hrd::internal::derive_project_name'
  [ "$status" -eq 0 ]
  [ "$output" = "work-myproject" ]
}

# Task 1.3 + task 1.4 — the else-branch with a SPACE in the parent directory
# name: <home>/My Work/myproject -> "My Work-myproject" -> `my-work-myproject`.
# Phase 2's explicit prefix map parses on NEWLINE delimiters precisely because
# parent directories like "My Work" may contain spaces, so this input must be
# pinned from the start.
@test "1.3 nested directory with a space in the parent name derives my-work-myproject" {
  mkdir -p "$HERDR_FIXTURE_HOME/My Work/myproject"
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME/My Work/myproject" \
    'hrd::internal::derive_project_name'
  [ "$status" -eq 0 ]
  [ "$output" = "my-work-myproject" ]
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 1.4 — slug normalization (explicit-argument path, so each pure slug
# rule is isolated from the directory-derivation branches)
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Spaces become single hyphens" + uppercase conversion —
# WHEN `My Project Files` contributes to a label THEN slug SHALL be
# `my-project-files`.
@test "1.4 slug: spaces become hyphens and uppercase lowercases (My Project Files)" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name "My Project Files"'
  [ "$status" -eq 0 ]
  [ "$output" = "my-project-files" ]
}

# Spec scenario: "Dots and repeated hyphens collapse" — WHEN `api..v2`
# contributes THEN dots become hyphens, the run collapses, slug SHALL be
# `api-v2`.
@test "1.4 slug: dots collapse repeated hyphens (api..v2 -> api-v2)" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name "api..v2"'
  [ "$status" -eq 0 ]
  [ "$output" = "api-v2" ]
}

# Spec scenario: "Leading and trailing hyphens removed" — WHEN `-draft-`
# contributes THEN slug SHALL be `draft`.
@test "1.4 slug: leading and trailing hyphens removed (-draft- -> draft)" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name "-draft-"'
  [ "$status" -eq 0 ]
  [ "$output" = "draft" ]
}

# Spec scenario: "Non-ASCII characters become hyphens" — WHEN `café`
# contributes THEN `é` becomes a hyphen, the trailing hyphen is removed,
# slug SHALL be `caf`.
@test "1.4 slug: non-ASCII becomes hyphen (café -> caf)" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name "café"'
  [ "$status" -eq 0 ]
  [ "$output" = "caf" ]
}

# Spec scenario: "Spaces become single hyphens" (uppercase half) — uppercase
# letters SHALL be converted to lowercase: `UPPER CASE` -> `upper-case`.
@test "1.4 slug: uppercase converts to lowercase (UPPER CASE -> upper-case)" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name "UPPER CASE"'
  [ "$status" -eq 0 ]
  [ "$output" = "upper-case" ]
}

# Task 1.4 — a literal RUN of adjacent hyphens collapses to a single hyphen:
# `foo----bar` -> `foo-bar`.
@test "1.4 slug: repeated hyphens collapse to one (foo----bar -> foo-bar)" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name "foo----bar"'
  [ "$status" -eq 0 ]
  [ "$output" = "foo-bar" ]
}

# Task 1.4 — hyphen runs at BOTH edges: the collapse loop runs before the
# leading/trailing strip, so `---x---` fully collapses to `-x-`, the single
# leading and trailing hyphen are stripped, and the result is `x`.
# NOTE: this matches the spec ("leading and trailing hyphens SHALL be
# removed"); a `--x--` outcome would still carry edge hyphens.
@test "1.4 slug: edge hyphen runs collapse then strip (---x--- -> x)" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name "---x---"'
  [ "$status" -eq 0 ]
  [ "$output" = "x" ]
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 1.5 — explicit argument takes priority over directory context
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Explicit argument overrides derivation" — an explicit
# argument wins over the HOME branch (which would have derived `core`);
# the argument is still slugified.
@test "1.5 explicit argument overrides the PWD==HOME core branch" {
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME" \
    'hrd::internal::derive_project_name "Custom Name"'
  [ "$status" -eq 0 ]
  [ "$output" = "custom-name" ]
}

# Spec scenario: "Explicit argument overrides derivation" — the same explicit
# argument wins over the nested branch (which would have derived
# `work-myproject`), proving the directory branches and any prefix map are
# not consulted when $1 is given.
@test "1.5 explicit argument overrides the {parent}-{dir} branch" {
  mkdir -p "$HERDR_FIXTURE_HOME/work/myproject"
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME/work/myproject" \
    'hrd::internal::derive_project_name "Custom Name"'
  [ "$status" -eq 0 ]
  [ "$output" = "custom-name" ]
}

# Spec scenario: "Directory context used when no argument" — with NO argument,
# on the very same fixture, the directory-derived label is returned instead
# of any explicit value.
@test "1.5 without an argument the directory-derived label is returned" {
  mkdir -p "$HERDR_FIXTURE_HOME/work/myproject"
  run run_herdr_zsh "$HERDR_FIXTURE_HOME" "$HERDR_FIXTURE_HOME/work/myproject" \
    'hrd::internal::derive_project_name'
  [ "$status" -eq 0 ]
  [ "$output" = "work-myproject" ]
}
