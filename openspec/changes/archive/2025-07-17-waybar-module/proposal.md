## Why

Waybar is currently bundled as a dependency within the Hyprland module, but it's a standalone status bar application that deserves its own module for independent management, configuration, and lifecycle control. Extracting it allows users to:
- Configure waybar independently of Hyprland
- Use waybar with other Wayland compositors (Sway, etc.)
- Manage waybar's config sync, installation, and updates separately

## What Changes

- Create new `zsh/modules/waybar/` module following the three-layer architecture
- Extract waybar installation logic from `hyprland/internal/base.zsh` to `waybar/internal/base.zsh`
- Extract waybar health check from `hyprland/pkg/helper.zsh` to `waybar/pkg/helper.zsh`
- Add waybar-specific environment variables (`WAYBAR_CONFIG_PATH`, etc.)
- Add waybar config sync capability (rsync from `data/` to `~/.config/waybar/`)
- Add waybar public API functions (`waybar::install`, `waybar::sync`, `waybar::setup`)
- Remove waybar as a direct dependency from the Hyprland module's install function

## Capabilities

### New Capabilities

- `waybar-install`: Install waybar via package manager (independent of Hyprland)
- `waybar-config-sync`: Sync waybar configuration files from module data directory to user config directory
- `waybar-lifecycle`: Public API for waybar management (install, sync, setup, health check)

### Modified Capabilities

- `hyprland-install`: Remove waybar from the Hyprland package set (waybar becomes an optional dependency)

## Impact

- **Code**: `zsh/modules/hyprland/internal/base.zsh` (remove `core::install waybar`), `zsh/modules/hyprland/pkg/helper.zsh` (remove waybar check)
- **New files**: Entire `zsh/modules/waybar/` directory structure
- **Dependencies**: Hyprland module no longer auto-installs waybar; users must enable waybar module separately
- **Config paths**: `~/.config/waybar/` (standard XDG path)
