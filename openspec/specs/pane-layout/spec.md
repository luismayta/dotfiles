## ADDED Requirements

### Requirement: Reusable 3-pane IDE layout

The system SHALL provide an internal function `hrd::internal::pane::setup_3_pane_layout` in `internal/pane.zsh` that accepts a workspace ID and creates a 3-pane IDE layout.

The layout SHALL be:
- Pane 1 (left, 60% width): named `editor`
- Pane 2 (right-top, 40% width × 50% height): named `shell`
- Pane 3 (right-bottom, 40% width × 50% height): named `agent`

#### Scenario: Full layout setup
- **WHEN** `hrd::internal::pane::setup_3_pane_layout "ws_abc123"` is called
- **THEN** the system SHALL split right at 60% from the current pane
- **THEN** the system SHALL split down at 50% from the new right pane
- **THEN** the system SHALL rename `p1` to `editor`
- **THEN** the system SHALL rename `p2` to `shell`
- **THEN** the system SHALL rename `p3` to `agent`

#### Scenario: Missing workspace ID
- **WHEN** `hrd::internal::pane::setup_3_pane_layout ""` is called
- **THEN** the system SHALL emit a warning and return 1

#### Scenario: Pane command failure
- **WHEN** any `herdr pane` command fails during layout setup
- **THEN** the system SHALL emit a warning via `message_warning`
- **THEN** the system SHALL return 1 (do not abort the caller)

### Requirement: hrd::project uses extracted layout

The `hrd::project` function SHALL call `hrd::internal::pane::setup_3_pane_layout` instead of inline pane split/rename commands. Behavior MUST remain identical from the user's perspective.

#### Scenario: Project workspace with layout
- **WHEN** `hrd::project` creates a new workspace
- **THEN** the system SHALL call `hrd::internal::pane::setup_3_pane_layout` with the created workspace ID
- **THEN** the system SHALL print the same success message as before

### Requirement: hrdw::create uses extracted layout

The `hrdw::create` function SHALL call `hrd::internal::pane::setup_3_pane_layout` after successfully creating a worktree workspace.

#### Scenario: Worktree creation with layout
- **WHEN** `hrdw::create` successfully creates a worktree
- **THEN** the system SHALL resolve the workspace ID from the label
- **THEN** the system SHALL call `hrd::internal::pane::setup_3_pane_layout` with the resolved workspace ID

#### Scenario: Worktree creation with layout failure
- **WHEN** `hrdw::create` creates a worktree but pane layout setup fails
- **THEN** the system SHALL emit a warning
- **THEN** the system SHALL print the success message (worktree creation succeeded)
