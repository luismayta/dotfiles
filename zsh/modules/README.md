# Modules

Each subdirectory is a self-contained ZSH module with a `plugin.zsh` entry point.

```
modules/
├── zsh-brew/
│   └── plugin.zsh
├── zsh-rust/
│   └── plugin.zsh
└── example/
    └── plugin.zsh
```

## Convention

- Module name matches its directory name (kebab-case)
- Entry point is always `plugin.zsh`
- Modules load in alphabetical order after `mod/main.zsh`
- A module can be extracted to its own repo later and loaded via `zsh_plugins.txt`

## Creating a module

```zsh
mkdir -p zsh/modules/my-module
touch zsh/modules/my-module/plugin.zsh
```

The module is automatically sourced on next shell start.

## Disabling a module

To skip a module without removing it, set `ZSH_DISABLED_MODULES` in `~/.customrc`:

```zsh
# Disable a single module
export ZSH_DISABLED_MODULES="tmux"

# Disable multiple modules (space separated)
export ZSH_DISABLED_MODULES="tmux starship"

# Also supports comma-separated values
export ZSH_DISABLED_MODULES="tmux,starship"
```

The variable is read before the module loading loop. Modules not listed continue to load normally.

## Platform filtering

Each module can declare its platform compatibility via `ZSH_<MODULE>_ENABLED` in its `config/base.zsh`:

```zsh
# Default: enabled on all platforms (override via ~/.customrc)
ZSH_HYPRLAND_ENABLED="${ZSH_HYPRLAND_ENABLED:-true}"
```

Platform-specific configs (`config/osx.zsh` / `config/linux.zsh`) can override to `false` when a module doesn't apply:

```zsh
# zsh/modules/hyprland/config/osx.zsh
ZSH_HYPRLAND_ENABLED=false
```

The guard in `plugin.zsh` (`$ZSH_<MODULE>_ENABLED || return`) prevents loading when disabled.

### Override from customrc

```zsh
# ~/.customrc — force-enable a Linux-only module on macOS
export ZSH_HYPRLAND_ENABLED=true

# Or disable any module despite its platform declaration
export ZSH_GIT_ENABLED=false
```

The variable uses `${ZSH_<MODULE>_ENABLED:-true}` so a pre-exported value in `~/.customrc` takes precedence over the default.