## Context

The dotfiles repository manages shell configuration through a modular ZSH plugin system. Each tool (zed, ghostty, nvim, etc.) gets a self-contained module under `zsh/modules/<name>/` with a consistent 3-layer architecture (config → internal → pkg).

The existing `~/.hammerspoon/` directory is a fully featured Hammerspoon configuration with:
- Lua source code organized into config/, core/, domain/, features/, mod/ layers
- 12 Spoons (plugins) for clipboard, window management, WiFi, USB, caffeine, etc.
- Assets (icons for memory, network, notifications)
- An `init.lua` entry point that bootstraps the entire system

Hammerspoon is **macOS-only**. It cannot be installed on Linux. The module must handle this gracefully.

## Goals / Non-Goals

**Goals:**
- Create a `zsh/modules/hammerspoon/` module following the established 3-layer pattern
- Auto-install Hammerspoon via `brew install --cask hammerspoon` on macOS
- Sync dotfiles-managed config from `data/` to `~/.hammerspoon/` via rsync
- Provide public API: `hammerspoon::install`, `hammerspoon::sync`, `hammerspoon::setup`, `hammerspoon::post_install`
- Store a snapshot of the Hammerspoon config in `data/` for distribution
- Graceful no-op on Linux (module loads but does nothing)

**Non-Goals:**
- Rewriting or refactoring the Hammerspoon Lua code itself
- Managing individual Spoon versions or LuaRocks dependencies
- Supporting Windows (Hammerspoon is macOS-only by design)
- Replacing the upstream `~/.hammerspoon/` repo as the source of truth

## Decisions

### Decision 1: Store full config snapshot in `data/` via rsync
- **Approach**: The Hammerspoon config (init.lua, src/, Spoons/, assets/) is stored under `zsh/modules/hammerspoon/data/` and synced to `~/.hammerspoon/` using rsync
- **Rationale**: Consistent with how zed, ghostty, and other modules handle config. Rsync is idempotent, preserves structure, and only copies diffs after the first sync.
- **Alternative considered**: Symlink from `~/.hammerspoon/` to the data directory. Rejected because Hammerspoon may write/update files in its config dir (SpoonInstall downloads Spoons), which would pollute the dotfiles tree.

### Decision 2: macOS-only with Linux stubs
- **Approach**: The config layer sets `ZSH_HAMMERSPOON_ENABLED=false` on Linux by default. The internal layer checks OSTYPE before attempting install.
- **Rationale**: Following the existing pattern (many modules have OS stubs). Keeps the structure uniform and allows future Linux-equivalent tools to be added if needed.

### Decision 3: Install via Homebrew cask
- **Approach**: `brew install --cask hammerspoon` for installation
- **Rationale**: Hammerspoon is distributed as a macOS .app via Homebrew cask. This is the official and recommended installation method.
- **Alternative considered**: Direct download from GitHub releases. Rejected — Homebrew handles updates, dependencies, and app registration.

### Decision 4: Use `core::ensure` for Homebrew dependency
- **Approach**: The internal layer calls `core::ensure brew` before attempting cask install
- **Rationale**: Follows the established pattern. Homebrew may not be present on a fresh Mac, so the ensure mechanism handles it transparently.

## Risks / Trade-offs

- **Risk**: Large `data/` directory (Spoons contain binary assets like PDF icons) → **Mitigation**: Use `.gitignore` patterns within the module if needed, or store only essential config files and let SpoonInstall handle Spoons at runtime
- **Risk**: Config drift between the upstream `~/.hammerspoon/` repo and `data/` → **Mitigation**: The sync is one-way (data/ → ~/.hammerspoon/). Upstream changes must be manually copied to data/
- **Trade-off**: macOS-only module means the internal/linux.zsh and config/linux.zsh will remain stubs forever, but the structural consistency is worth the minimal overhead
