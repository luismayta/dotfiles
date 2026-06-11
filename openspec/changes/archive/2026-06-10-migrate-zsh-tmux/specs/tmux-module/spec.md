## ADDED Requirements

### Requirement: Tmux installation and TPM setup
The system SHALL install tmux via `core::install` and TPM (Tmux Plugin Manager) via git clone when tmux is not present.

#### Scenario: Automatic tmux installation on missing binary
- **WHEN** tmux is not found in PATH
- **THEN** the module SHALL call `core::install tmux` and clone TPM to `$HOME/.tmux/plugins/tpm`

#### Scenario: Tmuxinator optional installation
- **WHEN** gem is available and tmuxinator is requested
- **THEN** the module SHALL install tmuxinator via `gem install tmuxinator`

### Requirement: Config data synchronization
The system SHALL rsync tmux configuration files from the module's data directory to the user's home directory.

#### Scenario: Full config sync
- **WHEN** `tmux::sync` is invoked
- **THEN** `data/conf/.tmux.conf` SHALL be rsynced to `$HOME/.tmux.conf`
- **THEN** `data/sync/tmux/` SHALL be rsynced to `$HOME/.config/tmux/`

#### Scenario: Post-install sync
- **WHEN** tmux installation completes
- **THEN** the module SHALL automatically invoke `tmux::sync`

### Requirement: Tmux session management helpers
The module SHALL provide `ftm` (session switch/create) and `ftmk` (session kill) functions using fzf for fuzzy selection.

#### Scenario: ftm switches to existing session
- **WHEN** user runs `ftm` with a session name that exists
- **THEN** the system SHALL switch to that tmux session

#### Scenario: ftm creates new session
- **WHEN** user runs `ftm` with a session name that does not exist
- **THEN** the system SHALL create and attach to a new tmux session

#### Scenario: ftm fuzzy selection
- **WHEN** user runs `ftm` without arguments
- **THEN** the system SHALL display a fzf list of active tmux sessions

#### Scenario: ftmk kills session
- **WHEN** user runs `ftmk` with a session name
- **THEN** the system SHALL kill that tmux session
- **WHEN** user runs `ftmk` without arguments
- **THEN** the system SHALL display a fzf list of sessions to kill

### Requirement: Tmuxinator project launcher
The module SHALL provide `tx::project` to select a tmuxinator template via fzf and start a new project.

#### Scenario: Template selection with fzf
- **WHEN** user runs `tx::project`
- **THEN** the system SHALL list yml templates from `$HOME/.config/tmuxinator/templates/`
- **THEN** the system SHALL let the user select one via fzf
- **THEN** the system SHALL start tmuxinator with the selected template and project name

#### Scenario: Fallback when no templates
- **WHEN** no yml templates exist in the templates directory
- **THEN** the system SHALL warn the user and return 1

### Requirement: Tmux config editor
The module SHALL provide `edittmux` to open `~/.tmux.conf` in the user's `$EDITOR`.

#### Scenario: Open config in editor
- **WHEN** user runs `edittmux`
- **THEN** the system SHALL open `$TMUX_FILE_SETTINGS` in `$EDITOR`

### Requirement: OS-specific clipboard integration
The module SHALL configure platform-appropriate clipboard handling for tmux.

#### Scenario: macOS clipboard support
- **WHEN** the system runs on macOS
- **THEN** `reattach-to-user-namespace` SHALL be installed
- **THEN** tmux copy-mode SHALL pipe to `pbcopy` via `reattach-to-user-namespace`

#### Scenario: Linux clipboard support
- **WHEN** the system runs on Linux
- **THEN** tmux copy-mode SHALL use `xclip` (X11) or `wl-copy` (Wayland) for clipboard

### Requirement: Tmux alias
The module SHALL define `tx` as an alias for `tmuxinator` when available.

#### Scenario: Alias defined
- **WHEN** `core::exists tmuxinator` returns true
- **THEN** `tx` SHALL be an alias for `tmuxinator`

### Requirement: Platform support
The module SHALL support macOS (darwin), Arch Linux, and CachyOS.

#### Scenario: OS detection
- **WHEN** `$OSTYPE` is `darwin*`
- **THEN** macOS-specific config SHALL be loaded
- **WHEN** `$OSTYPE` is `linux*`
- **THEN** Linux-specific config SHALL be loaded