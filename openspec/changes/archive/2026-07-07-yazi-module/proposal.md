## Why

Yazi is a modern, blazing-fast terminal file manager written in Rust with async I/O, image preview support, and a Lua plugin system. Currently there's no ZSH module to manage its installation, config sync, or provide a shell wrapper — making it harder to adopt consistently across machines. Adding a yazi module fills this gap and follows the established module architecture used by zed, herdr, and others.

## What Changes

- Create `zsh/modules/yazi/` with the standard 3-layer scaffold (config, internal, pkg)
- Auto-install yazi via pacman on Arch Linux or cargo on macOS/Linux if missing
- Sync dotfiles-managed yazi config from `data/` to `~/.config/yazi/`
- Provide a `y()` wrapper function that lets the shell `cd` into the directory yazi exits in
- Provide public API functions: `yazi::install`, `yazi::sync`, `yazi::setup`
- Provide user alias `yazi::setup` for quick setup

## Capabilities

### New Capabilities
- `yazi-install`: Auto-install yazi binary when missing, with platform-appropriate package manager fallback
- `yazi-config-sync`: Sync managed yazi configuration (yazi.toml, keymap.toml, theme.toml) from data/ to ~/.config/yazi/
- `yazi-shell-wrapper`: Provide `y()` function that preserves the last-browsed directory on exit

### Modified Capabilities

None.

## Impact

- New module at `zsh/modules/yazi/` — no changes to existing modules
- No breaking changes to existing shell sessions
- Depends on `zsh/core/` for `core::exists`, `core::ensure`, `message_*` functions
- Optional runtime dependencies: fd, fzf, ripgrep, zoxide, ffmpeg, 7zip (for enhanced previews — recommended but not required by the module itself)
