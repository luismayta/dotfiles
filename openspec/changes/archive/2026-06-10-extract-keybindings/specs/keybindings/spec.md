## ADDED Requirements

### Requirement: Module-keybinding file per module

Each zsh module with ZLE widgets SHALL have a `keybindings.zsh` file at the module root directory containing all `zle -N` and `bindkey` calls for that module.

#### Scenario: Keybinding file exists per module
- **WHEN** a module registers ZLE widgets
- **THEN** it SHALL have a `keybindings.zsh` file at `zsh/modules/<name>/keybindings.zsh`

#### Scenario: No keybinding file for modules without widgets
- **WHEN** a module has no ZLE widgets
- **THEN** it SHALL NOT have a `keybindings.zsh` file

### Requirement: Keybinding file sourced from plugin.zsh

The `keybindings.zsh` file SHALL be sourced from `plugin.zsh` AFTER the `pkg/main.zsh` source line, ensuring all widget functions are defined before registration.

#### Scenario: Sourcing order in plugin.zsh
- **WHEN** `plugin.zsh` loads
- **THEN** `keybindings.zsh` SHALL be sourced after `pkg/main.zsh`
- **AND** `zle -N` and `bindkey` SHALL execute only after all module functions are available

### Requirement: No bindkey outside keybindings.zsh

Modules with a `keybindings.zsh` file SHALL NOT contain `bindkey` or `zle -N` calls in any other file.

#### Scenario: Bindkey removed from plugin.zsh
- **WHEN** a module has a `keybindings.zsh` file
- **THEN** its `plugin.zsh` SHALL NOT contain `bindkey` or `zle -N` calls

#### Scenario: Bindkey removed from pkg/base.zsh
- **WHEN** a module has a `keybindings.zsh` file
- **THEN** its `pkg/base.zsh` SHALL NOT contain `bindkey` or `zle -N` calls

### Requirement: Registration pattern

Each `keybindings.zsh` SHALL use `zle -N` + `bindkey` per widget with a `# shellcheck shell=bash` header.

#### Scenario: Standard pattern
- **WHEN** a `keybindings.zsh` file is created
- **THEN** it SHALL use `zle -N` followed by `bindkey` for each widget
- **AND** it SHALL include `# shellcheck shell=bash` header