## ADDED Requirements

### Requirement: Module declares enabled state via ZSH_<MODULE>_ENABLED

Each module SHALL declare whether it is enabled using a `ZSH_<MODULE>_ENABLED` variable, where `<MODULE>` is the module name in uppercase with underscores (e.g., `ZSH_HYPRLAND_ENABLED`, `ZSH_GIT_ENABLED`).

The variable SHALL be set in the module's `config/base.zsh` using the pattern:
```zsh
ZSH_HYPRLAND_ENABLED="${ZSH_HYPRLAND_ENABLED:-true}"
```

The `${var:-true}` pattern allows user override from `~/.customrc` — if the user exported the variable before module loading, that value is preserved.

#### Scenario: Module is enabled by default
- **WHEN** `config/base.zsh` sets `ZSH_HYPRLAND_ENABLED="${ZSH_HYPRLAND_ENABLED:-true}"`
- **THEN** the module SHALL load on platforms where no override exists

#### Scenario: User disables module from customrc
- **WHEN** `~/.customrc` contains `export ZSH_HYPRLAND_ENABLED=false`
- **THEN** the module SHALL NOT load on any platform

### Requirement: Platform-specific config can override enabled state

Each module's `config/osx.zsh` or `config/linux.zsh` MAY override `ZSH_<MODULE>_ENABLED` to `false` when the module does not apply to that platform.

The override uses direct assignment (no `${:-}` guard — the platform config is authoritative):
```zsh
# config/osx.zsh
ZSH_HYPRLAND_ENABLED=false
```

#### Scenario: OS-specific file disables module
- **WHEN** current `$OSTYPE` is `darwin*`
- **AND** `config/osx.zsh` sets `ZSH_HYPRLAND_ENABLED=false`
- **THEN** the module SHALL be skipped on macOS

#### Scenario: OS-specific file keeps module enabled
- **WHEN** current `$OSTYPE` is `linux*`
- **AND** `config/linux.zsh` does NOT override `ZSH_HYPRLAND_ENABLED`
- **THEN** the module SHALL load normally (inherits `true` from `base.zsh`)

#### Scenario: Multiple platform overrides
- **WHEN** a module is Linux-only
- **THEN** `config/osx.zsh` SHALL set `ZSH_<MODULE>_ENABLED=false`
- **AND** `config/linux.zsh` SHALL NOT override the variable

### Requirement: Plugin.zsh checks enabled state after config

Each module's `plugin.zsh` SHALL check `ZSH_<MODULE>_ENABLED` after sourcing `config/main.zsh`. If the value is `false`, the plugin SHALL `return` immediately.

The guard SHALL be placed immediately after the config source:
```zsh
source "${MODULE_PATH}/config/main.zsh"
$ZSH_<MODULE>_ENABLED || return
```

#### Scenario: Enabled module loads normally
- **WHEN** `ZSH_HYPRLAND_ENABLED=true`
- **THEN** the guard passes and the module continues loading

#### Scenario: Disabled module returns early
- **WHEN** `ZSH_HYPRLAND_ENABLED=false`
- **THEN** the `|| return` fires and the module stops loading immediately

#### Scenario: Return from sourced file returns to loader
- **WHEN** `$ZSH_HYPRLAND_ENABLED || return` triggers in `plugin.zsh`
- **THEN** control returns to the loader loop in `zsh/zshrc`, which continues with the next module
