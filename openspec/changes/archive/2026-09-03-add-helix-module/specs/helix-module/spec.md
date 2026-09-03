## Purpose

Provides a ZSH module that installs the Helix editor binary, syncs its configuration (config.toml, languages.toml, themes/) from data/ to ~/.config/helix/, and manages the Helix runtime, following the three-layer dotfiles module architecture.

## ADDED Requirements

### Requirement: Module loads without errors
The helix module SHALL load cleanly via plugin.zsh without producing errors or warnings.

#### Scenario: Plugin sources all layers
- **WHEN** zsh sources `zsh/modules/helix/plugin.zsh`
- **THEN** config/main.zsh, internal/main.zsh, and pkg/main.zsh are sourced in order
- **THEN** no error or warning is emitted

#### Scenario: Guard prevents double-loading
- **WHEN** plugin.zsh is sourced a second time
- **THEN** `__ZSH_HELIX_LOADED` guard returns 0 and skips all layers

### Requirement: Config layer defines environment variables
The config layer SHALL export `ZSH_HELIX_ENABLED`, `ZSH_HELIX_PACKAGE_NAME`, `ZSH_HELIX_CONFIG_PATH`, and `ZSH_HELIX_DATA_PATH` with sensible defaults.

#### Scenario: Default variables are exported
- **WHEN** config/base.zsh is sourced
- **THEN** `ZSH_HELIX_ENABLED` is set to a truthy value
- **THEN** `ZSH_HELIX_PACKAGE_NAME` equals `helix`
- **THEN** `ZSH_HELIX_CONFIG_PATH` equals `$HOME/.config/helix`
- **THEN** `ZSH_HELIX_DATA_PATH` equals the absolute path of `zsh/modules/helix/data`

#### Scenario: OS dispatch picks correct overrides
- **WHEN** OSTYPE is `darwin*`
- **THEN** config/osx.zsh is sourced
- **WHEN** OSTYPE is `linux*`
- **THEN** config/linux.zsh is sourced

### Requirement: Data directory contains Helix configuration
The module SHALL include a `data/` directory with real Helix configuration files synced to `~/.config/helix/`.

#### Scenario: Data directory has config files
- **WHEN** `zsh/modules/helix/data/` is listed
- **THEN** `config.toml` exists
- **THEN** `languages.toml` exists
- **THEN** `themes/` directory exists

### Requirement: Internal layer installs Helix
The internal layer SHALL provide `helix::internal::install` that installs the Helix binary (`hx`) when it is not present.

#### Scenario: Install runs when hx is missing
- **WHEN** `core::exists hx` returns false
- **WHEN** `helix::internal::install` is called
- **THEN** the Helix binary is installed
- **THEN** a success message is displayed

### Requirement: Internal layer syncs Helix configuration
The internal layer SHALL provide `helix::internal::sync` that copies `data/` to `ZSH_HELIX_CONFIG_PATH` via rsync.

#### Scenario: Sync copies files from data/ to config path
- **WHEN** `helix::internal::sync` is called
- **THEN** `rsync` is executed from `$ZSH_HELIX_DATA_PATH/` to `$ZSH_HELIX_CONFIG_PATH/`
- **THEN** a success message is displayed

#### Scenario: Sync creates config directory if missing
- **WHEN** ZSH_HELIX_CONFIG_PATH does not exist
- **WHEN** `helix::internal::sync` is called
- **THEN** the directory is created
- **THEN** files are synced successfully

### Requirement: Internal layer manages Helix runtime
The internal layer SHALL provide a function that fetches and builds Helix language grammars via `hx --grammar fetch/build`.

#### Scenario: Runtime grammars are fetched and built
- **WHEN** the runtime management function is called
- **THEN** `hx --grammar fetch` is executed
- **THEN** `hx --grammar build` is executed

### Requirement: Pkg layer provides public API
The pkg layer SHALL expose `helix::install`, `helix::sync`, and `helix::post_install` as public wrappers.

#### Scenario: Public install delegates to internal
- **WHEN** `helix::install` is called
- **THEN** `helix::internal::install` is invoked

#### Scenario: Public sync delegates to internal
- **WHEN** `helix::sync` is called
- **THEN** `helix::internal::sync` is invoked

#### Scenario: Public post_install runs runtime management
- **WHEN** `helix::post_install` is called
- **THEN** the runtime grammar fetch/build is executed

### Requirement: Helper setup orchestrates module
The pkg layer SHALL provide `helix::setup` that orchestrates install, sync, and runtime management.

#### Scenario: Setup runs install and sync
- **WHEN** `helix::setup` is called
- **THEN** `helix::install` is invoked
- **THEN** `helix::sync` is invoked

### Requirement: Module reuses core functions
The module SHALL use `message_*`, `core::exists`, and `core::ensure` from `zsh/system/core/` and SHALL NOT use `echo`, `which`, or `command -v`.

#### Scenario: Core functions are used for messaging and checks
- **WHEN** the module emits messages or checks for binaries
- **THEN** `message_info`/`message_success`/`message_error` are used for output
- **THEN** `core::exists`/`core::ensure` are used for binary checks

### Requirement: Module registers readme task
The module SHALL include a `README.yaml` and a `Taskfile.yml` with a `readme` task, registered in the root `Taskfile.yml` as `module-helix`.

#### Scenario: Readme task is registered
- **WHEN** the root `Taskfile.yml` is inspected
- **THEN** a `module-helix` taskfile entry exists
- **WHEN** the module `Taskfile.yml` is inspected
- **THEN** a `readme` task exists that generates `README.md` from `README.yaml`
