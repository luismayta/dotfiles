## ADDED Requirements

### Requirement: OS-specific clipboard helpers on Linux

The system SHALL install clipboard utilities on Linux when herdr detects it's running inside a terminal multiplexer.

#### Scenario: Install xclip on Linux (X11)
- **WHEN** system is Linux with X11
- **THEN** system SHALL ensure `xclip` is available for clipboard integration
- **THEN** IF not present, system SHALL attempt installation via `core::install`

#### Scenario: Install wl-clipboard on Linux (Wayland)
- **WHEN** system is Linux with Wayland (`$WAYLAND_DISPLAY` is set)
- **THEN** system SHALL ensure `wl-copy`/`wl-paste` are available
- **THEN** IF not present, system SHALL attempt installation via `core::install`

### Requirement: OS-specific clipboard helpers on macOS

The system SHALL ensure clipboard helpers work inside herdr on macOS.

#### Scenario: Install reattach-to-user-namespace on macOS
- **WHEN** system is macOS (`uname -s` = Darwin)
- **THEN** system SHALL ensure `reattach-to-user-namespace` is installed
- **THEN** IF not present, system SHALL install via `core::install`

### Requirement: Module auto-installs OS tools on load

The system SHALL check and install OS-specific tools during module load, following the pattern in `tmux::internal::osx`.

#### Scenario: Auto-install on module load
- **WHEN** the herdr module loads
- **THEN** system SHALL detect the current OS
- **THEN** system SHALL check for required OS-specific tools
- **THEN** IF any tool is missing, system SHALL auto-install it
