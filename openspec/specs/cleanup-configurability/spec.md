# cleanup-configurability Specification

## Purpose
TBD - created by archiving change improve-zsh-clean-module. Update Purpose after archive.
## Requirements
### Requirement: Environment variable configuration for paths
The system SHALL allow users to customize cleanup paths via environment variables using the `ZSH_CLEAN_` prefix.

#### Scenario: Custom pip cache path
- **WHEN** `ZSH_CLEAN_BASE_CACHE_PIP` is set to `/custom/pip/cache`
- **AND** user runs `cleanup::pip`
- **THEN** system cleans `/custom/pip/cache` instead of the default pip cache location

#### Scenario: Fallback to default path
- **WHEN** neither custom nor legacy path variable is set
- **AND** user runs cleanup function
- **THEN** system uses default path for that platform

### Requirement: Configurable behavior flags
The system SHALL support environment variables for cleanup behavior using the `ZSH_CLEAN_` prefix.

#### Scenario: Disable dry-run by default
- **WHEN** `ZSH_CLEAN_DRY_RUN=false` is set
- **AND** user runs cleanup without flags
- **THEN** system executes cleanup without dry-run mode

#### Scenario: Disable confirmation prompts
- **WHEN** `ZSH_CLEAN_CONFIRM=false` is set
- **AND** user runs cleanup without `--force` flag
- **THEN** system executes cleanup without prompting

### Requirement: Path validation
The system SHALL validate custom paths before attempting cleanup.

#### Scenario: Non-existent custom path
- **WHEN** `ZSH_CLEAN_BASE_CACHE_PIP` points to non-existent directory
- **AND** user runs `cleanup::pip`
- **THEN** system displays warning message
- **AND** skips cleanup for that path
- **AND** continues with other cleanup operations

#### Scenario: Custom path is file not directory
- **WHEN** `ZSH_CLEAN_BASE_CACHE_PIP` points to a file instead of directory
- **AND** user runs `cleanup::pip`
- **THEN** system displays error message
- **AND** skips cleanup for that path

### Requirement: Configuration documentation
The system SHALL provide clear documentation of available configuration options.

#### Scenario: Help shows configuration options
- **WHEN** user runs `cleanup --help`
- **THEN** system displays list of available environment variables (canonical `ZSH_CLEAN_*` names)
- **AND** shows default values for each
- **AND** provides examples of common configurations

### Requirement: User pattern extension replaces list replacement
The system SHALL provide `ZSH_CLEAN_USER_DIR_PATTERNS` / `ZSH_CLEAN_USER_FILE_PATTERNS` as the mechanism for users to extend the default pattern lists.

#### Scenario: Base lists reset to defaults on load
- **WHEN** the module loads
- **THEN** `ZSH_CLEAN_BASE_DIR_PATTERNS` and `ZSH_CLEAN_BASE_FILE_PATTERNS` are re-derived from repository defaults (anti-stale)
- **AND** any previously exported base value is not relied upon

#### Scenario: User extension via dedicated variables
- **WHEN** user sets `ZSH_CLEAN_USER_DIR_PATTERNS`
- **AND** runs cleanup
- **THEN** the user patterns are merged with the repository defaults
- **AND** the user does not need to reproduce the full default list
