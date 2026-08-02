## MODIFIED Requirements

### Requirement: Confirmation prompts for destructive operations
The system SHALL prompt for confirmation before executing destructive cleanup operations, including cache-path removal.

#### Scenario: Confirmation prompt appears
- **WHEN** user runs cleanup without `--force` flag
- **AND** `CLEAN_CONFIRM` is not set to `false`
- **THEN** system displays confirmation prompt with count of items to delete
- **AND** waits for user input (y/n)

#### Scenario: Force flag skips confirmation
- **WHEN** user runs cleanup with `--force` flag
- **THEN** system executes cleanup without prompting

#### Scenario: Confirmation disabled via environment
- **WHEN** `CLEAN_CONFIRM=false` is set
- **THEN** system executes cleanup without prompting

#### Scenario: Cache paths follow the same confirmation contract
- **WHEN** user runs any cache-path cleanup function (`cleanup::pip`, `cleanup::cargo`, `cleanup::bun`, `cleanup::pnpm`, `cleanup::ccache`, `cleanup::pre_commit`, `cleanup::virtualenvs`, `cleanup::brew`, `cleanup::system::*`)
- **AND** `CLEAN_CONFIRM` is not `false` and `CLEAN_FORCE` is not set
- **THEN** system prompts for confirmation before removing the target path

## ADDED Requirements

### Requirement: Python interpreter cleanup is non-destructive
The system SHALL NOT remove Python interpreter installations as part of general cleanup.

#### Scenario: pyenv not removed by cleanup::all
- **WHEN** user runs `cleanup::all`
- **THEN** system does not delete `~/.pyenv/versions` or any installed interpreter
- **AND** pyenv-related cleanup, if offered, only reports or prunes unused versions without deleting interpreters

#### Scenario: Direct destructive intent requires explicit action
- **WHEN** user explicitly invokes a destructive pyenv operation
- **THEN** system confirms the operation with a clear warning listing what will be removed
