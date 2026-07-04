## 1. Scaffold Module Directory Structure

- [ ] 1.1 Create `zsh/modules/hammerspoon/` with subdirectories: config, internal, pkg, data
- [ ] 1.2 Copy Hammerspoon config files from `~/.hammerspoon/` to `zsh/modules/hammerspoon/data/`

## 2. Create Entry Point and Config Layer

- [ ] 2.1 Create `zsh/modules/hammerspoon/plugin.zsh` — idempotent guard, dynamic path, 3-layer chain
- [ ] 2.2 Create `zsh/modules/hammerspoon/config/base.zsh` — env vars: HAMMERSPOON_PACKAGE_NAME, HAMMERSPOON_CONFIG_PATH, HAMMERSPOON_INSTALL_URL, ZSH_HAMMERSPOON_ENABLED
- [ ] 2.3 Create `zsh/modules/hammerspoon/config/main.zsh` — sources base.zsh + OS dispatch
- [ ] 2.4 Create `zsh/modules/hammerspoon/config/osx.zsh` — macOS-specific config stub
- [ ] 2.5 Create `zsh/modules/hammerspoon/config/linux.zsh` — Linux: set ZSH_HAMMERSPOON_ENABLED=false since Hammerspoon is macOS-only

## 3. Create Internal Layer

- [ ] 3.1 Create `zsh/modules/hammerspoon/internal/base.zsh` — `hammerspoon::internal::install` (brew install --cask) + `hammerspoon::internal::config::sync` (rsync data/ to ~/.hammerspoon/)
- [ ] 3.2 Create `zsh/modules/hammerspoon/internal/main.zsh` — sources base.zsh + OS dispatch, `core::ensure curl && core::ensure brew`, auto-install
- [ ] 3.3 Create `zsh/modules/hammerspoon/internal/osx.zsh` — macOS internal stub
- [ ] 3.4 Create `zsh/modules/hammerspoon/internal/linux.zsh` — Linux internal stub

## 4. Create Public Layer

- [ ] 4.1 Create `zsh/modules/hammerspoon/pkg/base.zsh` — `hammerspoon::install`, `hammerspoon::sync`, `hammerspoon::post_install`
- [ ] 4.2 Create `zsh/modules/hammerspoon/pkg/helper.zsh` — placeholder (setup moved to setup.zsh)
- [ ] 4.3 Create `zsh/modules/hammerspoon/pkg/setup.zsh` — `hammerspoon::setup` orchestrator (install if missing, sync, report)
- [ ] 4.4 Create `zsh/modules/hammerspoon/pkg/alias.zsh` — user aliases (empty placeholder)
- [ ] 4.5 Create `zsh/modules/hammerspoon/pkg/main.zsh` — sources all pkg files + OS dispatch
- [ ] 4.6 Create `zsh/modules/hammerspoon/pkg/osx.zsh` — macOS public stub
- [ ] 4.7 Create `zsh/modules/hammerspoon/pkg/linux.zsh` — Linux public stub

## 5. Verify Module

- [ ] 5.1 Load module: `source zsh/core/main.zsh && source zsh/modules/hammerspoon/plugin.zsh` — verify loading message appears
- [ ] 5.2 Verify guard: source twice — second is no-op
- [ ] 5.3 Verify public API: `type hammerspoon::install`, `type hammerspoon::setup`, `type hammerspoon::sync` all return "function"
