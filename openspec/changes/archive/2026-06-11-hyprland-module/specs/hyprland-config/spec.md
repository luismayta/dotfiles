## ADDED Requirements

### Requirement: Main config file
The module SHALL deploy a `hyprland.lua` as the main Hyprland configuration entry point.

#### Scenario: Config file exists at correct path
- **WHEN** the module performs sync
- **THEN** the file `~/.config/hypr/hyprland.lua` SHALL exist

#### Scenario: Main config requires sub-modules
- **WHEN** Hyprland loads `hyprland.lua`
- **THEN** it SHALL `require()` the following sub-configs: `hypr.binds`, `hypr.windowrules`, `hypr.layout`, `hypr.outputs`, `hypr.cursor`, `hypr.colors`, `hypr.binds-user`

### Requirement: Binds configuration
The module SHALL deploy a `hypr-binds.lua` with default keybindings inspired by DankMaterialShell.

#### Scenario: Default keybindings present
- **WHEN** `hypr-binds.lua` is loaded
- **THEN** it SHALL define application launcher binds (SUPER + T for terminal, SUPER + space for launcher)
- **THEN** it SHALL define window management binds (SUPER + Q close, SUPER + F fullscreen, SUPER + arrows for focus)
- **THEN** it SHALL define workspace navigation binds (SUPER + number for workspace switching, SUPER + SHIFT + number to move windows)
- **THEN** it SHALL define media keys (XF86Audio*, XF86MonBrightness*)
- **THEN** it SHALL define screenshot binds (Print, CTRL + Print, ALT + Print)
- **THEN** it SHALL define mouse binds (SUPER + mouse:272 for move, SUPER + mouse:273 for resize)
- **THEN** it SHALL define a 3-finger horizontal touchpad gesture for workspace switching

### Requirement: User binds override file
The module SHALL deploy a `hypr-binds-user.lua` file intended for user overrides.

#### Scenario: User binds loaded last
- **WHEN** Hyprland loads config
- **THEN** `hypr-binds-user.lua` SHALL be required after `hypr-binds.lua`
- **THEN** user binds SHALL override any default binds with the same key combination

### Requirement: Window rules configuration
The module SHALL deploy a `hypr-windowrules.lua` with default window rules.

#### Scenario: Window rules defined
- **WHEN** `hypr-windowrules.lua` is loaded
- **THEN** it SHALL define float rules for dialogs (blueman-manager, gnome-calculator, galculator, xdg-desktop-portal)
- **THEN** it SHALL define float rules for Picture-in-Picture windows (firefox, zoom)
- **THEN** it SHALL define layer rules to disable animations for shell layer surfaces
- **THEN** it SHALL define tile rules for terminal emulators

### Requirement: Colors configuration
The module SHALL deploy a `hypr-colors.lua` with Catppuccin Mocha theme colors.

#### Scenario: Catppuccin Mocha colors defined
- **WHEN** `hypr-colors.lua` is loaded
- **THEN** it SHALL set `active_border` and `inactive_border` colors matching Catppuccin Mocha palette
- **THEN** it SHALL set group border colors (active, inactive, locked_active, locked_inactive)
- **THEN** it SHALL set groupbar colors (active, inactive, locked_active, locked_inactive)

### Requirement: Layout configuration
The module SHALL deploy a `hypr-layout.lua` with layout and decoration defaults.

#### Scenario: Layout defaults defined
- **WHEN** `hypr-layout.lua` is loaded
- **THEN** it SHALL set gaps_in (4px) and gaps_out (4px)
- **THEN** it SHALL set border_size (2px)
- **THEN** it SHALL set decoration rounding (12px)

### Requirement: Outputs configuration
The module SHALL deploy a `hypr-outputs.lua` with monitor configuration.

#### Scenario: Default monitor config
- **WHEN** `hypr-outputs.lua` is loaded
- **THEN** it SHALL define a catch-all monitor rule (`output = ""`, `mode = "preferred"`, `position = "auto"`, `scale = "auto"`)

### Requirement: Cursor configuration
The module SHALL deploy a `hypr-cursor.lua` with cursor theme settings.

#### Scenario: Cursor theme configured
- **WHEN** `hypr-cursor.lua` is loaded
- **THEN** it SHALL set cursor theme name, size, and enable hyprcursor