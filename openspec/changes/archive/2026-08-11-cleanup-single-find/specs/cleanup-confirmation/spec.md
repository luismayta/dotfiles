## ADDED Requirements

### Requirement: Consolidated pattern sweep confirmation
The system SHALL request a single consolidated confirmation for the pattern sweep instead of one prompt per pattern, while preserving the per-path confirmation of cache removals.

#### Scenario: Single prompt for the directory sweep
- **WHEN** user runs `cleanup`
- **AND** the consolidated directory `find` matches items
- **AND** `ZSH_CLEAN_CONFIRM` is not set to `false` and `ZSH_CLEAN_FORCE` is not set
- **THEN** system displays one confirmation prompt with the total item count and affected pattern groups
- **AND** waits for a single user response before removing any directory

#### Scenario: Single prompt for the file sweep
- **WHEN** user runs `cleanup`
- **AND** the consolidated file `find` matches items
- **AND** confirmation is enabled
- **THEN** system displays one confirmation prompt for all matched files
- **AND** waits for a single user response before deleting any file

#### Scenario: Declined consolidated prompt removes nothing
- **WHEN** user declines the consolidated confirmation prompt
- **THEN** system removes no items from that sweep

#### Scenario: Force skips consolidated prompts
- **WHEN** user runs `cleanup` with `ZSH_CLEAN_FORCE=true`
- **THEN** system removes all swept items without prompting

#### Scenario: Dry-run lists consolidated matches
- **WHEN** `ZSH_CLEAN_DRY_RUN=true` is set
- **AND** user runs `cleanup`
- **THEN** system reports the items that would be removed, grouped by pattern
- **AND** no files are removed

#### Scenario: Cache paths keep individual confirmation
- **WHEN** user runs `cleanup::pip`, `cleanup::cargo`, `cleanup::bun`, `cleanup::pnpm`, `cleanup::brew`, or `cleanup::virtualenvs`
- **THEN** system keeps the existing per-target confirmation prompt listing the target path
