## ADDED Requirements

### Requirement: Declarative workspace profile definitions

The system SHALL provide a `profiles` table in `configs/binds/workspace.lua` that defines workspace profiles as data, mirroring Hammerspoon's `config.profiles` structure.

Each profile SHALL contain:
- `name`: string identifier (e.g., `"developer"`, `"research"`, `"speaker"`)
- `mainScreen`: array of application names/commands to launch on the primary monitor
- `secondScreen`: array of application names/commands to launch on the secondary monitor

#### Scenario: Profile definition is pure data
- **WHEN** inspecting a profile definition
- **THEN** it contains only data fields (name, mainScreen, secondScreen) with no executable logic

### Requirement: Profile dispatch function

The system SHALL provide a `dispatch_profile(name)` function that, given a profile name, launches all applications defined in that profile across the appropriate monitors.

The function SHALL:
1. Look up the profile by name from the `profiles` table
2. For each app in `mainScreen`, execute it (Hyprland will place it on the focused/primary monitor)
3. For each app in `secondScreen`, execute it and move to the secondary monitor using `hyprctl dispatch movewindow`

#### Scenario: Developer profile launches dev environment
- **WHEN** the user activates the "developer" profile
- **THEN** Zen launches on main screen AND Ghostty, Discord, Obsidian launch on second screen

#### Scenario: Speaker profile launches presentation setup
- **WHEN** the user activates the "speaker" profile
- **THEN** Zen, Obsidian, Ghostty launch on main screen AND Discord launches on second screen

### Requirement: Profile switch hotkey

The system SHALL provide a hotkey to switch between workspace profiles, using the Hyper modifier (`SUPER + ALT + CTRL + W`), matching the Hammerspoon `switchProfile` hotkey pattern.

#### Scenario: Profile cycling on hotkey
- **WHEN** the user presses `SUPER + ALT + CTRL + W`
- **THEN** the system cycles to the next workspace profile and dispatches its applications

### Requirement: Default profile on startup

The system SHALL define a default profile (`"developer"`) that is dispatched automatically when the Hyprland session starts, via `configs/execs.lua` or the profile system's initialization.

#### Scenario: Default profile auto-launches
- **WHEN** Hyprland starts
- **THEN** the "developer" profile applications launch on their respective screens
