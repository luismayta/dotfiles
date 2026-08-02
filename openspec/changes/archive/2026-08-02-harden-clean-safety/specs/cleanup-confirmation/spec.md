## ADDED Requirements

### Requirement: Confirmation applies to all destructive paths
The system SHALL apply confirmation, dry-run, and force guards to every destructive cleanup path, including cache-path removal.

#### Scenario: Cache cleanup prompts for confirmation
- **WHEN** user runs `cleanup::pip`, `cleanup::cargo`, `cleanup::bun`, `cleanup::pnpm`, `cleanup::brew`, or `cleanup::virtualenvs`
- **AND** `CLEAN_CONFIRM` is not set to `false` and `CLEAN_FORCE` is not set
- **THEN** system displays a confirmation prompt listing the target path
- **AND** waits for user input before removing

#### Scenario: Force skips confirmation on caches
- **WHEN** user runs a cache cleanup with `CLEAN_FORCE=true` or `--force`
- **THEN** system removes the cache without prompting

#### Scenario: Dry-run applies to caches
- **WHEN** `CLEAN_DRY_RUN=true` is set
- **AND** user runs a cache cleanup
- **THEN** system reports what would be removed
- **AND** no files are removed

#### Scenario: Confirmation disabled via environment
- **WHEN** `CLEAN_CONFIRM=false` is set
- **AND** user runs a cache cleanup
- **THEN** system removes without prompting
