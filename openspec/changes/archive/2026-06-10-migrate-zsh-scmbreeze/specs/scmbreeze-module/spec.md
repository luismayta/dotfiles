## ADDED Requirements

### Requirement: scm_breeze integration
The system SHALL integrate with scm_breeze for enhanced git status display.

#### Scenario: Initialize scm_breeze
- **WHEN** the scmbreeze module loads
- **THEN** scm_breeze SHALL be initialized if installed

### Requirement: File indexing shortcuts
The system SHALL provide file indexing shortcuts for git repository navigation.

#### Scenario: Indexed file access
- **WHEN** a file index shortcut is used
- **THEN** the system SHALL reference the indexed file in git operations

### Requirement: Enhanced git status
The system SHALL provide enhanced git status display with file indexing.

#### Scenario: Git status with index numbers
- **WHEN** `git status` is invoked
- **THEN** the output SHALL include file index numbers if scm_breeze is active