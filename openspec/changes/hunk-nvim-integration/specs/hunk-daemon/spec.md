## ADDED Requirements

### Requirement: Toggle hunk daemon

The system SHALL provide a Neovim command `:HunkDaemon` that toggles the hunk AI agent daemon on and off.

When starting, the daemon SHALL be launched as a background process via `vim.fn.jobstart("hunk daemon serve")`.

When stopping, the daemon process SHALL be terminated gracefully.

The system SHALL track the daemon process ID and state (running/stopped) in a module-level variable.

The system SHALL define a keymap `<leader>hdm` as a shortcut for `:HunkDaemon`.

The system SHALL display a notification when the daemon starts or stops, including the PID when starting.

#### Scenario: Start hunk daemon

- **WHEN** user runs `:HunkDaemon` or presses `<leader>hdm`
- **AND** the daemon is not currently running
- **THEN** Neovim SHALL start `hunk daemon serve` as a background job
- **AND** display a notification: "hunk daemon started (PID: <pid>)"

#### Scenario: Stop hunk daemon

- **WHEN** user runs `:HunkDaemon` or presses `<leader>hdm`
- **AND** the daemon is currently running
- **THEN** Neovim SHALL terminate the daemon process
- **AND** display a notification: "hunk daemon stopped"

#### Scenario: Daemon status indication

- **WHEN** the daemon is running
- **THEN** the system SHOULD indicate the daemon status (e.g., via a global variable or statusline component)
