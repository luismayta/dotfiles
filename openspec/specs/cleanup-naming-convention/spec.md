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

### Requirement: Backward-compatible aliases preserve CLEAN_*
The system SHALL keep the old `CLEAN_*` names working as aliases to the new `ZSH_CLEAN_*` variables for the public surface.

#### Scenario: Legacy variable still readable
- **WHEN** a user or script reads `CLEAN_DRY_RUN` after module load
- **THEN** it equals the value of `ZSH_CLEAN_DRY_RUN`

#### Scenario: Legacy variable set before module load is honored
- **WHEN** a user sets `CLEAN_BASE_DIR_PATTERNS` before sourcing the module
- **THEN** the module reads that value as the effective default (alias maps old → new)

#### Scenario: Aliases marked as temporary
- **WHEN** aliases are defined
- **THEN** they are marked with a "remove in next cleanup cycle" comment
- **AND** they do not appear in the module's canonical documentation as primary names

### Requirement: Functions keep cleanup:: prefix
The system SHALL NOT rename public or internal functions as part of the naming migration.

#### Scenario: Public functions unchanged
- **WHEN** the module is loaded
- **THEN** public functions remain `cleanup`, `cleanup::*`, and internal helpers remain `_cleanup::*`

#### Scenario: Function contract preserved
- **WHEN** a user invokes `cleanup` or any `cleanup::*` function
- **THEN** behavior is identical to before the migration
