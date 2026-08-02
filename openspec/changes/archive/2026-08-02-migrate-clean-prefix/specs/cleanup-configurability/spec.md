## MODIFIED Requirements

### Requirement: Environment variable configuration for paths
The system SHALL allow users to customize cleanup paths via environment variables using the `ZSH_CLEAN_` prefix.

#### Scenario: Custom pip cache path
- **WHEN** `ZSH_CLEAN_BASE_CACHE_PIP` is set to `/custom/pip/cache`
- **AND** user runs `cleanup::pip`
- **THEN** system cleans `/custom/pip/cache` instead of the default pip cache location

#### Scenario: Legacy pip cache path honored
- **WHEN** `CLEAN_BASE_CACHE_PIP` is set (legacy alias)
- **AND** user runs `cleanup::pip`
- **THEN** system cleans the legacy-specified path
- **AND** the alias maps to `ZSH_CLEAN_BASE_CACHE_PIP`

#### Scenario: Custom npm cache path
- **WHEN** `ZSH_CLEAN_BASE_CACHE_NPM` is set to `/custom/npm/cache`
- **AND** user runs `cleanup::npm`
- **THEN** system cleans `/custom/npm/cache` instead of default npm cache location

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

#### Scenario: Legacy dry-run flag honored
- **WHEN** `CLEAN_DRY_RUN=true` is set (legacy alias)
- **AND** user runs cleanup
- **THEN** system runs in dry-run mode

#### Scenario: Disable confirmation prompts
- **WHEN** `ZSH_CLEAN_CONFIRM=false` is set
- **AND** user runs cleanup without `--force` flag
- **THEN** system executes cleanup without prompting

#### Scenario: Enable verbose logging
- **WHEN** `ZSH_CLEAN_VERBOSE=true` is set
- **AND** user runs cleanup
- **THEN** system displays detailed output for each operation
