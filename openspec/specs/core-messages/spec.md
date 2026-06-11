## Requirements

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

#### Scenario: CORE_MESSAGE_PYENV is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_PYENV` SHALL be set to a string that references an internal pyenv module path

### Requirement: Modules consume centralized message variables

Each module in `zsh/modules/` SHALL reference `$CORE_MESSAGE_*` variables for shared tool installation messages instead of defining its own local `*_MESSAGE_*` duplicates.

#### Scenario: Module references CORE_MESSAGE_BREW instead of local MESSAGE_BREW

- **WHEN** a module's `internal/base.zsh` or `pkg/base.zsh` needs a brew installation warning
- **THEN** it SHALL use `$CORE_MESSAGE_BREW` instead of a locally defined `*_MESSAGE_BREW`

#### Scenario: No duplicate *_MESSAGE_BREW in module configs

- **WHEN** scanning all `zsh/modules/*/config/base.zsh` files
- **THEN** none SHALL define `*_MESSAGE_BREW`, `*_MESSAGE_RVM`, `*_MESSAGE_CARGO`, `*_MESSAGE_PYENV`, or `*_MESSAGE_YAY`

### Requirement: Module-specific messages preserved

Modules SHALL retain their own `*_MESSAGE_*` variables for messages that are unique to that module and have no shared equivalent.

#### Scenario: Module-specific NOT_IMPLEMENTED is preserved

- **WHEN** `zsh/modules/clean/config/base.zsh` is sourced
- **THEN** `CLEAN_MESSAGE_NOT_IMPLEMENTED` SHALL remain defined

#### Scenario: Module-specific NOT_FOUND is preserved

- **WHEN** `zsh/modules/fnm/config/base.zsh` is sourced
- **THEN** `FNM_MESSAGE_NOT_FOUND` SHALL remain defined

#### Scenario: Module-specific MESSAGE_CORE is preserved

- **WHEN** `zsh/modules/fnm/config/base.zsh` is sourced
- **THEN** `FNM_MESSAGE_CORE` SHALL remain defined