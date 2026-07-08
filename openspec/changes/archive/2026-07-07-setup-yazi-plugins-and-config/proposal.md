## Why

Our yazi module currently only syncs a theme file. The reference configuration in JAEHEONJI/dotfiles shows a richer setup with plugins (full-border, no-status, starship), a custom linemode showing "size permissions mtime", and a package.toml for pinned plugin dependencies. Porting these will improve the yazi experience with minimal effort — the module already has the sync infrastructure.

## What Changes

- Add `yazi.toml` to the synced config with `linemode = "custom"` and other sensible defaults
- Add `package.toml` with plugin dependencies (full-border, no-status, starship) pinned to specific revisions
- Add `init.lua` that loads plugins and implements the custom "size permissions mtime" linemode
- Update `yazi::internal::config::sync` to also write `yazi.toml`, `package.toml`, and `init.lua` alongside the theme
- Ensure the module creates `~/.config/yazi/` plugins directory structure if needed for yazi to resolve plugin deps

## Capabilities

### New Capabilities
- `yazi-plugin-setup`: plugin dependency declarations in package.toml and Lua initialization in init.lua
- `yazi-config-settings`: yazi.toml configuration (linemode, manager settings, etc.)

### Modified Capabilities
- (none — all new capabilities)

## Impact

- **Module**: `zsh/modules/yazi/internal/base.zsh` — `yazi::internal::config::sync` will write additional files
- **Module**: `zsh/modules/yazi/data/` — add `init.lua`, `yazi.toml`, `package.toml` as source files
- **Runtime**: First `yazi::sync` after deployment will copy new files to `~/.config/yazi/`; yazi will auto-download plugins on next launch via package.toml
