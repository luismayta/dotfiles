## Purpose

Extends the pane layout capability to support creating multiple tabs with independent 3-pane layouts in a single workspace call.

## MODIFIED Requirements

### Requirement: Reusable multi-tab 3-pane IDE layout

The system SHALL provide an internal function `hrd::internal::pane::setup_3_pane_layout` in `internal/pane.zsh` that accepts a workspace ID and an optional number of tabs parameter.

When `num_tabs` is provided, the system SHALL create that many tabs and apply the 3-pane layout to each. When `num_tabs` is omitted, the system SHALL default to **2 tabs**.

Each tab's layout SHALL be:
- Pane 1 (left, 60% width): named `editor`
- Pane 2 (right-top, 40% width × 50% height): named `shell`
- Pane 3 (right-bottom, 40% width × 50% height): named `agent`

#### Scenario: Default dual-tab layout
- **WHEN** `hrd::internal::pane::setup_3_pane_layout "ws_abc123"` is called without num_tabs
- **THEN** the system SHALL create 2 tabs
- **AND** apply 3-pane layout to each tab
- **AND** name panes consistently in each tab

#### Scenario: Single tab layout
- **WHEN** `hrd::internal::pane::setup_3_pane_layout "ws_abc123" 1` is called
- **THEN** the system SHALL create only 1 tab
- **AND** apply 3-pane layout to that tab

#### Scenario: Multiple tabs layout
- **WHEN** `hrd::internal::pane::setup_3_pane_layout "ws_abc123" 3` is called
- **THEN** the system SHALL create 3 tabs
- **AND** apply 3-pane layout to each tab

#### Scenario: Missing workspace ID
- **WHEN** `hrd::internal::pane::setup_3_pane_layout ""` is called
- **THEN** the system SHALL emit a warning and return 1

#### Scenario: Pane command failure
- **WHEN** any `herdr pane` command fails during layout setup
- **THEN** the system SHALL emit a warning via `message_warning`
- **AND** continue to next tab (do not abort entire operation)

#### Scenario: Tab creation failure
- **WHEN** a `herdr tab create` command fails
- **THEN** the system SHALL emit a warning
- **AND** continue with remaining tabs
- **AND** apply layout to successfully created tabs

### Requirement: hrd::project uses multi-tab layout

The `hrd::project` function SHALL call `hrd::internal::pane::setup_3_pane_layout` which will now create 2 tabs by default.

#### Scenario: Project workspace with dual tabs
- **WHEN** `hrd::project` creates a new workspace
- **THEN** the system SHALL call `hrd::internal::pane::setup_3_pane_layout` with the created workspace ID
- **AND** 2 tabs will be created with 3-pane layouts each

### Requirement: hrdw::create uses multi-tab layout

The `hrdw::create` function SHALL call `hrd::internal::pane::setup_3_pane_layout` which will now create 2 tabs by default.

#### Scenario: Worktree creation with dual tabs
- **WHEN** `hrdw::create` successfully creates a worktree
- **THEN** the system SHALL resolve the workspace ID from the label
- **THEN** the system SHALL call `hrd::internal::pane::setup_3_pane_layout` with the resolved workspace ID
- **AND** 2 tabs will be created with 3-pane layouts each
