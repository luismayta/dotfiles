## ADDED Requirements

### Requirement: Dismiss last notification
The system SHALL bind `SUPER+SHIFT+N` to dismiss the most recent notification via DMS IPC.

#### Scenario: Dismiss last notification
- **WHEN** user presses `SUPER+SHIFT+N` with an active notification visible
- **THEN** the notification SHALL be dismissed

### Requirement: Dismiss all notifications
The system SHALL bind `SUPER+CTRL+N` to dismiss all visible notifications via DMS IPC.

#### Scenario: Dismiss all notifications
- **WHEN** user presses `SUPER+CTRL+N` with one or more notifications visible
- **THEN** all visible notifications SHALL be dismissed

### Requirement: Toggle notification silence
The system SHALL bind `SUPER+ALT+N` to toggle notification silence mode on/off via DMS IPC.

#### Scenario: Toggle silence mode
- **WHEN** user presses `SUPER+ALT+N`
- **THEN** notification silence mode SHALL toggle (new notifications are suppressed while active)

### Requirement: Restore last notification
The system SHALL bind `SUPER+SHIFT+M` to restore the most recently dismissed notification via DMS IPC.

#### Scenario: Restore last notification
- **WHEN** user presses `SUPER+SHIFT+M` after dismissing a notification
- **THEN** the last dismissed notification SHALL be restored
