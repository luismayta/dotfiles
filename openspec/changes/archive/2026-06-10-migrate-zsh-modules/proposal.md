## Why

Four ZSH modules currently live as standalone repos outside this dotfiles repository, creating fragmentation in module management, versioning, and maintenance. Migrating them into `zsh/modules/` centralizes configuration, simplifies updates, and aligns with the existing module architecture already established for brew, core, fnm, git, and others.

## What Changes

- Migrate `zsh-aliases` external repo into `zsh/modules/aliases/`
- Migrate `zsh-clean` external repo into `zsh/modules/clean/`
- Migrate `zsh-pazi` external repo into `zsh/modules/pazi/`
- Migrate `zsh-devops` external repo into `zsh/modules/devops/`
- Each module follows the existing convention: `plugin.zsh` entry point with `config/`, `internal/`, `pkg/` subdirectories
- Source repositories will be preserved (not deleted) — this is a copy/migration, not a replacement

## Capabilities

### New Capabilities

- `aliases`: ZSH aliases module migrated from `zsh-aliases` — provides alias management for base, docker, editor, eza, and platform-specific commands
- `clean`: ZSH clean module migrated from `zsh-clean` — provides cleanup and housekeeping utilities for terminal sessions
- `pazi`: ZSH directory jumper module migrated from `zsh-pazi` — provides fast directory navigation via fuzzy matching
- `devops`: ZSH devops module migrated from `zsh-devops` — provides DevOps tooling aliases and helpers for infrastructure workflows

### Modified Capabilities

None — no existing capabilities are changing.

## Impact

- **Files added**: ~80 ZSH files across 4 new module directories under `zsh/modules/`
- **No existing code modified**: new directories only — no breaking changes to existing modules
- **Loading mechanism**: each new module gets a `plugin.zsh` entry point, auto-sourced on shell start per the existing convention
- **External repos**: remain untouched at their original locations
