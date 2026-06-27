## ADDED Requirements

### Requirement: Backup sync command
The system SHALL provide a shell command `nvim::backup` that synchronizes Neovim config from `~/.config/nvim/` back to the `data/` directory.

#### Scenario: Backup syncs config directory to data source
- **WHEN** `nvim::backup` is executed
- **THEN** it SHALL run `rsync -avzh --progress "$NVIM_CONFIG_PATH/" "$NVIM_PATH/data/"`
- **THEN** it SHALL print a summary of files copied

#### Scenario: Dry-run mode shows what would change
- **WHEN** `nvim::backup --dry-run` is executed
- **THEN** it SHALL run `rsync -avzh --dry-run "$NVIM_CONFIG_PATH/" "$NVIM_PATH/data/"`
- **THEN** it SHALL print what files would be copied without making changes

#### Scenario: Excludes non-config files from sync
- **WHEN** `nvim::backup` is executed
- **THEN** it SHALL exclude `.git/`, `node_modules/`, `.lazy/`, and `.cache/` directories

### Requirement: Enhanced install command
The system SHALL differentiate `nvim::install` from `nvim::sync` by running Mason and Lazy post-install steps.

#### Scenario: Install runs sync then installs Mason packages
- **WHEN** `nvim::install` is executed
- **THEN** it SHALL first run sync
- **THEN** it SHALL run `nvim --headless -c "MasonInstall" -c "qall"` to ensure all tools are installed

#### Scenario: Upgrade runs sync then updates plugins
- **WHEN** `nvim::upgrade` is executed
- **THEN** it SHALL first run sync
- **THEN** it SHALL run `nvim --headless -c "Lazy! sync" -c "qall"` to update all plugins
