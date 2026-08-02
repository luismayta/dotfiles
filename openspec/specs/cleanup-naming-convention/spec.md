# cleanup-naming-convention Specification

## Purpose
TBD - created by archiving change migrate-clean-prefix. Update Purpose after archive.
## Requirements
### Requirement: Environment variables use ZSH_CLEAN_ prefix
The system SHALL name all module environment variables with the `ZSH_CLEAN_` prefix.

#### Scenario: All exported variables conform
- **WHEN** the module is loaded
- **THEN** all exported configuration variables use the `ZSH_CLEAN_` prefix (e.g., `ZSH_CLEAN_BASE_DIR_PATTERNS`, `ZSH_CLEAN_DRY_RUN`, `ZSH_CLEAN_PATH`)
- **AND** no new exported variable uses the bare `CLEAN_` prefix

#### Scenario: Module path variable conforms
- **WHEN** the module path is resolved
- **THEN** it is stored as `ZSH_CLEAN_PATH` using the `${0:A:h}` modifier

#### Scenario: Legacy CLEAN_* variables are not honored
- **WHEN** a user sets `CLEAN_DRY_RUN=true` before sourcing the module
- **THEN** dry-run is NOT enabled unless `ZSH_CLEAN_DRY_RUN=true` is also set
- **AND** no legacy `CLEAN_*` variable is read or exported by the module

### Requirement: Functions keep cleanup:: prefix
The system SHALL NOT rename public or internal functions as part of the naming migration.

#### Scenario: Public functions unchanged
- **WHEN** the module is loaded
- **THEN** public functions remain `cleanup`, `cleanup::*`, and internal helpers remain `_cleanup::*`

#### Scenario: Function contract preserved
- **WHEN** a user invokes `cleanup` or any `cleanup::*` function
- **THEN** behavior is identical to before the migration
