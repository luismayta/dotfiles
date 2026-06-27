## ADDED Requirements

### Requirement: Workspace navigation with HYPER + TAB
The system SHALL navigate between workspaces when the user presses `HYPER (SUPER + ALT + CTRL) + TAB` and `HYPER + SHIFT + TAB`.

- `HYPER + TAB` SHALL focus the previous (e-1) workspace
- `HYPER + SHIFT + TAB` SHALL focus the next (e+1) workspace

This mirrors the existing `SUPER + SHIFT + TAB` (previous workspace) pattern but using the HYPER tier.

#### Scenario: Focus previous workspace
- **WHEN** user presses `SUPER + ALT + CTRL + TAB`
- **THEN** focus switches to the previous workspace (e-1)

#### Scenario: Focus next workspace
- **WHEN** user presses `SUPER + ALT + CTRL + SHIFT + TAB`
- **THEN** focus switches to the next workspace (e+1)

#### Scenario: Wrap around from first workspace
- **WHEN** user presses `SUPER + ALT + CTRL + TAB` while on workspace 1
- **THEN** focus wraps to the last workspace

### Requirement: Monitor focus with SUPER + SHIFT + ALT + H/L
The system SHALL move focus between monitors when the user presses `SUPER + SHIFT + ALT + H` (focus monitor left) and `SUPER + SHIFT + ALT + L` (focus monitor right).

This extends the existing `SUPER + SHIFT + ALT + LEFT/RIGHT` pattern (which moves workspaces between monitors) to also support focus with HJKL directional keys.

#### Scenario: Focus monitor left
- **WHEN** user presses `SUPER + SHIFT + ALT + H`
- **THEN** focus moves to the monitor on the left

#### Scenario: Focus monitor right
- **WHEN** user presses `SUPER + SHIFT + ALT + L`
- **THEN** focus moves to the monitor on the right

### Requirement: Existing workspace and monitor binds remain unchanged
The existing binds (`SUPER + SHIFT + TAB` for previous workspace, `SUPER + {1-9}` for direct workspace, `SUPER + SHIFT + ALT + LEFT/RIGHT` for sending workspace between monitors) SHALL continue working as before.

#### Scenario: SUPER+SHIFT+TAB still works
- **WHEN** user presses `SUPER + SHIFT + TAB`
- **THEN** focus switches to the previous workspace (same behavior as before)

#### Scenario: SUPER+SHIFT+ALT+LEFT/RIGHT still works
- **WHEN** user presses `SUPER + SHIFT + ALT + LEFT`
- **THEN** the active workspace moves to the monitor on the left (same behavior as before)
