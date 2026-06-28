## ADDED Requirements

### Requirement: Remove disabled modules with no active configuration
Modules set to `disabled = true` that contain no referenced configuration SHALL be removed entirely.

#### Scenario: Battery module removed
- **WHEN** searching for `[battery]` in the file
- **THEN** it SHALL NOT exist (battery is disabled and its display blocks are dead code)

#### Scenario: Time module removed
- **WHEN** searching for `[time]` in the file
- **THEN** it SHALL NOT exist (time is disabled with `disabled = true`)

#### Scenario: Localip module removed
- **WHEN** searching for `[localip]` in the file
- **THEN** it SHALL NOT exist (localip is disabled with `disabled = true`)

### Requirement: Remove commented-out code
Lines that are commented out (`#` prefixed configuration, not section headers or descriptions) SHALL be removed.

#### Scenario: No commented style lines
- **WHEN** searching for `#.*style` or `#.*format` commented lines
- **THEN** the file SHALL contain none
