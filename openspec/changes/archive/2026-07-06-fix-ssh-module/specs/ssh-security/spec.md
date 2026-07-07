## ADDED Requirements

### Requirement: Secure default SSH config
The system SHALL provide a default SSH config (`data/assh.yml`) with `StrictHostKeyChecking` set to `ask` instead of `no`.

#### Scenario: Default assh config has StrictHostKeyChecking ask
- **WHEN** the file `data/assh.yml` is loaded
- **THEN** `StrictHostKeyChecking` SHALL be set to `ask`

### Requirement: No dead configuration variables
The module SHALL NOT define or export unused configuration variables.

#### Scenario: SSH_MESSAGE_NVM removed
- **WHEN** the module configuration is sourced
- **THEN** the variable `SSH_MESSAGE_NVM` SHALL NOT be defined or exported

### Requirement: Clean module file structure
The module SHALL NOT contain empty source files that provide no functionality.

#### Scenario: Empty stub files removed
- **WHEN** the module is loaded
- **THEN** no empty `.zsh` stub files SHALL be sourced from `config/`, `internal/`, or `pkg/` directories
