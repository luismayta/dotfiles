## Why

GitHub CLI (`gh`) and `gh-dash` are currently bundled inside the `devops` module with `DEVOPS_GH_*` prefixed variables and `devops::gh::*` namespaced functions. This creates tight coupling — any change to GitHub CLI configuration requires touching the devops module, and the naming doesn't follow the project's module architecture conventions (`ZSH_<MODULE>_` prefix, 3-layer plugin.zsh structure).

Extracting GitHub CLI into its own standalone `github` module:
- Follows the established module creation guide (`docs/guides/create-module.md`)
- Enables independent lifecycle management (install, upgrade, sync)
- Cleans up the devops module's scope
- Aligns naming with the `ZSH_<MODULE>_` convention

## What Changes

- **New**: `zsh/modules/github/` module with full 3-layer architecture (config → internal → pkg)
- **New**: `plugin.zsh` entry point with `ZSH_GITHUB_ENABLED` toggle and guard variable
- **Move**: `devops/config/gh.zsh` → `github/config/gh.zsh` (with `ZSH_GITHUB_*` vars)
- **Move**: `devops/internal/gh.zsh` → `github/internal/gh.zsh` (with `github::internal::*` functions)
- **Move**: `devops/pkg/gh.zsh` → `github/pkg/gh.zsh` (with `github::*` functions and aliases)
- **Move**: `devops/data/gh/` → `github/data/gh/`
- **Remove**: GH-related source lines from devops main.zsh files (config, internal, pkg)
- **Remove**: `github-cli` entry from `DEVOPS_TOOLS` array in `devops/config/base.zsh`
- **BREAKING**: All `DEVOPS_GH_*` variables renamed to `ZSH_GITHUB_*`
- **BREAKING**: All `devops::gh::*` functions renamed to `github::*` / `github::internal::*`

## Capabilities

### New Capabilities

- `github`: GitHub CLI (`gh`) and `gh-dash` integration — configuration, installation, completions, extensions, aliases, and data management

### Modified Capabilities

- `devops`: Removal of GitHub CLI tooling from the devops module scope

## Impact

- **Affected files**:
  - `zsh/modules/devops/config/gh.zsh` — REMOVED (moved to github module)
  - `zsh/modules/devops/internal/gh.zsh` — REMOVED (moved to github module)
  - `zsh/modules/devops/pkg/gh.zsh` — REMOVED (moved to github module)
  - `zsh/modules/devops/data/gh/` — REMOVED (moved to github module)
  - `zsh/modules/devops/config/main.zsh` — Remove `source gh.zsh` line
  - `zsh/modules/devops/internal/main.zsh` — Remove `source gh.zsh` line
  - `zsh/modules/devops/pkg/main.zsh` — Remove `source gh.zsh` line
  - `zsh/modules/devops/config/base.zsh` — Remove `github-cli` from `DEVOPS_TOOLS`
  - `zsh/modules/github/plugin.zsh` — NEW entry point
  - `zsh/modules/github/config/gh.zsh` — NEW config with `ZSH_GITHUB_*` vars
  - `zsh/modules/github/internal/gh.zsh` — NEW internal functions
  - `zsh/modules/github/pkg/gh.zsh` — NEW public functions + aliases
  - `zsh/modules/github/data/gh/config.yaml` — NEW gh-dash config
- **Dependencies**: None (standalone extraction)
- **Breaking changes**: Variable and function naming conventions change
