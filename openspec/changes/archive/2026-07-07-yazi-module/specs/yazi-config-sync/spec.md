## ADDED Requirements

### Requirement: Sync managed yazi config from data/ to ~/.config/yazi/

The system SHALL synchronize yazi configuration files from the module's `data/` directory to `~/.config/yazi/` using rsync when invoked.

#### Scenario: Config sync with data directory present
- **WHEN** `yazi::internal::config::sync` is called and `data/` contains files
- **THEN** the system runs `rsync -avzh "$ZSH_YAZI_DATA_PATH/" "$ZSH_YAZI_CONFIG_PATH/"`
- **AND** displays a success message on completion

#### Scenario: Config sync with empty data directory
- **WHEN** `yazi::internal::config::sync` is called and `data/` directory is empty or missing
- **THEN** the system displays an info message that no config data is available
- **AND** returns 0 without running rsync

#### Scenario: Config destination directory does not exist
- **WHEN** `~/.config/yazi/` does not exist during sync
- **THEN** the system creates the directory before running rsync

### Requirement: Provide yazi::sync public function

The system SHALL expose `yazi::sync()` as a public function that delegates to `yazi::internal::config::sync`.

#### Scenario: User runs yazi::sync
- **WHEN** user runs `yazi::sync`
- **THEN** the function calls `yazi::internal::config::sync`

### Requirement: Post-install sync

The system SHALL run config sync after successful installation as part of `yazi::post_install()`.

#### Scenario: Post install runs config sync
- **WHEN** `yazi::post_install` is called
- **THEN** the function runs `yazi::sync`
- **AND** displays success message
