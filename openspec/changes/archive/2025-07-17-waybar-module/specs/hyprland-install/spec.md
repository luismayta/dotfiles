## MODIFIED Requirements

### Requirement: Hyprland package installation
The system SHALL install Hyprland and its core dependencies, but not waybar.

#### Scenario: Install Hyprland on Linux
- **WHEN** hyprland module is loaded on Linux
- **AND** Hyprland is not installed
- **THEN** system SHALL install hyprland, hypridle, hyprlock, hyprpaper, dunst
- **AND** system SHALL NOT install waybar

#### Scenario: Install Hyprland on macOS
- **WHEN** hyprland module is loaded on macOS
- **AND** Hyprland is not installed
- **THEN** system SHALL install hyprland, hypridle, hyprlock, hyprpaper, dunst
- **AND** system SHALL NOT install waybar

### Requirement: Hyprland health check
The system SHALL check installation status of Hyprland components, excluding waybar.

#### Scenario: Check Hyprland components
- **WHEN** user calls `hypr::check`
- **THEN** system SHALL check hyprland, hypridle, hyprlock, hyprpaper, dunst
- **AND** system SHALL NOT check waybar
