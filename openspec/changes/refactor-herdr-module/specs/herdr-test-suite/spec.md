## Purpose

Provides the herdr module's regression safety net: an executable test runner wired to a `test` target, behavioral coverage of workspace-name derivation and launcher exit codes, a guard against vacuously empty suites, and a `zsh -n` syntax check enforced in both pre-commit and CI.

## ADDED Requirements

### Requirement: Executable test runner with Taskfile target
The herdr module SHALL provide an executable test runner under `zsh/modules/herdr/tests/`, and the module `Taskfile.yml` SHALL expose a `test` target that invokes it. The target SHALL execute the full suite and SHALL exit non-zero when any test fails.

#### Scenario: Run suite via Taskfile target
- **WHEN** `task test` is executed from `zsh/modules/herdr/`
- **THEN** the runner SHALL execute every test file in the tests directory
- **AND** the target SHALL exit 0 when all tests pass

#### Scenario: Failing test fails the target
- **WHEN** any test in the suite fails
- **THEN** the `test` target SHALL exit with a non-zero code

### Requirement: Naming derivation coverage
The suite SHALL cover the documented workspace-name derivation rules: the three derivation branches, the slug edge cases (non-alphanumeric characters, repeated hyphens, leading and trailing hyphens, uppercase, spaces, dots, non-ASCII characters), and the explicit-argument-priority case.

#### Scenario: Derivation branch coverage
- **WHEN** the suite runs
- **THEN** each of the three derivation branches SHALL be asserted against its documented output

#### Scenario: Slug edge case coverage
- **WHEN** the suite runs
- **THEN** slug normalization SHALL be asserted for spaces, dots, non-ASCII characters, and uppercase letters
- **AND** slug normalization SHALL be asserted for repeated, leading, and trailing hyphens

#### Scenario: Explicit argument priority coverage
- **WHEN** the suite runs
- **THEN** an explicit argument SHALL be asserted to take precedence over directory context

### Requirement: Launcher exit-code coverage against mocked herdr
The suite SHALL verify the project launcher's exit codes against a mocked `herdr` binary: attaching to an existing workspace returns 0, creating a workspace returns 0, declining creation returns 0, and a hard failure returns 1.

#### Scenario: Attaching to existing workspace returns 0
- **WHEN** the mocked `herdr` reports an existing workspace and the launcher attaches to it
- **THEN** the launcher SHALL exit with code 0

#### Scenario: Creating a workspace returns 0
- **WHEN** the mocked `herdr` reports no existing workspace and creation succeeds
- **THEN** the launcher SHALL exit with code 0

#### Scenario: Declining creation returns 0
- **WHEN** the launcher offers to create a workspace and the user declines
- **THEN** the launcher SHALL exit with code 0

#### Scenario: Hard failure returns 1
- **WHEN** the mocked `herdr` command fails with an error
- **THEN** the launcher SHALL exit with code 1

### Requirement: Suite is a regression net
The suite SHALL be a real regression net, not a smoke test: every documented derivation rule MUST have an assertion pinned to its exact expected output, so altering documented behavior breaks the suite.

#### Scenario: Altered derivation branch fails the suite
- **WHEN** the derivation output for any documented branch input is changed
- **THEN** the suite SHALL fail

#### Scenario: Altered slug rule fails the suite
- **WHEN** slug normalization no longer collapses or strips hyphens as documented
- **THEN** the suite SHALL fail

### Requirement: zsh syntax check in pre-commit and CI
A `zsh -n` syntax check over every `.zsh` file in the herdr module SHALL be enforced in BOTH pre-commit and CI, in addition to shellcheck. A syntax error in any module `.zsh` file SHALL fail both gates.

#### Scenario: Pre-commit rejects syntax errors
- **WHEN** a commit includes a module `.zsh` file containing a syntax error
- **THEN** the pre-commit hook SHALL fail

#### Scenario: CI rejects syntax errors
- **WHEN** CI runs over a change containing a syntax error in any module `.zsh` file
- **THEN** the CI lint job SHALL fail

#### Scenario: Both gates run zsh -n alongside shellcheck
- **WHEN** pre-commit or CI executes
- **THEN** `zsh -n` SHALL run over every `.zsh` file in the module
- **AND** shellcheck SHALL still run

### Requirement: Empty test directory fails loudly
The runner SHALL fail loudly when its test directory contains no test files instead of passing vacuously: it SHALL exit non-zero and state that no test files were found. A glob that matches nothing MUST NOT be allowed to determine the outcome by accident.

#### Scenario: Empty test directory fails with explicit message
- **WHEN** the tests directory contains no test files
- **THEN** the runner SHALL exit with a non-zero code
- **THEN** the runner SHALL print a message stating that no test files were found
- **AND** the runner MUST NOT report success

#### Scenario: Glob-based runner precedent
- **WHEN** the existing `zsh/modules/git/tests/run.sh` globs `*.bats` in a repository with zero `.bats` files
- **THEN** it exits 1 today without naming the problem
- **AND** the herdr runner SHALL fail with an explicit missing-test-files message instead of an unexplained empty-glob result
