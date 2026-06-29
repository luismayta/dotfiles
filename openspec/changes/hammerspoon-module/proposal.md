## Why

Hammerspoon is a core part of the macOS development environment, providing window management, application launchers, workspace profiles, and system automation. Currently, the Hammerspoon configuration lives in `~/.hammerspoon/` as a standalone project, disconnected from the dotfiles ecosystem. This means:

- No auto-install or setup when provisioning a new Mac
- No config sync from dotfiles to the Hammerspoon config directory
- No ZSH-level integration (environment variables, aliases, setup commands)

Creating a `hammerspoon` ZSH module brings this configuration under the dotfiles management umbrella, following the same patterns as other tools (zed, ghostty, wezterm, nvim).

## What Changes

- Create `zsh/modules/hammerspoon/` with the full 3-layer module structure (config, internal, pkg)
- Add `data/` directory with the Hammerspoon config files (init.lua, src/, Spoons/, assets/)
- Auto-install Hammerspoon via Homebrew on macOS (the only supported platform)
- Rsync-based config sync from `data/` → `~/.hammerspoon/`
- Public API: `hammerspoon::install`, `hammerspoon::sync`, `hammerspoon::setup`, `hammerspoon::post_install`
- Module is macOS-only; Linux config stubs exist but the module is disabled on Linux

## Capabilities

### New Capabilities
- `hammerspoon-install`: Auto-detect and install Hammerspoon via Homebrew cask on macOS
- `hammerspoon-config-sync`: Rsync dotfiles-managed config (init.lua, src/, Spoons/, assets/) to `~/.hammerspoon/`
- `hammerspoon-setup`: Full orchestration — install if missing, sync config, post-install hooks

### Modified Capabilities
No existing specs are modified.

## Impact

- New directory: `zsh/modules/hammerspoon/` (~15 files)
- New data directory: `zsh/modules/hammerspoon/data/` containing the Hammerspoon Lua config, Spoons, and assets
- The standalone `~/.hammerspoon/` repo becomes the upstream source; the data/ directory tracks a snapshot for dotfiles sync
- macOS-only (Linux stubs present but no-op)
