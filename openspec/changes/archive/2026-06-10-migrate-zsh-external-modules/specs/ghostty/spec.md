## ADDED Requirements

### Requirement: Ghostty terminal support
The Ghostty module SHALL provide terminal emulator configuration management for macOS and Linux.

#### Scenario: Module loads on zsh start
- **WHEN** zsh starts and sources `zsh/modules/ghostty/plugin.zsh`
- **THEN** the module SHALL set `GHOSTTY_PATH` and SHALL source `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh`
- **THEN** the module SHALL define `__ZSH_GHOSTTY_LOADED=1` to prevent double-loading

#### Scenario: Environment variables are set
- **WHEN** the module loads on macOS
- **THEN** `GHOSTTY_APPLICATION` SHALL be `/Applications/Ghostty.app`
- **WHEN** the module loads on Linux
- **THEN** `GHOSTTY_APPLICATION` SHALL NOT be set (remains unconfigured)
- **WHEN** the module loads on any OS
- **THEN** `GHOSTTY_PACKAGE_NAME` SHALL be `ghostty`
- **AND** `GHOSTTY_CONF_DIR` SHALL be `$GHOSTTY_PATH/conf`
- **AND** `GHOSTTY_FILE_SETTINGS` SHALL be `$GHOSTTY_CONF_DIR/config`
- **AND** `GHOSTTY_THEMES_DIR` SHALL be `$GHOSTTY_CONF_DIR/themes`

#### Scenario: Config sync via ghostty::sync
- **WHEN** user runs `ghostty::sync`
- **THEN** the module SHALL rsync `$GHOSTTY_CONF_DIR/` to `~/.config/ghostty/`
- **AND** SHALL ensure `~/.config/ghostty/themes` exists

#### Scenario: Ghostty installation via ghostty::install
- **WHEN** user runs `ghostty::install`
- **THEN** the module SHALL install Ghostty using the OS package manager (brew on macOS)

#### Scenario: Config editing via editghostty
- **WHEN** user runs `editghostty`
- **THEN** the module SHALL open `$GHOSTTY_FILE_SETTINGS` in `$EDITOR`

#### Scenario: Auto-install on missing Ghostty
- **WHEN** the module loads and `ghostty` binary is not found
- **THEN** the module SHALL call `ghostty::install` automatically