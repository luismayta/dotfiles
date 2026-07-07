## ADDED Requirements

### Requirement: Cross-platform SSH connection with clipboard
The system SHALL provide a function `ssh::connect` that lists available SSH hosts via fzf and copies the selected `ssh <host>` command to the clipboard.

#### Scenario: macOS - copies ssh command to clipboard
- **WHEN** user invokes `ssh::connect` on macOS and selects a host "myserver" from the fzf list
- **THEN** the string "ssh myserver" SHALL be copied to the system clipboard via `pbcopy`

#### Scenario: Linux (X11) - copies ssh command to clipboard
- **WHEN** user invokes `ssh::connect` on Linux with X11 and selects a host "myserver" from the fzf list
- **THEN** the string "ssh myserver" SHALL be copied to the X11 clipboard via `xclip -selection clipboard`

#### Scenario: Linux (Wayland) - copies ssh command to clipboard
- **WHEN** user invokes `ssh::connect` on Linux under Wayland and selects a host from the fzf list
- **THEN** the string "ssh <host>" SHALL be copied to the clipboard via `wl-copy`

#### Scenario: No host selected
- **WHEN** user invokes `ssh::connect` and presses Escape in fzf without selecting a host
- **THEN** nothing SHALL be copied to the clipboard

#### Scenario: Ctrl-X s keybinding
- **WHEN** user presses Ctrl-X s in the zsh shell
- **THEN** the `ssh::connect` widget SHALL be invoked

### Requirement: fzf prompt for host selection
The system SHALL display an interactive fzf list of all SSH hosts parsed from `~/.ssh/config`.

#### Scenario: Hosts displayed in fzf
- **WHEN** user triggers `ssh::connect`
- **THEN** fzf SHALL display a list of host entries parsed from `~/.ssh/config`
