## ADDED Requirements

### Requirement: System lock
The system SHALL bind `SUPER+ALT+ESCAPE` to lock the screen via DMS IPC.

#### Scenario: Lock screen
- **WHEN** user presses `SUPER+ALT+ESCAPE`
- **THEN** the screen SHALL lock

### Requirement: Color picker
The system SHALL bind `SUPER+PRINT` to open a color picker tool.

#### Scenario: Open color picker
- **WHEN** user presses `SUPER+PRINT`
- **THEN** a color picker SHALL launch and allow the user to pick a color from the screen

### Requirement: OCR from screenshot
The system SHALL bind `SUPER+SHIFT+PRINT` to take a screenshot and run OCR on the captured region.

#### Scenario: OCR screenshot
- **WHEN** user presses `SUPER+SHIFT+PRINT`
- **THEN** a screenshot SHALL be taken and OCR SHALL be performed on the selected region

### Requirement: Window transparency toggle
The system SHALL bind `SUPER+O` to cycle the focused window's opacity between 0.97 (normal), 0.60 (semi-transparent), and 1.0 (opaque).

#### Scenario: Cycle window transparency
- **WHEN** user presses `SUPER+O`
- **THEN** the focused window SHALL cycle to the next opacity level

### Requirement: Window gaps toggle
The system SHALL bind `SUPER+SHIFT+G` to toggle window gaps on/off (0px vs default gap size).

#### Scenario: Toggle gaps
- **WHEN** user presses `SUPER+SHIFT+G`
- **THEN** window gaps SHALL toggle between 0px and the configured default

### Requirement: Zoom in
The system SHALL bind `SUPER+CTRL+equal` to zoom in by increasing `cursor.zoom_factor`.

#### Scenario: Zoom in
- **WHEN** user presses `SUPER+CTRL+equal`
- **THEN** the cursor zoom factor SHALL increase

### Requirement: Zoom reset
The system SHALL bind `SUPER+CTRL+0` to reset `cursor.zoom_factor` to 1.0.

#### Scenario: Reset zoom
- **WHEN** user presses `SUPER+CTRL+0`
- **THEN** the cursor zoom factor SHALL reset to 1.0
