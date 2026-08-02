# cleanup-safety Specification

## Purpose
TBD - created by archiving change improve-zsh-clean-module. Update Purpose after archive.
## Requirements
### Requirement: Dry-run mode for cleanup operations
The system SHALL support a `--dry-run` flag that shows what would be deleted without actually deleting files.

#### Scenario: Dry-run shows files to be deleted
- **WHEN** user runs `cleanup --dry-run`
- **THEN** system displays list of files/directories that would be deleted
- **AND** no files are actually deleted

#### Scenario: Dry-run with specific cleanup function
- **WHEN** user runs `cleanup::npm --dry-run`
- **THEN** system shows npm cache files that would be deleted
- **AND** npm cache remains unchanged

### Requirement: Confirmation prompts for destructive operations
The system SHALL prompt for confirmation before executing destructive cleanup operations, including cache-path removal.

#### Scenario: Confirmation prompt appears
- **WHEN** user runs cleanup without `--force` flag
- **AND** `ZSH_CLEAN_CONFIRM` is not set to `false`
- **THEN** system displays confirmation prompt with count of items to delete
- **AND** waits for user input (y/n)

#### Scenario: Force flag skips confirmation
- **WHEN** user runs cleanup with `--force` flag
- **THEN** system executes cleanup without prompting

#### Scenario: Confirmation disabled via environment
- **WHEN** `ZSH_CLEAN_CONFIRM=false` is set
- **THEN** system executes cleanup without prompting

#### Scenario: Cache paths follow the same confirmation contract
- **WHEN** user runs any cache-path cleanup function (`cleanup::pip`, `cleanup::cargo`, `cleanup::bun`, `cleanup::pnpm`, `cleanup::ccache`, `cleanup::pre_commit`, `cleanup::virtualenvs`, `cleanup::brew`, `cleanup::system::*`)
- **AND** `ZSH_CLEAN_CONFIRM` is not `false` and `ZSH_CLEAN_FORCE` is not set
- **THEN** system prompts for confirmation before removing the target path

### Requirement: Deletion logging
The system SHALL log all deleted files and directories for audit purposes.

#### Scenario: Verbose output shows deletions
- **WHEN** cleanup executes with default settings
- **THEN** system prints each deleted file/directory path
- **AND** displays summary count of deleted items

#### Scenario: Silent mode suppresses output
- **WHEN** cleanup executes with `--silent` flag
- **THEN** system suppresses individual deletion output
- **AND** still displays final summary

### Requirement: Safe defaults
The system SHALL default to safe mode requiring explicit opt-in for destructive operations.

#### Scenario: Default behavior requires confirmation
- **WHEN** user runs cleanup without any flags
- **THEN** system shows dry-run output first
- **AND** prompts for confirmation before proceeding

#### Scenario: Environment variable overrides default
- **WHEN** `ZSH_CLEAN_DRY_RUN=true` is set
- **THEN** system runs in dry-run mode by default

### Requirement: Python interpreter cleanup is non-destructive
The system SHALL NOT remove Python interpreter installations as part of general cleanup.

#### Scenario: pyenv not removed by cleanup::all
- **WHEN** user runs `cleanup::all`
- **THEN** system does not delete `~/.pyenv/versions` or any installed interpreter
- **AND** pyenv-related cleanup, if offered, only reports or prunes unused versions without deleting interpreters

#### Scenario: Direct destructive intent requires explicit action
- **WHEN** user explicitly invokes a destructive pyenv operation
- **THEN** system confirms the operation with a clear warning listing what will be removed

### Requirement: Pattern-based file deletion confirms
The system SHALL apply confirmation to pattern-based file deletion, matching the cache-path contract.

#### Scenario: File patterns prompt by default
- **WHEN** user runs `cleanup`
- **AND** files matching `*.log`, `*.pyc`, `*.tmp`, `.DS_Store` exist in the tree
- **AND** `ZSH_CLEAN_CONFIRM` is not `false` and `ZSH_CLEAN_FORCE` is not set
- **THEN** system displays the confirmation prompt with the matched paths
- **AND** waits for user input before deleting

#### Scenario: Force skips file confirmation
- **WHEN** user runs cleanup with `ZSH_CLEAN_FORCE=true` or `--force`
- **THEN** system deletes matching files without prompting

#### Scenario: Dry-run lists file matches
- **WHEN** `ZSH_CLEAN_DRY_RUN=true` is set
- **AND** user runs `cleanup`
- **THEN** system lists all file matches that would be deleted
- **AND** deletes nothing

#### Scenario: Confirmation disabled via environment
- **WHEN** `ZSH_CLEAN_CONFIRM=false` is set
- **AND** user runs `cleanup`
- **THEN** system deletes matching files without prompting

