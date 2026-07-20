## ADDED Requirements

### Requirement: Message functions use core utilities
The system SHALL use message functions from `zsh/core/` instead of inline implementations.

#### Scenario: Info messages use core::internal::message::info
- **WHEN** cleanup function calls `message_info`
- **THEN** system uses `core::internal::message::info` from core module
- **AND** displays consistent formatting with other modules

#### Scenario: Success messages use core::internal::message::success
- **WHEN** cleanup function calls `message_success`
- **THEN** system uses `core::internal::message::success` from core module
- **AND** displays green success indicator

#### Scenario: Warning messages use core::internal::message::warning
- **WHEN** cleanup function calls `message_warning`
- **THEN** system uses `core::internal::message::warning` from core module
- **AND** displays yellow warning indicator

#### Scenario: Error messages use core::internal::message::error
- **WHEN** cleanup function calls `message_error`
- **THEN** system uses `core::internal::message::error` from core module
- **AND** displays red error indicator

## ADDED Requirements

### Requirement: Consolidated cleanup functions
The system SHALL consolidate duplicate cleanup logic into unified functions.

#### Scenario: cleanup::unnecessary integrated into cleanup
- **WHEN** user runs `cleanup`
- **THEN** system executes all unnecessary file cleanup patterns
- **AND** does not call separate `cleanup::unnecessary` function

#### Scenario: No duplicate pattern matching
- **WHEN** cleanup operations execute
- **THEN** each file pattern is matched only once
- **AND** no redundant find commands execute

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
