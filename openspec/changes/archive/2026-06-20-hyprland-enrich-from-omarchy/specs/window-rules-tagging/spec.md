## ADDED Requirements

### Requirement: Tag-based window rule system
The system SHALL support tagging windows by type with a composable helper function that applies multiple rules per tag.

#### Scenario: Tag helper function
- **WHEN** a tag helper (e.g., `tag_window(tag, rules)`) is called
- **THEN** it SHALL register all provided rules for that tag

### Requirement: Terminal window opacity
The system SHALL add a `+terminal` tag and apply 0.97 opacity to terminal windows.

#### Scenario: Terminal windows get opacity
- **WHEN** a terminal window (Alacritty, GNOME Terminal, Kitty, foot) is opened
- **THEN** its opacity SHALL be set to 0.97

### Requirement: Chromium-based browser rules
The system SHALL add a `+chromium-based-browser` tag applying opacity 0.97 and `tile` window rule to Chromium-based browsers (Google Chrome, Chromium, Brave, Edge, Vivaldi, Opera).

#### Scenario: Chromium-based browser windows tile
- **WHEN** a Chromium-based browser window is opened
- **THEN** it SHALL tile with 0.97 opacity

### Requirement: Firefox browser rules
The system SHALL add a `+firefox-browser` tag applying opacity 0.97 and `tile` window rule to Firefox.

#### Scenario: Firefox windows tile
- **WHEN** a Firefox window is opened
- **THEN** it SHALL tile with 0.97 opacity

### Requirement: Floating window defaults
The system SHALL add a `+floating-window` tag that centers and sizes floating windows to 60% width and 60% height.

#### Scenario: Floating window sized
- **WHEN** a floating window (tool windows, dialogs, wofi, rofi) is opened
- **THEN** it SHALL be centered at 60% of screen width and 60% of screen height

### Requirement: JetBrains no_follow_mouse
The system SHALL add a `+jetbrains` tag that sets `no_follow_mouse` for JetBrains IDE windows.

#### Scenario: JetBrains windows get no_follow_mouse
- **WHEN** a JetBrains IDE window (IntelliJ, PyCharm, WebStorm, CLion, Goland) is opened
- **THEN** it SHALL have `no_follow_mouse` set to prevent focus stealing on project file open

### Requirement: Bitwarden no_screen_share
The system SHALL add a `+bitwarden` tag that sets `no_screen_share` for Bitwarden desktop app.

#### Scenario: Bitwarden screen share blocked
- **WHEN** Bitwarden window is opened
- **THEN** it SHALL have `no_screen_share` enabled to prevent password exposure during screen sharing

### Requirement: Media app opacity
The system SHALL add a `+media` tag with lowered opacity for media playback windows (VLC, mpv, imv, Zoom, Wireshark).

#### Scenario: Media windows get lower opacity
- **WHEN** a media app window is opened
- **THEN** its opacity SHALL be set to 0.95
