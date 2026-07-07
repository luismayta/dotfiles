## ADDED Requirements

### Requirement: Provide y() wrapper function for directory-preserving navigation

The system SHALL provide a `y()` shell function that launches yazi with `--cwd-file`, reads the last-browsed directory on exit, and changes the shell's working directory to it if different from the current directory.

#### Scenario: y() opens yazi and changes directory
- **WHEN** user runs `y()` and yazi exits with a different directory than $PWD
- **THEN** the shell changes to that directory automatically
- **AND** the temp cwd-file is cleaned up

#### Scenario: y() opens yazi without directory change
- **WHEN** user runs `y()` and yazi exits with the same directory as $PWD
- **THEN** the shell does not change directory
- **AND** the temp cwd-file is cleaned up

#### Scenario: y() passes arguments to yazi
- **WHEN** user runs `y() /some/path`
- **THEN** yazi opens at `/some/path`

### Requirement: Provide yazi::setup orchestrator

The system SHALL provide `yazi::setup()` that ensures yazi is installed and config is synced.

#### Scenario: Setup when yazi is not installed
- **WHEN** `yazi::setup` is called and yazi is not in $PATH
- **THEN** the function installs yazi via `yazi::install`
- **AND** syncs config via `yazi::sync`

#### Scenario: Setup when yazi is already installed
- **WHEN** `yazi::setup` is called and yazi is in $PATH
- **THEN** the function displays an info message that yazi is already installed
- **AND** syncs config via `yazi::sync`
