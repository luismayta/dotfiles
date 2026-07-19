## ADDED Requirements

### Requirement: Waybar base configuration exists
The waybar module SHALL ship a base `config` file (jsonc format) in `data/` that waybar can load on first run.

#### Scenario: Default config is present after sync
- **WHEN** `waybar::sync` runs
- **THEN** `~/.config/waybar/config` exists and is valid jsonc

### Requirement: Base config includes standard modules
The base config SHALL include waybar's built-in modules: workspaces, clock, tray, and battery (if applicable).

#### Scenario: Standard modules are configured
- **WHEN** waybar starts with the base config
- **THEN** the bar displays at minimum: workspaces, clock, and tray modules

### Requirement: Bar layout defines module positions
The base config SHALL define `modules-left`, `modules-center`, and `modules-right` arrays for bar layout.

#### Scenario: Module positions are correct
- **WHEN** waybar renders the bar
- **THEN** modules appear in their designated positions (left/center/right)

### Requirement: Base style exists
The waybar module SHALL ship a `style.css` file in `data/` with minimal styling.

#### Scenario: Style is applied
- **WHEN** waybar starts with the base config
- **THEN** the bar has basic styling (font, padding, colors)
