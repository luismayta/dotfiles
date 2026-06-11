## ADDED Requirements

### Requirement: User can disable specific modules via ZSH_DISABLED_MODULES

The system SHALL skip loading a module's `plugin.zsh` when its directory basename is listed in the `ZSH_DISABLED_MODULES` environment variable. Users SHOULD set this variable in `~/.customrc` (or `${CUSTOMRC}`).

#### Scenario: Disable a single module

- **WHEN** `ZSH_DISABLED_MODULES="tmux"` is set in the environment before sourcing zshrc
- **THEN** the module at `zsh/modules/tmux/` SHALL be skipped during the module loading loop

#### Scenario: Disable multiple modules

- **WHEN** `ZSH_DISABLED_MODULES="tmux starship"` is set in the environment
- **THEN** both the `tmux` and `starship` modules SHALL be skipped during the module loading loop

#### Scenario: Unset variable loads all modules

- **WHEN** `ZSH_DISABLED_MODULES` is unset or empty
- **THEN** all modules SHALL be loaded as before (existing behavior preserved)

#### Scenario: Disabled module skipped silently

- **WHEN** a disabled module directory is encountered in the loading loop
- **THEN** the loop SHALL continue to the next module without producing any diagnostic output

#### Scenario: Variable supports comma and space delimiters

- **WHEN** `ZSH_DISABLED_MODULES="tmux,starship"` is set
- **THEN** both `tmux` and `starship` SHALL be recognized as disabled

### Requirement: The disable mechanism is documented

#### Scenario: README reference

- **WHEN** a user reads `zsh/modules/README.md`
- **THEN** they SHALL find documentation of the `ZSH_DISABLED_MODULES` mechanism

#### Scenario: Inline comment in zshrc

- **WHEN** a user reads the module loading loop in `zsh/.zshrc`
- **THEN** an inline comment SHALL explain how to disable modules

#### Scenario: .customrc auto-created from example on first load

- **WHEN** `~/.customrc` does not exist and zshrc is sourced
- **THEN** the file SHALL be created by copying `.customrc.example` from `DOTFILES_DIR`

#### Scenario: .customrc example template

- **WHEN** a user reads `.customrc.example` in the repo root
- **THEN** they SHALL find commented-out `ZSH_DISABLED_MODULES` examples covering single, multiple, and comma-separated formats