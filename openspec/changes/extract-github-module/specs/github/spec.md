## ADDED Requirements

### Requirement: Module structure follows standard architecture
The `github` module SHALL have the standard 3-layer architecture with `plugin.zsh` entry point.

#### Scenario: Module directory structure
- **WHEN** the `github` module is created
- **THEN** it SHALL contain:
  - `plugin.zsh` as the entry point
  - `config/` directory with configuration files
  - `internal/` directory with internal functions
  - `pkg/` directory with public functions
  - `data/` directory for persistent data

### Requirement: Plugin entry point with guard
The `plugin.zsh` file SHALL implement the standard guard pattern.

#### Scenario: Guard variable prevents double-loading
- **WHEN** `plugin.zsh` is sourced
- **THEN** it SHALL check if `__ZSH_GITHUB_LOADED` is set
- **AND** if set, it SHALL return early without re-executing

#### Scenario: Guard variable set after loading
- **WHEN** `plugin.zsh` completes loading
- **THEN** it SHALL set `__ZSH_GITHUB_LOADED=1`

### Requirement: Module enable/disable toggle
The module SHALL support enable/disable via `ZSH_GITHUB_ENABLED`.

#### Scenario: Module disabled
- **WHEN** `ZSH_GITHUB_ENABLED` is set to `false` or `0`
- **THEN** `plugin.zsh` SHALL return early without loading the module

#### Scenario: Module enabled or unset
- **WHEN** `ZSH_GITHUB_ENABLED` is unset or set to `true`/`1`
- **THEN** `plugin.zsh` SHALL proceed with normal module loading

### Requirement: Standard path variables
The module SHALL define standard path variables with `ZSH_GITHUB_` prefix.

#### Scenario: Path variables defined
- **WHEN** the config layer loads
- **THEN** the following variables SHALL be set:
  - `ZSH_GITHUB_PACKAGE_NAME=gh`
  - `ZSH_GITHUB_CONF_PATH="${HOME}/.config/gh"`
  - `ZSH_GITHUB_DASH_CONF_PATH="${HOME}/.config/gh-dash"`
  - `ZSH_GITHUB_DATA_PATH="${ZSH_GITHUB_PATH}/data/gh"`

### Requirement: Internal function namespace
Internal functions SHALL use `github::internal::*` namespace.

#### Scenario: Factory function
- **WHEN** the internal layer loads
- **THEN** `github::internal::main::factory` SHALL call `core::ensure gh`

#### Scenario: Completions installation
- **WHEN** `github::internal::install_completions` is called
- **THEN** it SHALL run `gh completion -s zsh` and save to `${ZSH_GITHUB_DATA_PATH}/completions.zsh`

#### Scenario: Dash extension installation
- **WHEN** `github::internal::install_dash` is called
- **THEN** it SHALL run `gh extension install dlvhdr/gh-dash`

#### Scenario: Load completions
- **WHEN** `github::internal::load` is called
- **THEN** it SHALL source `${ZSH_GITHUB_DATA_PATH}/completions.zsh` if the file exists

### Requirement: Public function namespace
Public functions SHALL use `github::*` namespace.

#### Scenario: Install function
- **WHEN** `github::install` is called
- **THEN** it SHALL call `github::internal::main::factory`

#### Scenario: Upgrade function
- **WHEN** `github::upgrade` is called
- **THEN** it SHALL call `core::upgrade gh`

#### Scenario: Post-install function
- **WHEN** `github::post_install` is called
- **THEN** it SHALL call `github::sync` and display success message

#### Scenario: Sync function
- **WHEN** `github::sync` is called
- **THEN** it SHALL call `core::ensure rsync`
- **AND** it SHALL rsync `${ZSH_GITHUB_DATA_PATH}/` to `${ZSH_GITHUB_DASH_CONF_PATH}/`

### Requirement: User-facing aliases
The module SHALL provide user-facing aliases.

#### Scenario: ghd alias
- **WHEN** the module loads
- **THEN** `ghd` SHALL be aliased to `gh dash`

#### Scenario: editghdash function
- **WHEN** `editghdash` is called
- **THEN** it SHALL check if `EDITOR` is set
- **AND** if set, it SHALL open `${ZSH_GITHUB_DASH_CONF_PATH}/config.yaml` in `$EDITOR`
- **AND** if not set, it SHALL display a warning message

### Requirement: Auto-install on load
The module SHALL auto-install gh and extensions on first load.

#### Scenario: gh not installed
- **WHEN** the internal layer loads and `gh` is not found
- **THEN** `github::internal::main::factory` SHALL install gh

#### Scenario: gh installed but completions missing
- **WHEN** the internal layer loads and completions file doesn't exist
- **THEN** `github::internal::install_completions` SHALL be called

#### Scenario: gh-dash not installed
- **WHEN** the internal layer loads and `dlvhdr/gh-dash` extension is not installed
- **THEN** `github::internal::install_dash` SHALL be called

### Requirement: Data directory for gh-dash config
The module SHALL include a data directory with default gh-dash configuration.

#### Scenario: Default gh-dash config
- **WHEN** the module is first installed
- **THEN** `${ZSH_GITHUB_DATA_PATH}/config.yaml` SHALL contain default PR, issues, and repos sections
