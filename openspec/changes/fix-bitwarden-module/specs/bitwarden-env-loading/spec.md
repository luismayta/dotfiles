## ADDED Requirements

### Requirement: Automatic environment loading before Bitwarden CLI operations

The system SHALL automatically load environment variables from `~/.bw_env` before executing any Bitwarden CLI command.

#### Scenario: Environment file exists
- **WHEN** `bw::search` or `bw::search::*` is invoked
- **AND** the file `~/.bw_env` exists
- **THEN** the system SHALL source `~/.bw_env` before calling `bw list items`

#### Scenario: Environment file does not exist
- **WHEN** `bw::search` or `bw::search::*` is invoked
- **AND** the file `~/.bw_env` does not exist
- **THEN** the system SHALL proceed without loading environment variables
- **AND** the system SHALL NOT display an error about the missing file

### Requirement: Environment loading is idempotent

The system SHALL ensure that calling `bw::load::env` multiple times has the same effect as calling it once.

#### Scenario: Multiple invocations
- **WHEN** `bw::load::env` is called multiple times in sequence
- **THEN** the environment variables from `~/.bw_env` SHALL be loaded exactly once per call
- **AND** no duplicate variable assignments SHALL occur
