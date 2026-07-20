## ADDED Requirements

### Requirement: Environment variable configuration for paths
The system SHALL allow users to customize cleanup paths via environment variables.

#### Scenario: Custom pip cache path
- **WHEN** `CLEAN_PIP_CACHE_PATH` is set to `/custom/pip/cache`
- **AND** user runs `cleanup::pip`
- **THEN** system cleans `/custom/pip/cache` instead of default `${HOME}/Library/Caches/pip`

#### Scenario: Custom npm cache path
- **WHEN** `CLEAN_NPM_CACHE_PATH` is set to `/custom/npm/cache`
- **AND** user runs `cleanup::npm`
- **THEN** system cleans `/custom/npm/cache` instead of default npm cache location

#### Scenario: Fallback to default path
- **WHEN** custom path environment variable is not set
- **AND** user runs cleanup function
- **THEN** system uses default path for that platform

### Requirement: Configurable behavior flags
The system SHALL support environment variables for cleanup behavior.

#### Scenario: Disable dry-run by default
- **WHEN** `CLEAN_DRY_RUN=false` is set
- **AND** user runs cleanup without flags
- **THEN** system executes cleanup without dry-run mode

#### Scenario: Disable confirmation prompts
- **WHEN** `CLEAN_CONFIRM=false` is set
- **AND** user runs cleanup without `--force` flag
- **THEN** system executes cleanup without prompting

#### Scenario: Enable verbose logging
- **WHEN** `CLEAN_VERBOSE=true` is set
- **AND** user runs cleanup
- **THEN** system displays detailed output for each operation

### Requirement: Path validation
The system SHALL validate custom paths before attempting cleanup.

#### Scenario: Non-existent custom path
- **WHEN** `CLEAN_PIP_CACHE_PATH` points to non-existent directory
- **AND** user runs `cleanup::pip`
- **THEN** system displays warning message
- **AND** skips cleanup for that path
- **AND** continues with other cleanup operations

#### Scenario: Custom path is file not directory
- **WHEN** `CLEAN_PIP_CACHE_PATH` points to a file instead of directory
- **AND** user runs `cleanup::pip`
- **THEN** system displays error message
- **AND** skips cleanup for that path

### Requirement: Configuration documentation
The system SHALL provide clear documentation of available configuration options.

#### Scenario: Help shows configuration options
- **WHEN** user runs `cleanup --help`
- **THEN** system displays list of available environment variables
- **AND** shows default values for each
- **AND** provides examples of common configurations
