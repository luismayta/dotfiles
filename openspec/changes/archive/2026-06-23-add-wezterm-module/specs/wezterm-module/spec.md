## ADDED Requirements

### Requirement: Module loads idempotently
The wezterm ZSH module SHALL load exactly once per shell session regardless of how many times `plugin.zsh` is sourced.

#### Scenario: First source loads the module
- **WHEN** `source zsh/modules/wezterm/plugin.zsh` is called
- **THEN** the module SHALL initialize and print a loading message

#### Scenario: Second source is a no-op
- **WHEN** `source zsh/modules/wezterm/plugin.zsh` is called a second time
- **THEN** the module SHALL NOT reinitialize (guard variable prevents double-loading)

### Requirement: Module exposes public API
The module SHALL expose `wezterm::install`, `wezterm::sync`, and `wezterm::setup` as shell-callable functions.

#### Scenario: Functions are available after loading
- **WHEN** the module is loaded
- **THEN** `type wezterm::install` SHALL return "function"
- **AND** `type wezterm::sync` SHALL return "function"
- **AND** `type wezterm::setup` SHALL return "function"

### Requirement: Config sync copies data to config path
The module SHALL sync configuration files from its `data/` directory to `~/.config/wezterm/` using rsync.

#### Scenario: Sync copies all files
- **WHEN** `wezterm::sync` is called
- **THEN** all files from `ZSH_WEZTERM_DATA_PATH/` SHALL be copied to `~/.config/wezterm/`
- **AND** the Lua config entrypoint `wezterm.lua` SHALL exist at the target

#### Scenario: Sync uses rsync with no-perms
- **WHEN** `wezterm::sync` is called
- **THEN** rsync SHALL be invoked with `-avh --no-perms` flags

### Requirement: Auto-install wezterm if missing
The module SHALL attempt to install wezterm when it is not found on the system.

#### Scenario: Install on missing binary
- **WHEN** the module loads and `wezterm` is not in PATH
- **THEN** `wezterm::internal::install` SHALL be called
- **AND** the install SHALL delegate to `core::install wezterm`

#### Scenario: Skip install if already present
- **WHEN** the module loads and `wezterm` IS in PATH
- **THEN** no installation SHALL occur

### Requirement: Setup orchestrates install and sync
The `wezterm::setup` function SHALL ensure wezterm is installed and config is synced.

#### Scenario: Setup with missing binary
- **WHEN** `wezterm::setup` is called and wezterm is not installed
- **THEN** it SHALL call `wezterm::install`
- **AND** it SHALL call `wezterm::sync`
- **AND** it SHALL report success

#### Scenario: Setup with existing binary
- **WHEN** `wezterm::setup` is called and wezterm IS installed
- **THEN** it SHALL skip installation
- **AND** it SHALL still call `wezterm::sync`

### Requirement: editwezterm alias opens module data in VS Code
The module SHALL provide an `editwezterm` shell function that opens the module's data path in VS Code.

#### Scenario: editwezterm opens code editor
- **WHEN** `editwezterm` is called
- **THEN** VS Code SHALL open at `ZSH_WEZTERM_PATH/data`
