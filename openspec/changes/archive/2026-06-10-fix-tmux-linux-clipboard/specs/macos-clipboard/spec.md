## MODIFIED Requirements

### Requirement: macOS clipboard integration
The system SHALL integrate tmux clipboard with the macOS system clipboard using `pbcopy`/`pbpaste`. The configuration SHALL NOT use `default-command` with `reattach-to-user-namespace` as a workaround, as tmux 3.5a handles pbcopy/pbpaste natively.

#### Scenario: Copy text in vi copy-mode
- **WHEN** user presses `y` in `copy-mode-vi`
- **THEN** the selected text SHALL be piped to `pbcopy` via `copy-pipe-and-cancel`

#### Scenario: Paste from system clipboard
- **WHEN** user presses `prefix + C-v`
- **THEN** the system clipboard content SHALL be loaded into tmux buffer and pasted

#### Scenario: No `reattach-to-user-namespace` dependency
- **WHEN** tmux loads the config on a system without `reattach-to-user-namespace` installed
- **THEN** clipboard copy/paste SHALL still work as long as pbcopy/pbpaste are available

#### Scenario: `set-clipboard` behavior
- **WHEN** tmux loads the config
- **THEN** `set-clipboard` SHALL be set to `external` to allow OSC 52 clipboard passthrough while keeping manual pbcopy integration