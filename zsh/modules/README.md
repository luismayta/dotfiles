# Modules

Each subdirectory is a self-contained ZSH module with a `plugin.zsh` entry point.

```
modules/
├── devbox/
│   └── plugin.zsh
├── devops/
│   └── plugin.zsh
└── git/
    └── plugin.zsh
```

## Convention

- Module name matches its directory name (kebab-case)
- Entry point is always `plugin.zsh`
- Modules load in alphabetical order, glob-sourced by the module loop in `zsh/zshrc` (`zsh/zshrc:56-66`), after the `zsh/system/*` loop (`zsh/zshrc:27-40`) and after `$CUSTOMRC` is sourced (`zsh/zshrc:43-49`)
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

### Default-disabled module: devbox

The `devbox` module is disabled by default (`config/base.zsh` sets
`ZSH_DEVBOX_ENABLED="${ZSH_DEVBOX_ENABLED:-false}"` — nix already owns
installs and project environments). To restore it on a host, opt in from
`~/.customrc` before the module loop runs:

```zsh
# ~/.customrc — re-enable devbox for this host
export ZSH_DEVBOX_ENABLED=true
```

Alternatively, skip it explicitly through the disabled-modules list:

```zsh
export ZSH_DISABLED_MODULES="devbox"
```

## Lifecycle policy (ARCHIVE / DISABLE / KEEP)

Every directory under `zsh/modules/` is classified as ARCHIVE, DISABLE, or KEEP
by criteria C1–C6 (nix/mise redundancy, duplicate shell integration,
cross-boundary shared helpers, platform scope, interactive value, startup
cost & reversibility). The authoritative record — full criteria definitions,
precedence rules, and the 40-module decision matrix — is the transversal ADR
[`docs/adr/001-zsh-module-lifecycle-classification.md`](../../docs/adr/001-zsh-module-lifecycle-classification.md).

Rules of the policy:

- Non-KEEP decisions use only the existing mechanisms: the
  `ZSH_<MODULE>_ENABLED` guard in `config/base.zsh` and the
  `ZSH_DISABLED_MODULES` list. The `zsh/zshrc` loader has no exclusion branch
  or central blacklist.
- A cross-boundary reference (C3) blocks ARCHIVE until the dependency is
  migrated; `rvm` is the only ARCHIVE decision and its removal is deferred to
  the dedicated follow-up change `archive-redundant-zsh-modules`.
- Currently default-disabled: `tmux` (pre-existing) and `devbox` (this
  policy). Both are reversible per fresh shell via
  `export ZSH_<MODULE>_ENABLED=true` in `$CUSTOMRC` or `ZSH_DISABLED_MODULES`.
- Platform-scoped disables live only in `config/osx.zsh` / `config/linux.zsh`
  over a `:-true` base default; host-scoped disables live only in `$CUSTOMRC`.
- Disabling never suppresses diagnostics: genuine dependency failures still
  emit `message_warning` / `message_error` during startup.

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

The variable uses `${ZSH_<MODULE>_ENABLED:-true}` (or `:-false` for
default-disabled modules such as `tmux` and `devbox`) so a pre-exported value
in `~/.customrc` takes precedence over the default.
