# cleanup-confirmation Specification

## Purpose
TBD - created by archiving change harden-clean-safety. Update Purpose after archive.
## Requirements
### Requirement: Confirmation applies to all destructive paths
The system SHALL apply confirmation, dry-run, and force guards to every destructive cleanup path, including cache-path removal.

#### Scenario: Cache cleanup prompts for confirmation
- **WHEN** user runs `cleanup::pip`, `cleanup::cargo`, `cleanup::bun`, `cleanup::pnpm`, `cleanup::brew`, or `cleanup::virtualenvs`
- **AND** `ZSH_CLEAN_CONFIRM` is not set to `false` and `ZSH_CLEAN_FORCE` is not set
- **THEN** system displays a confirmation prompt listing the target path
- **AND** waits for user input before removing

#### Scenario: Force skips confirmation on caches
- **WHEN** user runs a cache cleanup with `ZSH_CLEAN_FORCE=true` or `--force`
- **THEN** system removes the cache without prompting

#### Scenario: Dry-run applies to caches
- **WHEN** `ZSH_CLEAN_DRY_RUN=true` is set
- **AND** user runs a cache cleanup
- **THEN** system reports what would be removed
- **AND** no files are removed

#### Scenario: Confirmation disabled via environment
- **WHEN** `ZSH_CLEAN_CONFIRM=false` is set
- **AND** user runs a cache cleanup
- **THEN** system removes without prompting
