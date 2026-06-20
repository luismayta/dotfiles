## ADDED Requirements

### Requirement: Monitor scaling cycle
The system SHALL bind `SUPER+=` to cycle the focused monitor's scale through 1x, 1.25x, 1.6x, 2x, 3x, and 4x, and `SUPER+ALT+=` to cycle in reverse.

#### Scenario: Cycle scale forward
- **WHEN** user presses `SUPER+=`
- **THEN** the focused monitor SHALL cycle to the next scale in the sequence (1x → 1.25x → 1.6x → 2x → 3x → 4x → 1x)

#### Scenario: Cycle scale backward
- **WHEN** user presses `SUPER+ALT+=`
- **THEN** the focused monitor SHALL cycle to the previous scale in the sequence

#### Scenario: GDK_SCALE matches monitor scale
- **WHEN** monitor scale changes
- **THEN** `GDK_SCALE` SHALL be set to the matching value for that scale tier

### Requirement: Internal display toggle with safety
The system SHALL bind `SUPER+CTRL+Delete` to toggle the internal laptop display (eDP-*) on/off, and SHALL refuse to disable if no external monitor is connected.

#### Scenario: Toggle internal display off — external monitor present
- **WHEN** user presses `SUPER+CTRL+Delete` and an external monitor is connected
- **THEN** the internal display SHALL be disabled and workspaces moved to the external monitor

#### Scenario: Toggle internal display on
- **WHEN** user presses `SUPER+CTRL+Delete` and the internal display is disabled
- **THEN** the internal display SHALL be re-enabled

#### Scenario: Refuse to disable — no external monitor
- **WHEN** user presses `SUPER+CTRL+Delete` and no external monitor is connected
- **THEN** the internal display SHALL remain enabled and a notification SHALL inform the user

### Requirement: Internal display mirror toggle
The system SHALL bind `SUPER+CTRL+ALT+Delete` to toggle mirror mode for the internal display onto the external monitor.

#### Scenario: Enable mirror mode
- **WHEN** user presses `SUPER+CTRL+ALT+Delete` with an external monitor connected
- **THEN** the internal display SHALL mirror to the external monitor

#### Scenario: Disable mirror mode
- **WHEN** user presses `SUPER+CTRL+ALT+Delete` and mirror mode is active
- **THEN** mirror mode SHALL be disabled and displays return to extended layout

### Requirement: Lid switch auto-handling
The system SHALL bind `switch:on:Lid Switch` to disable the internal display (only when external monitor is connected) and `switch:off:Lid Switch` to re-enable the internal display.

#### Scenario: Lid closed with external monitor
- **WHEN** the laptop lid is closed and an external monitor is connected
- **THEN** the internal display SHALL be disabled

#### Scenario: Lid closed without external monitor
- **WHEN** the laptop lid is closed and no external monitor is connected
- **THEN** the system SHALL NOT disable the internal display (stay usable)

#### Scenario: Lid opened
- **WHEN** the laptop lid is opened
- **THEN** the internal display SHALL be re-enabled
