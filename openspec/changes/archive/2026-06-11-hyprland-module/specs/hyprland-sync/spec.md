## ADDED Requirements

### Requirement: Config sync from data/
The module SHALL sync files from `data/` to the user's Hyprland config directory.

#### Scenario: Sync config files to ~/.config/
- **WHEN** `hyprland::sync` is called
- **THEN** it SHALL rsync `$HYPRLAND_PATH/data/` to `$HOME/.config/`
- **THEN** all Lua config files under `data/hypr/` SHALL be placed in `~/.config/hypr/`
- **THEN** rsync SHALL use `-avzh --progress` flags (preserve permissions, verbose, compress, human-readable, progress)

### Requirement: Sync is idempotent
The module SHALL ensure sync can be run multiple times safely.

#### Scenario: Idempotent sync
- **WHEN** `hyprland::sync` is called multiple times
- **THEN** it SHALL produce the same result each time
- **THEN** it SHALL NOT duplicate config files
- **THEN** it SHALL NOT remove unrelated files in the target directory

### Requirement: Backward compatibility with manual configs
The module SHALL NOT overwrite existing user configs without notice.

#### Scenario: Preserve manual changes
- **WHEN** a config file was manually edited and sync runs
- **THEN** rsync SHALL update the file (union of module + user edits is not expected; user edits SHALL be overwritten by module defaults)
- **THEN** a backup of the previous file SHALL be created if `--backup` is configured