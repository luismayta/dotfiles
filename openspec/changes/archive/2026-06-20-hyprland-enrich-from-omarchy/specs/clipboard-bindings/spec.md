## ADDED Requirements

### Requirement: Universal clipboard copy
The system SHALL bind `SUPER+C` to copy selected text via `send_shortcut_once` for XWayland compatibility, falling back to `wl-copy` if available.

#### Scenario: Copy in XWayland app
- **WHEN** user presses `SUPER+C` with text selected in an XWayland application
- **THEN** the text SHALL be copied to the clipboard using `send_shortcut_once` key state dispatch

#### Scenario: Copy in native Wayland app
- **WHEN** user presses `SUPER+C` with text selected in a native Wayland application
- **THEN** the text SHALL be copied to the clipboard (handled by the application via standard Ctrl+C)

### Requirement: Universal clipboard paste
The system SHALL bind `SUPER+V` to paste clipboard content via `send_shortcut_once` for XWayland compatibility.

#### Scenario: Paste in XWayland app
- **WHEN** user presses `SUPER+V` with clipboard content in an XWayland application
- **THEN** the clipboard content SHALL be pasted using `send_shortcut_once` key state dispatch

#### Scenario: Paste in native Wayland app
- **WHEN** user presses `SUPER+V` with clipboard content in a native Wayland application
- **THEN** the clipboard content SHALL be pasted (handled by the application via standard Ctrl+V)

### Requirement: Universal clipboard cut
The system SHALL bind `SHIFT+SUPER+X` to cut selected text via `send_shortcut_once` for XWayland compatibility.

#### Scenario: Cut in XWayland app
- **WHEN** user presses `SHIFT+SUPER+X` with text selected in an XWayland application
- **THEN** the text SHALL be cut and placed on the clipboard using `send_shortcut_once`
