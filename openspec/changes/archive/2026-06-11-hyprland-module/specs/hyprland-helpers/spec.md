## ADDED Requirements

### Requirement: Config editor command
The module SHALL provide an `edithypr` command to edit the main Hyprland config.

#### Scenario: Edit config with EDITOR
- **WHEN** user runs `edithypr`
- **THEN** it SHALL open `~/.config/hypr/hyprland.lua` in `$EDITOR`
- **THEN** if `$EDITOR` is not set, it SHALL print a warning and return

### Requirement: Session management helpers
The module SHALL provide session management commands using `hyprctl`.

#### Scenario: List active workspaces
- **WHEN** user runs a workspace list command
- **THEN** it SHALL use `hyprctl workspaces -j` to list workspaces
- **THEN** it SHALL display workspace IDs, names, and monitor assignments

#### Scenario: Switch workspace
- **WHEN** user runs a workspace switch command with a workspace ID
- **THEN** it SHALL call `hyprctl dispatch workspace <id>`
- **THEN** it SHALL display the active workspace after switching

#### Scenario: Move window to workspace
- **WHEN** user runs a move-to-workspace command with a workspace ID
- **THEN** it SHALL call `hyprctl dispatch movetoworkspace <id>`

### Requirement: Wallpaper management
The module SHALL provide wallpaper control via `hyprpaper` or `hyprctl`.

#### Scenario: Set wallpaper
- **WHEN** user runs a wallpaper set command with an image path
- **THEN** it SHALL call `hyprctl hyprpaper wallpaper ",<path>"`

#### Scenario: Reload Hyprland config
- **WHEN** user runs a config reload command
- **THEN** it SHALL call `hyprctl reload`

### Requirement: Module status check
The module SHALL provide a `hyprland::check` function to verify installation status.

#### Scenario: Check installation status
- **WHEN** `hyprland::check` is called
- **THEN** it SHALL verify that `Hyprland` binary exists
- **THEN** it SHALL verify that `hyprctl` binary exists
- **THEN** it SHALL check if Hyprland is currently running (optional)
- **THEN** it SHALL display status for each component

### Requirement: Alias for hyprctl
The module SHALL provide convenient aliases for common `hyprctl` commands.

#### Scenario: hyprctl alias
- **WHEN** `hyprctl` is available
- **THEN** an alias SHALL NOT be needed (`hyprctl` is already the command name)
- **THEN** shortcuts for common operations SHALL be provided as zsh functions