## 1. Scaffold Module Structure

- [x] 1.1 Create `zsh/modules/helix/` directory with `config/`, `internal/`, `pkg/`, `data/` subdirectories
- [x] 1.2 Create empty OS placeholder files `osx.zsh`/`linux.zsh` in config/, internal/, and pkg/ layers

## 2. Entry Point

- [x] 2.1 Create `zsh/modules/helix/plugin.zsh` with idempotent guard `__ZSH_HELIX_LOADED`, path resolution via `${${(%):-%x}:A:h}`, and `config → internal → pkg` source chain gated on `ZSH_HELIX_ENABLED`

## 3. Config Layer

- [x] 3.1 Create `zsh/modules/helix/config/base.zsh` exporting `ZSH_HELIX_ENABLED`, `ZSH_HELIX_PACKAGE_NAME`, `ZSH_HELIX_CONFIG_PATH`, `ZSH_HELIX_DATA_PATH` with `: "${VAR:=default}"` defaults
- [x] 3.2 Create `zsh/modules/helix/config/main.zsh` with OS dispatch sourcing base.zsh + osx.zsh/linux.zsh

## 4. Internal Layer

- [x] 4.1 Create `zsh/modules/helix/internal/base.zsh` implementing `helix::internal::install` (via `core::ensure hx`) and `helix::internal::sync` (mkdir + rsync `data/` → `~/.config/helix/`)
- [x] 4.2 Create `zsh/modules/helix/internal/main.zsh` with OS dispatch sourcing base.zsh + osx.zsh/linux.zsh

## 5. Public Layer

- [x] 5.1 Create `zsh/modules/helix/pkg/base.zsh` exposing thin wrappers `helix::install`, `helix::sync`, `helix::post_install` delegating to internal functions
- [x] 5.2 Create `zsh/modules/helix/pkg/helper.zsh` implementing `helix::setup` (orchestrates install + sync)
- [x] 5.3 Create `zsh/modules/helix/pkg/main.zsh` with OS dispatch sourcing base.zsh + helper.zsh + osx.zsh/linux.zsh

## 6. Data Directory

- [x] 6.1 Create `zsh/modules/helix/data/config.toml` with real Helix configuration
- [x] 6.2 Create `zsh/modules/helix/data/languages.toml` with real Helix language configuration
- [x] 6.3 Create `zsh/modules/helix/data/themes/` directory with Helix theme files

## 7. Module Metadata

- [x] 7.1 Create `zsh/modules/helix/README.yaml` with module metadata (name, description, features, requirements)
- [x] 7.2 Create `zsh/modules/helix/Taskfile.yml` with `readme` task (gomplate from README.yaml)
- [x] 7.3 Register `module-helix` in root `Taskfile.yml` and add to the readme task list

## 8. Verification

- [x] 8.1 Verify module loads: `source zsh/system/core/main.zsh && source zsh/modules/helix/plugin.zsh` without errors
- [x] 8.2 Verify guard prevents double-loading (`__ZSH_HELIX_LOADED`)
- [x] 8.3 Verify `type helix::install` and `type helix::setup` respond "function"
- [x] 8.4 Run `openspec validate --change add-helix-module` and confirm it passes
