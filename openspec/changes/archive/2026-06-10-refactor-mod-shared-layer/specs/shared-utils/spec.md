## ADDED Requirements

### Requirement: Editor helper functions
The shared utils layer SHALL provide editor-related helper functions sourced via the direct-sourcing chain in `zsh/core/internal/main.zsh`.

#### Scenario: editrc opens .zshrc in editor
- **WHEN** `editrc` is called without arguments
- **THEN** it SHALL open `${HOME}/.zshrc` in the current `$EDITOR`

#### Scenario: editrc opens core file with argument
- **WHEN** `editrc aliases` is called
- **THEN** it SHALL open `${DOTFILES_CORE_DIR}/aliases.zsh` in the current `$EDITOR`

#### Scenario: editprivaterc opens privaterc
- **WHEN** `editprivaterc` is called and `$PRIVATERC` is set
- **THEN** it SHALL open the file at `$PRIVATERC` in the current `$EDITOR`

#### Scenario: editprivaterc warns if not set
- **WHEN** `editprivaterc` is called and `$PRIVATERC` is not set
- **THEN** it SHALL display a warning via `message_info`

#### Scenario: editcustomrc opens customrc
- **WHEN** `editcustomrc` is called and `$CUSTOMRC` is set
- **THEN** it SHALL open the file at `$CUSTOMRC` in the current `$EDITOR`

### Requirement: Shell reload function
The shared utils layer SHALL provide a `reload` function that restarts the shell.

#### Scenario: reload restarts shell
- **WHEN** `reload` is called on macOS
- **THEN** it SHALL execute `exec "${SHELL}" -l`

### Requirement: Backup function
The shared utils layer SHALL provide a `backup` function for timestamped file backups.

#### Scenario: backup creates timestamped copy
- **WHEN** `backup ~/.zshrc` is called and `$DOTFILES_BACKUP_DIR` exists
- **THEN** it SHALL create a copy of `~/.zshrc` at `${DOTFILES_BACKUP_DIR}/<YYYYMMDD>/.zshrc`

#### Scenario: backup warns if no argument
- **WHEN** `backup` is called without arguments
- **THEN** it SHALL display a warning via `message_info`