## ADDED Requirements

### Requirement: OpenSpec PATH loading
The system SHALL load the OpenSpec binary into PATH during shell startup if it exists.

#### Scenario: Binary exists in npm global bin
- **WHEN** the shell starts and OpenSpec binary exists at `$(npm root -g)/../bin/openspec`
- **THEN** the path containing the OpenSpec binary SHALL be added to `$PATH`

#### Scenario: Binary not found
- **WHEN** the shell starts and OpenSpec binary does not exist
- **THEN** no error SHALL be raised and PATH SHALL remain unchanged

### Requirement: OpenSpec installation
The system SHALL provide a function to install OpenSpec via npm.

#### Scenario: Successful installation
- **WHEN** user runs `ai::openspec::install`
- **THEN** the system SHALL execute `npm install -g @fission-ai/openspec@latest`
- **AND** the system SHALL run `ai::internal::openspec::register_skill` to register with OpenCode

#### Scenario: Installation failure
- **WHEN** npm install fails
- **THEN** the system SHALL display an error message and return non-zero exit code

### Requirement: OpenSpec upgrade
The system SHALL provide a function to upgrade OpenSpec to the latest version.

#### Scenario: Successful upgrade
- **WHEN** user runs `ai::openspec::upgrade`
- **THEN** the system SHALL execute `npm install -g @fission-ai/openspec@latest --force`
- **AND** the system SHALL run `ai::internal::openspec::register_skill` to re-register with OpenCode

### Requirement: OpenSpec project setup
The system SHALL provide a function to set up OpenSpec for the current project.

#### Scenario: Successful project setup
- **WHEN** user runs `ai::openspec::setup`
- **AND** OpenSpec is installed
- **THEN** the system SHALL execute `openspec install --platform opencode --project`
- **AND** display success message

#### Scenario: OpenSpec not installed
- **WHEN** user runs `ai::openspec::setup`
- **AND** OpenSpec is not installed
- **THEN** the system SHALL display error message "openspec is not installed. Run ai::openspec::install first."
- **AND** return non-zero exit code

### Requirement: OpenCode skill registration
The system SHALL register OpenSpec as a skill with OpenCode.

#### Scenario: Global registration
- **WHEN** `ai::internal::openspec::register_skill` is called
- **THEN** the system SHALL execute `openspec install --platform opencode`
- **AND** this SHALL register OpenSpec globally with OpenCode

### Requirement: Public API wrappers
The system SHALL expose thin public wrapper functions that delegate to internal implementations.

#### Scenario: Install wrapper
- **WHEN** user calls `ai::openspec::install`
- **THEN** the function SHALL delegate to `ai::internal::openspec::install`

#### Scenario: Upgrade wrapper
- **WHEN** user calls `ai::openspec::upgrade`
- **THEN** the function SHALL delegate to `ai::internal::openspec::upgrade`

#### Scenario: Setup wrapper
- **WHEN** user calls `ai::openspec::setup`
- **THEN** the function SHALL delegate to `ai::internal::openspec::setup`
