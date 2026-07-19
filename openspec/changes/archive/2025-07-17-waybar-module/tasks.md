## 1. Module Scaffold

- [x] 1.1 Create waybar module directory structure: `zsh/modules/waybar/{config,internal,pkg,data}`
- [x] 1.2 Create `plugin.zsh` entry point with idempotency guard and 3-layer chain
- [x] 1.3 Create `config/base.zsh` with waybar environment variables (WAYBAR_CONFIG_PATH, ZSH_WAYBAR_DATA_PATH)
- [x] 1.4 Create `config/main.zsh` with base.zsh sourcing and OS dispatch
- [x] 1.5 Create `config/osx.zsh` placeholder
- [x] 1.6 Create `config/linux.zsh` placeholder
- [x] 1.7 Create `internal/base.zsh` with waybar::internal::install and waybar::internal::config::sync functions
- [x] 1.8 Create `internal/main.zsh` with layer sourcing, OS dispatch, core::ensure, and auto-install
- [x] 1.9 Create `internal/osx.zsh` placeholder
- [x] 1.10 Create `internal/linux.zsh` placeholder
- [x] 1.11 Create `pkg/base.zsh` with waybar::install, waybar::sync, waybar::post_install functions
- [x] 1.12 Create `pkg/main.zsh` with layer sourcing, OS dispatch, helper, and alias
- [x] 1.13 Create `pkg/osx.zsh` placeholder
- [x] 1.14 Create `pkg/linux.zsh` placeholder
- [x] 1.15 Create `pkg/helper.zsh` with waybar::setup orchestrator and waybar::check health function
- [x] 1.16 Create `pkg/alias.zsh` placeholder

## 2. Hyprland Module Updates

- [x] 2.1 Remove `core::install waybar` from `zsh/modules/hyprland/internal/base.zsh`
- [x] 2.2 Remove waybar health check from `zsh/modules/hyprland/pkg/helper.zsh`

## 3. Testing

- [x] 3.1 Test module loading: `source zsh/core/main.zsh && source zsh/modules/waybar/plugin.zsh`
- [x] 3.2 Test guard prevents double-loading
- [x] 3.3 Test public functions exist: `type waybar::install`, `type waybar::setup`, `type waybar::check`
- [x] 3.4 Test auto-install triggers when waybar is missing
- [x] 3.5 Test Hyprland module still works without waybar dependency
