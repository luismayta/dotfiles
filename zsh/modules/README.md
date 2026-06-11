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