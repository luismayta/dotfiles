## MODIFIED Requirements

### Requirement: Centralized tool installation messages

The system SHALL define centralized message variables for common tool installation instructions in `zsh/core/config/env.zsh`. These variables SHALL be prefixed with `CORE_MESSAGE_` and SHALL reference `core::install` or internal monorepo module paths instead of external antibody bundles.

#### Scenario: CORE_MESSAGE_BREW is defined

- **WHEN** `zsh/core/config/env.zsh` is sourced
- **THEN** `CORE_MESSAGE_BREW` SHALL be set to a string that references `core::install` instead of a module path, since `zsh/modules/brew` no longer exists