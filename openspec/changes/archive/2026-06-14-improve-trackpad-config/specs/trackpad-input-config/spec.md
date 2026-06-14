## ADDED Requirements

### Requirement: Touchpad input settings block

The system SHALL provide a `touchpad` sub-table inside the `input` block of `configs/general.lua` that configures libinput touchpad behavior.

The touchpad block SHALL be placed after the existing `repeat_delay` setting and before the closing `},` of the `input` table.

#### Scenario: Touchpad block exists with all required settings
- **GIVEN** the Hyprland config is loaded
- **WHEN** `hyprctl getoption input:touchpad` is queried
- **THEN** the response SHALL contain each of the configured settings with their assigned values

### Requirement: Natural scroll

The `touchpad` block SHALL set `natural_scroll = true` to enable content-follows-finger scroll direction (macOS-style).

#### Scenario: Natural scroll enabled
- **GIVEN** the touchpad block is active
- **WHEN** the user scrolls down with two fingers
- **THEN** the content moves down (content follows finger motion)

### Requirement: Tap-to-click

The `touchpad` block SHALL set `tap_to_click = true` to enable tap-to-left-click.

#### Scenario: Tap registers as left click
- **GIVEN** the touchpad block is active
- **WHEN** the user taps the touchpad with one finger
- **THEN** a left-click event is generated

### Requirement: Clickfinger behavior

The `touchpad` block SHALL set `clickfinger_behavior = true` so that:
- One-finger click = left click
- Two-finger click = right click
- Three-finger click = middle click

#### Scenario: Two-finger click triggers right click
- **GIVEN** the touchpad block is active
- **WHEN** the user clicks with two fingers simultaneously
- **THEN** a right-click event is generated

#### Scenario: Three-finger click triggers middle click
- **GIVEN** the touchpad block is active
- **WHEN** the user clicks with three fingers simultaneously
- **THEN** a middle-click event is generated

### Requirement: Scroll factor

The `touchpad` block SHALL set `scroll_factor = 0.5` to reduce scroll speed for finer control.

#### Scenario: Scroll speed is halved
- **GIVEN** the touchpad block is active
- **WHEN** the user scrolls one notch/unit
- **THEN** the scroll distance is reduced by half compared to the default (`1.0`)

### Requirement: Disable while typing

The `touchpad` block SHALL set `disable_while_typing = true` to prevent accidental cursor movement and clicks while the keyboard is active.

#### Scenario: Touchpad disabled during typing
- **GIVEN** the user is typing on the keyboard
- **WHEN** the user's palm or thumb contacts the touchpad
- **THEN** no cursor movement or click event is generated

### Requirement: Drag lock

The `touchpad` block SHALL set `drag_lock = true` to allow lifting the finger during a drag without dropping the drag operation.

#### Scenario: Drag lock allows lift-and-continue
- **GIVEN** the touchpad block is active
- **WHEN** the user starts a drag, lifts the finger, and then touches the touchpad again
- **THEN** the drag continues without requiring the finger to remain in contact

### Requirement: Middle button emulation

The `touchpad` block SHALL set `middle_button_emulation = false` because `clickfinger_behavior` already provides middle-click via three-finger click.

#### Scenario: Middle button emulation is off
- **GIVEN** the touchpad block is active
- **WHEN** the user presses both left and right buttons simultaneously
- **THEN** no middle-click event is generated (handled by clickfinger instead)
