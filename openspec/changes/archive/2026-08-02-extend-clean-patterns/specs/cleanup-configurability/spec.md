## ADDED Requirements

### Requirement: User-extensible cleanup patterns
The system SHALL allow users to extend or override the cleanup pattern lists via environment variables, preserving defaults when unset.

#### Scenario: Default patterns preserved when unset
- **WHEN** user runs `cleanup`
- **AND** `CLEAN_BASE_DIR_PATTERNS` and `CLEAN_BASE_FILE_PATTERNS` are not set
- **THEN** system uses the full built-in default pattern lists

#### Scenario: User override replaces default list
- **WHEN** user sets `CLEAN_BASE_FILE_PATTERNS` in `~/.customrc` (sourced before modules)
- **AND** runs `cleanup`
- **THEN** system uses the user-provided file pattern list instead of the default
- **AND** the user's value is not overwritten by module loading

#### Scenario: Additional user patterns merge with defaults
- **WHEN** user provides additional patterns through the documented extension variable
- **AND** runs `cleanup`
- **THEN** system matches both the built-in patterns and the user-added patterns
- **AND** no pattern is matched twice
