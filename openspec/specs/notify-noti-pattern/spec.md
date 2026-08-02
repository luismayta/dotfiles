# notify-noti-pattern

## Purpose

Define the canonical structure of the notify module for the noti notification tool: a three-layer architecture (config, internal, pkg) with install guards, thin public wrappers, standardized naming conventions, and an auto-install flow in the plugin loader.

## Requirements

### Requirement: Config layer follows three-layer architecture

The notify module SHALL separate configuration variables into dedicated domain files under config/.

#### Scenario: Config directory structure
- **WHEN** a developer reads the config directory
- **THEN** the module SHALL have `config/base.zsh` as dispatcher and `config/noti.zsh` for noti-specific variables

#### Scenario: Config variables isolation
- **WHEN** noti variables are defined
- **THEN** they SHALL be in `config/noti.zsh` with prefix `ZSH_NOTIFY_NOTI_*`

### Requirement: Internal layer has install function with guard pattern

The internal layer SHALL provide an install function that checks tool existence before proceeding.

#### Scenario: Install function exists
- **WHEN** a developer reads internal/noti.zsh
- **THEN** it SHALL contain `notify::noti::internal::install` function

#### Scenario: Guard pattern is applied
- **WHEN** `notify::noti::internal::install` is called
- **THEN** it SHALL check `core::exists noti` first and return 0 if already installed

#### Scenario: Install uses core::install
- **WHEN** noti is not installed
- **THEN** the function SHALL call `core::install "${ZSH_NOTIFY_NOTI_PACKAGE_NAME}"`

### Requirement: Pkg layer provides thin wrappers

The pkg layer SHALL expose public API functions that delegate to internal implementations.

#### Scenario: Public wrapper exists
- **WHEN** a developer reads pkg/noti.zsh
- **THEN** it SHALL contain `notify::noti::install` that calls `notify::noti::internal::install`

#### Scenario: Public send function exists
- **WHEN** a developer reads pkg/noti.zsh
- **THEN** it SHALL contain `notify::noti::send` that calls `notify::noti::internal::send`

### Requirement: Naming follows module conventions

All functions SHALL follow the naming pattern `notify::noti::<verb>` for public and `notify::noti::internal::<verb>` for internal.

#### Scenario: Function naming convention
- **WHEN** a new function is created
- **THEN** it SHALL follow the pattern `notify::noti::internal::<verb>` (internal) or `notify::noti::<verb>` (public)

### Requirement: Plugin loader has auto-install guard

The plugin.zsh SHALL auto-install noti when enabled and not present.

#### Scenario: Auto-install on load
- **WHEN** `ZSH_NOTIFY_NOTI_ENABLED` is "true" and noti is not installed
- **THEN** plugin.zsh SHALL call `core::install "${ZSH_NOTIFY_NOTI_PACKAGE_NAME}"`

#### Scenario: Config generation on load
- **WHEN** noti is enabled and config file doesn't exist
- **THEN** plugin.zsh SHALL call `notify::noti::internal::config`
