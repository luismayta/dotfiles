## Why

As a CodipLabs developer, I need a ZSH module to manage the Helix editor in my dotfiles, following the three-layer architecture (config/internal/pkg) documented in `docs/guides/create-module.md` and mirroring the existing `zsh/modules/nvim/` module. Unlike Neovim, Helix has no plugin manager, so the module focuses on binary installation, config sync, and runtime grammar management.

## What Changes

- Scaffold a complete `zsh/modules/helix/` module with `config/`, `internal/`, `pkg/`, and `data/` layers.
- `plugin.zsh` entry point with idempotent guard `__ZSH_HELIX_LOADED` and the `config → internal → pkg` source chain.
- `config/base.zsh` exports `ZSH_HELIX_ENABLED`, `ZSH_HELIX_PACKAGE_NAME`, `ZSH_HELIX_CONFIG_PATH`, `ZSH_HELIX_DATA_PATH`.
- `internal/base.zsh` implements `helix::internal::install` and `helix::internal::sync` (rsync `data/` → `~/.config/helix/`).
- `pkg/base.zsh` exposes public API `helix::install`, `helix::sync`, `helix::post_install`; `pkg/helper.zsh` implements `helix::setup`.
- `data/` contains real Helix configuration: `config.toml`, `languages.toml`, and `themes/`.
- `README.yaml` + `Taskfile.yml` with a `readme` task, registered in the root `Taskfile.yml` as `module-helix`.
- Reuses `message_*`, `core::exists`, `core::ensure` from `zsh/system/core/` (no `echo`, no `which`, no `command -v`).

## Capabilities

### New Capabilities
- `helix-module`: ZSH module that installs the Helix binary (`hx`), syncs `config.toml` + `languages.toml` + `themes/` from `data/` to `~/.config/helix/`, manages the runtime (`hx --grammar fetch/build`), and exposes public commands (`helix::install`, `helix::sync`, `helix::setup`, `helix::post_install`) following `ZSH_HELIX_` naming conventions and core function reuse.

### Modified Capabilities
<!-- No existing spec-level behavior changes. -->

## Impact

- **New files:** `zsh/modules/helix/` (plugin.zsh, config/, internal/, pkg/, data/, README.yaml, Taskfile.yml).
- **Modified files:** root `Taskfile.yml` (register `module-helix` task and add to readme task list).
- **Reference:** `zsh/modules/nvim/` module and `docs/guides/create-module.md`.
- **Dependencies:** `zsh/system/core/` (message_*, core::exists, core::ensure), `rsync`, `hx` binary.
- **Config target:** `~/.config/helix/`.
