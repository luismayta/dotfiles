## ADDED Requirements

### Requirement: Symlink Zed configuration
The system SHALL create symbolic links for `settings.jsonc` and `keymap.jsonc` from the module's resources to `~/.config/zed/`.

#### Scenario: Symlink settings.json
- **WHEN** `zed::config::symlink` is called and `resources/settings.jsonc` exists
- **THEN** the system creates a symlink at `~/.config/zed/settings.json` pointing to `resources/settings.jsonc`

#### Scenario: Symlink keymap.json
- **WHEN** `zed::config::symlink` is called and `resources/keymap.jsonc` exists
- **THEN** the system creates a symlink at `~/.config/zed/keymap.json` pointing to `resources/keymap.jsonc`

#### Scenario: Config directory does not exist
- **WHEN** `zed::config::symlink` is called and `~/.config/zed/` does not exist
- **THEN** the system creates the directory before creating symlinks

### Requirement: Copy Zed configuration
The system SHALL copy `settings.jsonc` and `keymap.jsonc` files to `~/.config/zed/`.

#### Scenario: Copy settings.json
- **WHEN** `zed::config::copy` is called and `resources/settings.jsonc` exists
- **THEN** the system copies the file to `~/.config/zed/settings.json`

#### Scenario: Copy keymap.json
- **WHEN** `zed::config::copy` is called and `resources/keymap.jsonc` exists
- **THEN** the system copies the file to `~/.config/zed/keymap.json`

### Requirement: Sync Zed configuration via rsync
The system SHALL synchronize all configuration files from `resources/` to `~/.config/zed/` using rsync.

#### Scenario: Sync all config files
- **WHEN** `zed::config::sync` is called
- **THEN** the system runs `rsync -av` from the module's resources to `~/.config/zed/`
- **THEN** `.DS_Store` files are excluded from the sync
