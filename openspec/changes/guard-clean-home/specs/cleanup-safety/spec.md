## MODIFIED Requirements

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
- **WHEN** `CLEAN_DRY_RUN=true` is set
- **THEN** system runs in dry-run mode by default

## ADDED Requirements

### Requirement: Pattern-based file deletion confirms
The system SHALL apply confirmation to pattern-based file deletion, matching the cache-path contract.

#### Scenario: File patterns prompt by default
- **WHEN** user runs `cleanup`
- **AND** files matching `*.log`, `*.pyc`, `*.tmp`, `.DS_Store` exist in the tree
- **AND** `CLEAN_CONFIRM` is not `false` and `CLEAN_FORCE` is not set
- **THEN** system displays the confirmation prompt with the matched paths
- **AND** waits for user input before deleting

#### Scenario: Force skips file confirmation
- **WHEN** user runs cleanup with `CLEAN_FORCE=true` or `--force`
- **THEN** system deletes matching files without prompting

#### Scenario: Dry-run lists file matches
- **WHEN** `CLEAN_DRY_RUN=true` is set
- **AND** user runs `cleanup`
- **THEN** system lists all file matches that would be deleted
- **AND** deletes nothing

#### Scenario: Confirmation disabled via environment
- **WHEN** `CLEAN_CONFIRM=false` is set
- **AND** user runs `cleanup`
- **THEN** system deletes matching files without prompting
