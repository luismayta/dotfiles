## Why

Currently, core functionality is split across two locations: `zsh/core/` (legacy flat config layer with basic env vars, path management, and zsh settings) and `zsh/modules/core/` (modern modular rewrite with namespaced APIs, package management, and utility helpers). This split creates confusion about where to add new core functionality, duplicates loader chains, and makes the codebase harder to maintain. Consolidating into a single `zsh/core/` eliminates the ambiguity and establishes a single source of truth for all core dotfiles functionality.

## What Changes

- **Move** all files from `zsh/modules/core/` into `zsh/core/`, integrating with the existing structure
- **Merge** the `plugin.zsh` entry point into `zsh/core/main.zsh` with an idempotency guard
- **Adopt** the 3-layer architecture (config/ → internal/ → pkg/) into `zsh/core/`
- **BREAKING**: `zsh/modules/core/` will be removed — any references to `CORE_PATH` or sourcing `modules/core/plugin.zsh` must be updated
- **BREAKING**: Public API functions (`core::install`, `core::load`, `core::exists`, etc.) move from `zsh/modules/core/pkg/` to `zsh/core/pkg/`
- **Drop** the `modules/` wrapper — `zsh/core/` becomes a self-contained directory sourced directly from `.zshrc`

## Capabilities

### New Capabilities

- `core-api`: Public API layer providing `core::install`, `core::load`, `core::exists`, `core::cargo::install`, `core::gem::install`, `core::npm::install`, `core::pip::install` — ports from `modules/core/pkg/base.zsh` and `internal/base.zsh`
- `core-aliases`: System aliases and eza integration — `ls`/`ll`/`lsa` via eza, plus `df`, `free`, `gurl`, `week`, `whois` aliases — ported from `modules/core/pkg/alias.zsh`
- `core-backup`: Project backup system — git-aware snapshots of projects to `CORE_PROJECTS_BACKUP_PATH` — ported from `modules/core/internal/backup.zsh`, `internal/git.zsh`, `pkg/helper/backup.zsh`
- `core-docker`: Docker CLI wrapper utilities — `awscli()`, `aws-shell()`, `dns()`, `docker-ssh()`, `whatsmydns()` — ported from `modules/core/pkg/docker.zsh`
- `core-helpers`: System tool auto-installation and FZF integration — installs axel, ripgrep, fzf, jq, bat, coreutils, the\_silver\_searcher; configures FZF keybindings; sets up `cat→bat` and `man→batman` wrappers — ported from `modules/core/pkg/helper/core.zsh`

### Modified Capabilities

- `shared-config`: The config layer gains `CORE_MESSAGE_*` variables, `CORE_PROJECTS_BACKUP_PATH`, and Android SDK paths from `modules/core/config/base.zsh`
- `shared-utils`: Gains `core::git::get_module_path()` and `core::backup::snapshot()` as new utility functions
- `shared-paths`: No requirement changes — path logic remains the same

## Impact

- **Directory**: `zsh/modules/core/` deleted after migration; `zsh/core/` expanded with `pkg/` subdirectory and new files
- **Loader**: `zsh/core/main.zsh` updated to source config/ → internal/ → pkg/ in sequence; `plugin.zsh` pattern absorbed directly
- **References**: Any `.zshrc` or module that sources `zsh/modules/core/plugin.zsh` must be updated to `zsh/core/main.zsh`
- **No external API changes**: All `core::*` public functions keep the same signatures; consumers are unaffected
- **Existing `zsh/core/` files** (autosuggest.zsh, git.zsh, history.zsh, language.zsh, paths.zsh, editor.zsh, path.zsh, reload.zsh) preserved and remain in place