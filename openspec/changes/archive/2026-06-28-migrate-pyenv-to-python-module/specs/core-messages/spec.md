## MODIFIED Requirements

### Requirement: Centralized tool installation messages

The system SHALL define centralized message variables for common tool installation instructions in `zsh/core/config/env.zsh`. These variables SHALL be prefixed with `CORE_MESSAGE_` and SHALL reference internal monorepo module paths instead of external antibody bundles.

#### Scenario: CORE_MESSAGE_BREW is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_BREW` SHALL be set to a string that references `core::install`

#### Scenario: CORE_MESSAGE_RVM is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_RVM` SHALL be set to a string that references an internal rvm module path

#### Scenario: CORE_MESSAGE_RUST is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_RUST` SHALL be set to a string that references `zsh/modules/rust` instead of an external bundle

#### Scenario: CORE_MESSAGE_NVM is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_NVM` SHALL be set to a string with installation instructions for nvm

#### Scenario: CORE_MESSAGE_YAY is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_YAY` SHALL be set to a string with installation instructions for yay

#### Scenario: CORE_MESSAGE_CARGO is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_CARGO` SHALL be set to a string that references an internal cargo/rust module path

#### Scenario: CORE_MESSAGE_PYTHON is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_PYTHON` SHALL be set to a string that references `zsh/modules/python` as the internal module path
