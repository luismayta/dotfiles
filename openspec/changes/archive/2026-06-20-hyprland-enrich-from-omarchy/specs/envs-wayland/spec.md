## ADDED Requirements

### Requirement: GDK Wayland backend
The system SHALL set `GDK_BACKEND=wayland` to force GTK applications to use the Wayland backend.

#### Scenario: GTK app uses Wayland
- **WHEN** a GTK application (GIMP, Nautilus, GTK-based apps) starts
- **THEN** it SHALL use the Wayland backend

### Requirement: Firefox Wayland
The system SHALL set `MOZ_ENABLE_WAYLAND=1` to force Firefox to use Wayland.

#### Scenario: Firefox uses Wayland
- **WHEN** Firefox starts
- **THEN** it SHALL use the Wayland backend

### Requirement: Electron Wayland
The system SHALL set the following Ozone environment variables for Chromium/Electron apps:
- `OZONE_PLATFORM_HINT=wayland`
- `ELECTRON_OZONE_PLATFORM_HINT=wayland`
- `NIXOS_OZONE_WL=1`

#### Scenario: Electron app uses Wayland
- **WHEN** an Electron application starts
- **THEN** it SHALL use the Wayland backend

### Requirement: Desktop environment variables
The system SHALL set `XDG_CURRENT_DESKTOP=Hyprland` and `XDG_SESSION_DESKTOP=Hyprland` for portal/screen sharing compatibility.

#### Scenario: Screen sharing works
- **WHEN** an application requests screen sharing
- **THEN** the portal SHALL recognize Hyprland as the desktop environment
