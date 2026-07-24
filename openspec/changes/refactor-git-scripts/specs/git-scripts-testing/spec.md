## ADDED Requirements

### Requirement: Test framework setup
The project SHALL include a bats-core based test framework with a test runner script.

#### Scenario: Run all tests
- **WHEN** user executes `./tests/run.sh` or `bats tests/`
- **THEN** all test files are executed and results are reported

#### Scenario: Run single test file
- **WHEN** user executes `bats tests/git-root.bats`
- **THEN** only tests in that file are executed

### Requirement: Critical script coverage
Tests SHALL cover the most critical and complex scripts: `git-root`, `git-sync`, `git-delete-local-merged`, `git-status-enhanced`, `git-publish`.

#### Scenario: git-root tests
- **WHEN** tests run
- **THEN** `git-root` tests verify: returns correct path, `--relative` flag works, fails outside git repo

#### Scenario: git-sync tests
- **WHEN** tests run
- **THEN** `git-sync` tests verify: fetches upstream, merges correctly, pushes to origin

#### Scenario: git-delete-local-merged tests
- **WHEN** tests run
- **THEN** `git-delete-local-merged` tests verify: deletes merged branches, preserves unmerged branches

### Requirement: Test isolation
Each test SHALL run in an isolated temporary git repository.

#### Scenario: Test cleanup
- **WHEN** a test completes (pass or fail)
- **THEN** the temporary repository is removed

#### Scenario: Test independence
- **WHEN** multiple tests run
- **THEN** each test has its own fresh repository (no shared state)

### Requirement: Helper functions
The test framework SHALL provide common setup/teardown functions.

#### Scenario: Setup function
- **WHEN** test uses `setup_git_repo` helper
- **THEN** a temporary directory with initialized git repo is created

#### Scenario: Teardown function
- **WHEN** test uses `cleanup_git_repo` helper
- **THEN** the temporary directory is recursively removed