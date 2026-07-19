## Context

Waybar is currently installed as part of the Hyprland module's package set, but it's a standalone status bar for Wayland compositors. The current integration is minimal: just `core::install waybar` in the install function and a health check in `hypr::check`. There's no dedicated configuration, lifecycle management, or independent control.

The Hyprland module follows the standard three-layer architecture (config → internal → pkg) with OS dispatch. The new waybar module will follow the same pattern for consistency.

## Goals / Non-Goals

**Goals:**
- Create a standalone waybar module following the three-layer architecture
- Enable independent waybar configuration and lifecycle management
- Support waybar with any Wayland compositor (not just Hyprland)
- Maintain backward compatibility for users who currently have waybar installed via Hyprland

**Non-Goals:**
- Migrate existing waybar configurations (users keep their current setup)
- Add waybar-specific themes or styles (users manage their own)
- Implement waybar plugin management
- Support multiple status bar providers (keep it simple for now)

## Decisions

### 1. Module Structure: Standard Three-Layer

**Decision**: Use the standard `config/`, `internal/`, `pkg/` structure without adapter pattern.

**Rationale**: Waybar is a single application with no interchangeable backends. The adapter pattern is for modules with 3+ providers (like Docker with podman/colima/orbstack). Waybar doesn't need this complexity.

**Alternatives considered**:
- Provider adapter pattern: Rejected as over-engineered for a single application

### 2. Config Sync: Rsync-based

**Decision**: Use `rsync -avzh` to sync from `data/` to `~/.config/waybar/`.

**Rationale**: This matches the pattern used by other modules (zed, alacritty, ghostty). Rsync is already available and handles file synchronization reliably.

**Alternatives considered**:
- Symlinks: Rejected because users may want to edit configs in place without affecting the module's data directory
- Copy (cp): Rejected because rsync is more efficient for incremental updates

### 3. Installation: Package Manager Only

**Decision**: Install waybar via the system package manager (paru on Arch, brew on macOS).

**Rationale**: Waybar is available in most package managers. Building from source adds complexity without benefit for most users.

**Alternatives considered**:
- Build from source: Rejected as unnecessary complexity
- AUR helper specific: Keep it generic via `core::install`

### 4. Hyprland Integration: Remove as Hard Dependency

**Decision**: Remove `core::install waybar` from Hyprland's install function.

**Rationale**: Waybar should be optional. Users who don't want waybar (or use a different bar) shouldn't have it force-installed with Hyprland.

**Alternatives considered**:
- Keep as optional dependency in Hyprland: Rejected to maintain clear separation of concerns

## Risks / Trade-offs

### Risk: Breaking existing installations
**Mitigation**: The waybar binary will still be installed if users had it before. The module only changes how waybar is managed going forward. Users who had waybar via Hyprland will still have it; they just need to enable the waybar module for config sync.

### Risk: Config path conflicts
**Mitigation**: Use standard XDG path `~/.config/waybar/`. If users have custom paths, they can override `WAYBAR_CONFIG_PATH`.

### Risk: macOS support limited
**Mitigation**: Waybar is Linux-focused. macOS placeholders will exist but may not be functional. Document this limitation.

### Trade-off: Less Hyprland integration
**Decision**: Accept that waybar won't auto-start with Hyprland by default.
**Rationale**: Users who want auto-start can add `waybar &` to their Hyprland config. This keeps the modules independent.
