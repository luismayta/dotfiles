## ADDED Requirements

### Requirement: PATH manipulation utilities
The shared paths layer SHALL provide functions for appending, prepending, and cleaning PATH entries. These SHALL be defined in `zsh/core/internal/path.zsh` and sourced via the direct-sourcing chain in `internal/main.zsh`.

#### Scenario: path::append adds directory to PATH
- **WHEN** `path::append /usr/local/custom` is called and `/usr/local/custom` exists
- **THEN** `/usr/local/custom` SHALL be appended to the `PATH` environment variable

#### Scenario: path::append skips non-existent directory
- **WHEN** `path::append /nonexistent/path` is called and the path does not exist
- **THEN** the PATH SHALL remain unchanged

#### Scenario: path::prepend adds directory to PATH front
- **WHEN** `path::prepend /usr/local/custom` is called and `/usr/local/custom` exists
- **THEN** `/usr/local/custom` SHALL be prepended to the beginning of `PATH`

#### Scenario: path::clean deduplicates entries
- **WHEN** `path::clean "/usr/bin:/usr/bin:/usr/local/bin"` is called
- **THEN** the output SHALL be `/usr/bin:/usr/local/bin` (duplicates removed)

### Requirement: Standard directory variables
The shared paths layer SHALL export standard directory environment variables in `zsh/core/config/paths.zsh`:
- `DOTFILES_BACKUP_DIR` set to `${HOME}/.backup`
- `DOTFILES_CACHE_DIR` set to `${HOME}/.cache/dotfiles`
- `LOCAL_PATH_BIN` set to `${HOME}/.local/bin`
- `HOMEBREW_BIN_PATH` set to `/opt/homebrew/bin`
- `PRIVATERC` set to `${HOME}/.privaterc`
- `CUSTOMRC` set to `${HOME}/.customrc`

#### Scenario: Standard dirs are exported on shell start
- **WHEN** `zsh/core/config/paths.zsh` is sourced
- **THEN** `DOTFILES_BACKUP_DIR`, `DOTFILES_CACHE_DIR`, `LOCAL_PATH_BIN`, `HOMEBREW_BIN_PATH`, `PRIVATERC`, and `CUSTOMRC` SHALL be exported as environment variables
