## Why

The `zsh/modules/nvim/` module has a three-layer architecture (config → internal → pkg) with OS-specific dispatch, but the clean functionality doesn't leverage it properly. XDG environment variables (`NVIM_DATA_HOME`, `NVIM_CACHE_HOME`, `NVIM_STATE_HOME`) are defined in two places (`config/linux.zsh` AND `internal/linux.zsh`), while the main `nvim::clean` function uses hardcoded paths instead of the variables. A separate `nvim::clean::xdg` function exists with non-standard naming. This refactor eliminates the duplication, normalizes the API, and makes the clean function honor the XDG configuration.

## What Changes

- **Eliminate XDG variable duplication**: Remove `internal/linux.zsh` — the `NVIM_DATA_HOME`, `NVIM_CACHE_HOME`, `NVIM_STATE_HOME` vars are already defined in `config/linux.zsh` (the correct config layer)
- **Consolidate `nvim::clean`**: Move the logic from `pkg/linux.zsh` (`nvim::clean::xdg`) into `internal/base.zsh` (`nvim::internal::clean`) using the XDG variables instead of hardcoded paths
- **Remove `nvim::clean::xdg`**: Delete `pkg/linux.zsh` and its dispatch in `pkg/main.zsh`
- **Remove `internal/linux.zsh`**: No longer needed since its content is duplicated in `config/linux.zsh`
- **`nvim::clean` now uses XDG vars everywhere**: On all OSes, the clean function reads `$NVIM_DATA_HOME`, `$NVIM_CACHE_HOME`, `$NVIM_STATE_HOME` — which fall back to standard paths via the existing config layer
- **BREAKING**: `nvim::clean::xdg` is removed — use `nvim::clean` instead (which now does the same thing)

## Capabilities

### New Capabilities
- *(none — this is a refactor with no new capabilities)*

### Modified Capabilities
- *(none — no spec-level behavior changes)*

## Impact

- **Files removed**: `internal/linux.zsh`, `pkg/linux.zsh`
- **Files modified**: `internal/base.zsh` (switch to XDG vars), `pkg/base.zsh` (no change needed — already delegates to internal), `pkg/main.zsh` (remove linux dispatch), `internal/main.zsh` (remove linux dispatch)
- **Public API**: `nvim::clean` behavior unchanged (but now uses XDG vars); `nvim::clean::xdg` removed
- **Config layer**: `config/linux.zsh` remains the single source of truth for XDG vars
- **macOS**: `NVIM_DATA_HOME` etc. are not defined on macOS (no `config/osx.zsh` override), so `nvim::clean` falls back to `${HOME}/.local/share/nvim` etc. via the default expansion in the function
