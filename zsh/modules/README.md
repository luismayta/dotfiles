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