## Why

Hyprland is the primary Wayland compositor for users on Arch/NixOS Linux. Currently there is no module to manage its installation, configuration sync, or provide helper commands. Adding a Hyprland module brings it in line with other window manager/tool support (tmux, nvim, starship) and enables declarative config management via the `data/` → `~/.config/` rsync pattern.

## What Changes

- **New `zsh/modules/hyprland/` module** following the exact structure of `zsh/modules/tmux/`
- Lua-based Hyprland configuration (`~/.config/hypr/hyprland.lua` with modular `require()` includes) — Hyprland 0.55+ native Lua support
- Config files in `data/hypr/` synced to `~/.config/hypr/`
- `hyprland::install` / `hyprland::sync` / `hyprland::post_install` public API
- Helper commands: `edithypr` (edit config), session/workspace management via `hyprctl`, wallpaper helpers
- Package installation: `hyprland`, `hypridle`, `hyprlock`, `hyprpaper`, `waybar`, `dunst` (Linux only)
- Auto-dispatch: module activates only when `$OSTYPE` is `linux*`

## Capabilities

### New Capabilities
- `hyprland-config`: Core Hyprland Lua configuration with modular includes (layout, binds, window rules, cursor, outputs, colors)
- `hyprland-install`: Package installation for Hyprland ecosystem (hyprland, hypridle, hyprlock, hyprpaper, waybar, dunst)
- `hyprland-sync`: Rsync-based deployment of config files (`data/` → `~/.config/`)
- `hyprland-helpers`: User-facing commands for config editing, workspace management, wallpaper switching, session control

### Modified Capabilities

None — this is a new module with no existing specs to modify.

## Impact

- **New directory**: `zsh/modules/hyprland/` with full sub-tree (config/, data/, internal/, pkg/)
- **New dotfiles**: `~/.config/hypr/hyprland.lua` (main), `~/.config/hypr/hypr-binds.lua` (keybinds), `~/.config/hypr/hypr-windowrules.lua` (window rules), `~/.config/hypr/hypr-colors.lua` (theme), `~/.config/hypr/hypr-layout.lua` (layout settings), `~/.config/hypr/hypr-outputs.lua` (monitor config), `~/.config/hypr/hypr-cursor.lua` (cursor theme)
- **Dependencies**: Hyprland ≥ 0.55 for Lua config support. Linux-only module (no macOS equivalent)
- **No breaking changes** — existing modules untouched