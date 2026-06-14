## ADDED Requirements

### Requirement: Individual package install via bun

The system SHALL provide a function to install a single bun package by name.

#### Scenario: Install a single package successfully
- **WHEN** the user calls `fnm::package::install "typescript"`
- **THEN** the system SHALL execute `bun install -g typescript`
- **THEN** the system SHALL log a success message

#### Scenario: Install with missing package name
- **WHEN** the user calls `fnm::package::install` with no arguments
- **THEN** the system SHALL log an error message indicating a package name is required
- **THEN** the system SHALL return with a non-zero exit code
- **THEN** the system SHALL NOT execute any bun command

#### Scenario: Public function delegates to internal
- **WHEN** the user calls `fnm::package::install "prettier"`
- **THEN** the system SHALL delegate to `fnm::internal::package::install "prettier"`
