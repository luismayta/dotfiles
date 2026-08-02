# cleanup-user-patterns Specification

## Purpose
TBD - created by archiving change clean-user-patterns. Update Purpose after archive.
## Requirements
### Requirement: User patterns merge with defaults
The system SHALL let users extend the cleanup pattern lists via dedicated user-pattern variables, merged with built-in defaults at runtime.

#### Scenario: User dir patterns merged
- **WHEN** user sets `ZSH_CLEAN_USER_DIR_PATTERNS="my_build|my_tmp"` before module load
- **AND** runs `cleanup`
- **THEN** system matches both the built-in directory patterns and `my_build`/`my_tmp`
- **AND** each pattern is matched only once

#### Scenario: User file patterns merged
- **WHEN** user sets `ZSH_CLEAN_USER_FILE_PATTERNS="*.custom_log"` before module load
- **AND** runs `cleanup`
- **THEN** system deletes files matching the built-in file patterns and `*.custom_log`

#### Scenario: Default empty
- **WHEN** user does not set `ZSH_CLEAN_USER_DIR_PATTERNS` or `ZSH_CLEAN_USER_FILE_PATTERNS`
- **THEN** system uses only the built-in patterns
- **AND** no empty-pattern find runs

### Requirement: Stale pattern lists do not freeze defaults
The system SHALL re-derive the base pattern lists from repository defaults on every module load.

#### Scenario: Stale export is overridden
- **WHEN** a shell session has `ZSH_CLEAN_BASE_DIR_PATTERNS` exported with an outdated value (from a session started before a patterns change)
- **AND** the module loads in a fresh shell
- **THEN** system uses the current repository default list
- **AND** the outdated export does not persist

#### Scenario: New patterns apply without manual unset
- **WHEN** the repository's default pattern list is updated
- **AND** user opens a new shell (or re-sources the module)
- **THEN** the updated patterns are effective
- **AND** no manual `unset` of the base variables is required

### Requirement: Legacy CLEAN_* aliases preserved
The system SHALL keep the legacy `CLEAN_*` aliases functional after the anti-stale unset.

#### Scenario: Legacy variable still readable
- **WHEN** user reads `CLEAN_BASE_DIR_PATTERNS` after module load
- **THEN** it reflects the current effective value (default or user-merged)
- **AND** equals `ZSH_CLEAN_BASE_DIR_PATTERNS`

#### Scenario: Legacy dry-run flag honored
- **WHEN** `CLEAN_DRY_RUN=true` is set (legacy alias)
- **AND** user runs cleanup
- **THEN** system runs in dry-run mode
