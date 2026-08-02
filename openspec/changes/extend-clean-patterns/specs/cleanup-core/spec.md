## MODIFIED Requirements

### Requirement: Consolidated cleanup functions
The system SHALL consolidate duplicate cleanup logic into unified functions, with all directory/file patterns declared in module configuration rather than hardcoded in implementation.

#### Scenario: cleanup::unnecessary integrated into cleanup
- **WHEN** user runs `cleanup`
- **THEN** system executes all unnecessary file cleanup patterns
- **AND** does not call separate `cleanup::unnecessary` function

#### Scenario: No duplicate pattern matching
- **WHEN** cleanup operations execute
- **THEN** each file pattern is matched only once
- **AND** no redundant find commands execute

#### Scenario: All patterns sourced from configuration
- **WHEN** `_cleanup::unnecessary` executes
- **THEN** directory patterns come exclusively from `CLEAN_BASE_DIR_PATTERNS`
- **AND** file patterns come exclusively from `CLEAN_BASE_FILE_PATTERNS`
- **AND** no additional patterns are hardcoded inside `internal/base.zsh`

### Requirement: Consistent function naming
The system SHALL use consistent naming conventions for cleanup functions.

#### Scenario: All functions use cleanup:: prefix
- **WHEN** cleanup functions are defined
- **THEN** all public functions use `cleanup::` prefix
- **AND** internal helpers use `_cleanup::` prefix

#### Scenario: Platform functions follow pattern
- **WHEN** platform-specific functions are defined
- **THEN** they use `cleanup::<platform>::` prefix (e.g., `cleanup::osx::trash`)

### Requirement: Improved error messages
The system SHALL provide clear, actionable error messages.

#### Scenario: Not implemented message is helpful
- **WHEN** function is not implemented for current platform
- **THEN** system displays "Function not available for ${OSTYPE}"
- **AND** suggests checking for updates or contributing implementation

#### Scenario: Tool not found message is helpful
- **WHEN** required tool is not installed
- **THEN** system displays "Tool '${tool}' not found"
- **AND** suggests installation command (e.g., "Install with: brew install ${tool}")
