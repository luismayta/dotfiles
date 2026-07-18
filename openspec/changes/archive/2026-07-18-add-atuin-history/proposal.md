## Why

Shell history is currently limited to per-machine, unencrypted, non-searchable logs. Atuin replaces the default shell history with end-to-end encrypted sync across machines, fuzzy search by text/directory/exit code/duration, and an AI assistant — all while being self-hostable. Adding it to the devops module standardizes history management alongside other DevOps tooling.

## What Changes

- Add Atuin as a new tool in the devops module following the three-layer convention (config → internal → pkg)
- Install Atuin via the official installer (`https://setup.atuin.sh`)
- Configure shell integration (`atuin init zsh`) with sensible defaults
- Add Atuin to the `DEVOPS_TOOLS` array for lifecycle management (install/upgrade)
- Provide optional aliases for common Atuin operations (search, history, status)
- Add Atuin data directory configuration for sync settings

## Capabilities

### New Capabilities
- `devops-atuin`: Core Atuin integration — installation, shell init, lifecycle management (install/upgrade/post_install), and configuration within the devops module

### Modified Capabilities
- `devops`: Add Atuin to the `DEVOPS_TOOLS` array and module documentation

## Impact

- **Files modified**: `config/base.zsh` (DEVOPS_TOOLS + env vars), `internal/main.zsh` (source new file), `pkg/main.zsh` (source new file)
- **Files created**: `config/atuin.zsh`, `internal/atuin.zsh`, `pkg/atuin.zsh`
- **Dependencies**: Atuin binary installed via official installer; requires network access for initial install and sync
- **Existing behavior**: No breaking changes — Atuin is additive. Users who don't want sync can skip `atuin login` and use local-only mode.
