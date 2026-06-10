## ADDED Requirements

### Requirement: History configuration
The shared config layer SHALL export ZSH history environment variables in `zsh/core/config/history.zsh`.

#### Scenario: History vars are exported
- **WHEN** `zsh/core/config/history.zsh` is sourced
- **THEN** `HISTFILE` SHALL be set to `${HOME}/.zsh_history`
- **THEN** `HISTSIZE` SHALL be set to `5000`
- **THEN** `SAVEHIST` SHALL be set to `5000`

### Requirement: Language configuration
The shared config layer SHALL export locale environment variables in `zsh/core/config/language.zsh`.

#### Scenario: Locale vars are exported
- **WHEN** `zsh/core/config/language.zsh` is sourced
- **THEN** `LANG` SHALL be set to `en_US.UTF-8`
- **THEN** `LC_ALL` SHALL be set to `en_US.UTF-8`

### Requirement: Autosuggest configuration
The shared config layer SHALL export ZSH autosuggest plugin configuration in `zsh/core/config/autosuggest.zsh`.

#### Scenario: Autosuggest vars are exported
- **WHEN** `zsh/core/config/autosuggest.zsh` is sourced
- **THEN** `ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE` SHALL be set to `15`
- **THEN** `ZSH_AUTOSUGGEST_USE_ASYNC` SHALL be set to `true`

### Requirement: Git configuration
The shared config layer SHALL export Git-related environment variables in `zsh/core/config/git.zsh`.

#### Scenario: Git internal var is exported
- **WHEN** `zsh/core/config/git.zsh` is sourced
- **THEN** `GIT_INTERNAL_GETTEXT_TEST_FALLBACKS` SHALL be set to `1`
