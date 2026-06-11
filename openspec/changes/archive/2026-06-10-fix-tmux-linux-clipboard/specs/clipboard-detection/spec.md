## ADDED Requirements

### Requirement: Clipboard tool detection on Linux
The system SHALL detect the available clipboard tool on Linux using the priority order: `pbcopy` → `xclip` → `wl-copy`. The detection SHALL NOT produce any tmux argument parsing errors regardless of which tools are present or absent.

#### Scenario: pbcopy is available
- **WHEN** `pbcopy` is found in `$PATH`
- **THEN** the bind-key `y` in `copy-mode-vi` SHALL pipe the selection to `pbcopy`

#### Scenario: xclip is available (pbcopy absent)
- **WHEN** `pbcopy` is NOT found AND `xclip` is found in `$PATH`
- **THEN** the bind-key `y` in `copy-mode-vi` SHALL pipe the selection to `xclip -selection clipboard -in`

#### Scenario: wl-copy is available (pbcopy and xclip absent)
- **WHEN** `pbcopy` AND `xclip` are NOT found AND `wl-copy` is found in `$PATH`
- **THEN** the bind-key `y` in `copy-mode-vi` SHALL pipe the selection to `wl-copy`

#### Scenario: no clipboard tool available
- **WHEN** none of `pbcopy`, `xclip`, or `wl-copy` are found in `$PATH`
- **THEN** pressing `y` in `copy-mode-vi` SHALL display a message indicating no clipboard tool was found, WITHOUT producing a tmux "too many arguments" error