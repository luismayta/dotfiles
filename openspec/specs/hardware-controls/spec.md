## ADDED Requirements

### Requirement: Keyboard backlight control
The system SHALL bind `SUPER+F12` to cycle keyboard backlight modes, `SUPER+SHIFT+F12` to toggle keyboard backlight on/off, and `SUPER+CTRL+BRIGHTNESSDOWN`/`BRIGHTNESSUP` for fine backlight control.

#### Scenario: Cycle keyboard backlight
- **WHEN** user presses `SUPER+F12`
- **THEN** the keyboard backlight SHALL cycle to the next brightness or mode level

#### Scenario: Toggle keyboard backlight
- **WHEN** user presses `SUPER+SHIFT+F12`
- **THEN** the keyboard backlight SHALL toggle on/off

### Requirement: Touchpad toggle
The system SHALL bind `SUPER+SHIFT+SPACE` to toggle the touchpad on/off, `SUPER+SHIFT+CTRL+SPACE` to enable touchpad, and `SUPER+SHIFT+ALT+SPACE` to disable touchpad.

#### Scenario: Toggle touchpad
- **WHEN** user presses `SUPER+SHIFT+SPACE`
- **THEN** the touchpad state SHALL toggle

#### Scenario: Enable touchpad
- **WHEN** user presses `SUPER+SHIFT+CTRL+SPACE`
- **THEN** the touchpad SHALL be enabled

#### Scenario: Disable touchpad
- **WHEN** user presses `SUPER+SHIFT+ALT+SPACE`
- **THEN** the touchpad SHALL be disabled

### Requirement: Precise volume control
The system SHALL bind `ALT+XF86AudioLowerVolume` and `ALT+XF86AudioRaiseVolume` to adjust volume by ±1% for fine-grained control.

#### Scenario: Precise volume down
- **WHEN** user presses `ALT+XF86AudioLowerVolume`
- **THEN** volume SHALL decrease by 1%

#### Scenario: Precise volume up
- **WHEN** user presses `ALT+XF86AudioRaiseVolume`
- **THEN** volume SHALL increase by 1%

### Requirement: Precise brightness control
The system SHALL bind `ALT+XF86MonBrightnessDown` and `ALT+XF86MonBrightnessUp` to adjust brightness by ±1% for fine-grained control.

#### Scenario: Precise brightness down
- **WHEN** user presses `ALT+XF86MonBrightnessDown`
- **THEN** brightness SHALL decrease by 1%

#### Scenario: Precise brightness up
- **WHEN** user presses `ALT+XF86MonBrightnessUp`
- **THEN** brightness SHALL increase by 1%
