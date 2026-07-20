## ADDED Requirements

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
The system SHALL prompt for confirmation before executing destructive cleanup operations.

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
