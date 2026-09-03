## Context

This change scaffolds a new `zsh/modules/helix/` module following the three-layer architecture (config/internal/pkg) documented in `docs/guides/create-module.md` and mirroring the existing `zsh/modules/nvim/` module. See proposal.md - Why for motivation.

Key constraint: unlike Neovim (which uses lazy.nvim), **Helix has no plugin manager**. The module therefore focuses on three concerns: installing the `hx` binary, syncing configuration (`config.toml`, `languages.toml`, `themes/`) from `data/` to `~/.config/helix/`, and managing the Helix runtime (`hx --grammar fetch/build`).

The module reuses `zsh/system/core/` primitives (`message_*`, `core::exists`, `core::ensure`) — no `echo`, `which`, or `command -v`.

## Goals / Non-Goals

**Goals:**
- Full module scaffold in `zsh/modules/helix/` with `config/`, `internal/`, `pkg/`, `data/`.
- Idempotent `plugin.zsh` entry point with `__ZSH_HELIX_LOADED` guard and `config → internal → pkg` chain.
- Public API: `helix::install`, `helix::sync`, `helix::post_install`, `helix::setup`.
- Real Helix config in `data/` (config.toml, languages.toml, themes/).
- README.yaml + Taskfile.yml with `readme` task, registered in root Taskfile.yml as `module-helix`.

**Non-Goals:**
- No plugin manager integration (Helix has none).
- No alias layer (nvim has `vim → nvim`; Helix has no equivalent convenience alias required by acceptance tests).
- No backup/clean/upgrade functions (not required by RD-151 acceptance tests; nvim's are plugin-specific).

## Decisions

### 1. Install via `core::ensure` / `core::install`
`helix::internal::install` uses `core::ensure hx` (which internally calls `core::exists` + `core::install` per-platform via `zsh/system/core/internal/{linux,osx}.zsh`). This keeps install mechanism consistent with the rest of the dotfiles and avoids reimplementing package-manager logic.
- **Alternative considered:** direct `brew`/`paru` calls — rejected, violates core-reuse rules.

### 2. Sync via rsync from `data/` to `~/.config/helix/`
`helix::internal::sync` runs `mkdir -p "${ZSH_HELIX_CONFIG_PATH}"` then `rsync -avzh --progress --delete "${ZSH_HELIX_DATA_PATH}/" "${ZSH_HELIX_CONFIG_PATH}/"`. Mirrors `nvim::internal::sync` but without plugin-specific excludes (no lazy/node_modules).
- **Alternative considered:** symlink `~/.config/helix` → `data/` — rejected; the dotfiles convention is rsync copy, and symlinks complicate the `data/`-as-source-of-truth model.

### 3. Runtime management via `hx --grammar fetch/build`
`helix::post_install` runs `hx --grammar fetch` then `hx --grammar build` to fetch and compile language grammars. This is Helix's equivalent of Neovim's plugin sync.
- **Alternative considered:** skipping grammar management — rejected; grammars are required for language support and are a core part of Helix setup.

### 4. `helix::setup` orchestrates install + sync
`pkg/helper.zsh` implements `helix::setup` as the high-level entry that calls `helix::install` then `helix::sync`. This mirrors the nvim helper pattern and gives users a single command to bootstrap the editor.

### 5. OS-specific placeholder files
Empty `osx.zsh`/`linux.zsh` placeholders in all three layers (config/internal/pkg), per the create-module guide, wired for future platform-specific overrides.

## Risks / Trade-offs

- **Grammar build time** → `hx --grammar build` can be slow on first run; mitigated by running it only in `post_install`/`setup`, not on every load.
- **rsync `--delete`** could remove user-local Helix files not in `data/` → acceptable trade-off matching nvim convention; `data/` is the source of truth.
- **Install mechanism varies by platform** → delegated to `core::install` which already handles Arch/macOS; no new platform logic needed.
