## Why

AI coding agents need a dedicated terminal multiplexer that survives disconnection and provides agent-aware state visibility. **herdr** is a Rust-based terminal multiplexer built specifically for AI agents — it's already on the user's radar and complements the existing tmux setup. Adding a zsh module for herdr provides auto-install, config sync, and the same ergonomic setup experience as the existing `tmux` module, keeping the dotfiles consistent and self-contained.

## What Changes

- Create `zsh/modules/herdr/` with the standard 3-layer architecture (`config/`, `internal/`, `pkg/`, `data/`)
- Add `plugin.zsh` entry point with idempotent guard, auto-install, and setup orchestration
- Implement `herdr::install` via the official install script (`curl -fsSL https://herdr.dev/install.sh | sh`)
- Implement `herdr::sync` to rsync config from `data/` to `$HOME/.config/herdr/`
- Implement `herdr::setup` orchestrator (compose install + sync)
- Add Brew-based install path as fallback (`brew install herdr`)
- Include OS-specific stubs for `linux.zsh` and `osx.zsh` in all three layers
- Populate `data/` directory with herdr config from `~/Projects/src/github.com/Sin-cy/dotfiles/herdr/.config/herdr/`

## Capabilities

### New Capabilities
- `herdr-install`: Auto-install herdr binary via official script or Homebrew, with core::ensure dependency management
- `herdr-sync`: Synchronize herdr configuration from module data to user config directory
- `herdr-setup`: Orchestrated setup composing install + config sync, exposed as user-callable command

### Modified Capabilities

No existing capabilities are modified — this is a new module.

## Impact

- **New files only**: `zsh/modules/herdr/` — no existing files changed
- **No breaking changes**: Module is opt-in via `ZSH_HERDR_ENABLED` (defaults to true when sourced)
- **Dependencies**: Requires `curl` (auto-ensured via `core::ensure`), optional `brew` on macOS for fallback install
- **Alignment**: Follows the exact same architecture as `zsh/modules/tmux/` and `zsh/modules/zed/`
