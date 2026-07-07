## 1. Scaffold Module Structure

- [x] 1.1 Create directory tree: `zsh/modules/yazi/{config,internal,pkg,data}`
- [x] 1.2 Create `plugin.zsh` — idempotent guard, path resolution, 3-layer chain

## 2. Config Layer

- [x] 2.1 Create `config/base.zsh` — env vars with defaults (PACKAGE_NAME, INSTALL_URL, CONFIG_PATH, DATA_PATH, ENABLED)
- [x] 2.2 Create `config/main.zsh` — sources base.zsh + OS dispatch
- [x] 2.3 Create `config/osx.zsh` — macOS clipboard commands (pbcopy/pbpaste)
- [x] 2.4 Create `config/linux.zsh` — Linux clipboard commands (xclip/wl-clipboard)

## 3. Internal Layer

- [x] 3.1 Create `internal/base.zsh` — `yazi::internal::install` (pacman on Arch, cargo otherwise) and `yazi::internal::config::sync`
- [x] 3.2 Create `internal/main.zsh` — sources base.zsh + OS dispatch + core::ensure curl + auto-install
- [x] 3.3 Create `internal/osx.zsh` — macOS-specific internal helpers (ensure clipboard)
- [x] 3.4 Create `internal/linux.zsh` — Linux-specific internal helpers (ensure xclip/wl-clipboard)

## 4. Public Layer

- [x] 4.1 Create `pkg/base.zsh` — `yazi::install`, `yazi::sync`, `yazi::post_install`
- [x] 4.2 Create `pkg/helper.zsh` — `yazi::setup` orchestrator and `y()` wrapper function
- [x] 4.3 Create `pkg/alias.zsh` — user-facing aliases
- [x] 4.4 Create `pkg/main.zsh` — sources base.zsh + helper.zsh + alias.zsh + OS dispatch
- [x] 4.5 Create `pkg/osx.zsh` — macOS-specific public functions (empty placeholder)
- [x] 4.6 Create `pkg/linux.zsh` — Linux-specific public functions (empty placeholder)

## 5. Cleanup Cross-module References

- [x] 5.1 Remove `yazi` from `DEVOPS_TOOLS` array in `zsh/modules/devops/config/base.zsh`
- [x] 5.2 Remove `"yazi-fm yazi-cli"` from `RUST_CARGO_PACKAGES_LOCKED` in `zsh/modules/rust/config/base.zsh`

## 6. Data & Verification

- [x] 6.1 Create `data/` directory with a `.gitkeep` placeholder
- [x] 6.2 Verify module loads without errors: `source zsh/core/main.zsh && source zsh/modules/yazi/plugin.zsh`
- [x] 6.3 Verify guard prevents double-loading
- [x] 6.4 Verify public functions exist: `type yazi::install`, `type yazi::setup`, `type yazi::sync`
- [x] 6.5 Run `lsp_diagnostics` on all module files to check for shellcheck issues (no LSP for .zsh, verified via functional test)
