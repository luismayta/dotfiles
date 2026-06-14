## ADDED Requirements

### Requirement: Apps are organized by category
The system SHALL define categorized app lists as exported arrays. Each category SHALL have its own `APPS_<CATEGORY>` variable. All categories SHALL be combined into `APPS_PACKAGES`.

#### Scenario: Category lists exist
- **WHEN** the module loads
- **THEN** `APPS_IDE_TOOLS`, `APPS_JETBRAINS`, `APPS_COMMUNICATION`, `APPS_KNOWLEDGE`, `APPS_DEVOPS`, `APPS_DATABASE_CLIENTS`, `APPS_BROWSER`, `APPS_ANDROID`, `APPS_MOBILE`, `APPS_VPN_CLIENTS`, and `APPS_PROJECT_MANAGEMENT` SHALL be exported as arrays

#### Scenario: APPS_PACKAGES combines all categories
- **WHEN** the module loads
- **THEN** `APPS_PACKAGES` SHALL contain the concatenation of all category arrays

### Requirement: Module auto-installs apps on shell start
The system SHALL automatically install all apps in `APPS_PACKAGES` when the module loads, if they are not already present on the system.

#### Scenario: Missing app triggers install
- **WHEN** the module loads and an app from `APPS_PACKAGES` is not found in `$PATH`
- **THEN** `core::install` SHALL be called for that app

#### Scenario: Existing app is skipped
- **WHEN** the module loads and an app from `APPS_PACKAGES` is already in `$PATH`
- **THEN** the module SHALL skip installation for that app without error

### Requirement: Public API provides install and setup commands
The module SHALL expose `apps::packages::install` and `apps::setup` as public functions.

#### Scenario: apps::packages::install delegates to internal
- **WHEN** `apps::packages::install` is called
- **THEN** it SHALL delegate to `apps::internal::packages::install`, which iterates `APPS_PACKAGES` and calls `core::install` for each

#### Scenario: apps::setup orchestrates install + sync
- **WHEN** `apps::setup` is called
- **THEN** it SHALL check if apps are installed, install missing ones, sync config, and report success

### Requirement: OS platform paths are configurable
The system SHALL export platform-specific paths (`APPS_APPLICATION_PATH`, `APPS_ARCHITECTURE_NAME`) based on `OSTYPE`.

#### Scenario: macOS exports Application path
- **WHEN** `OSTYPE` is `darwin*`
- **THEN** `APPS_APPLICATION_PATH` SHALL be `/Applications` and `APPS_ARCHITECTURE_NAME` SHALL be `darwin-${ARCH_NAME}`

#### Scenario: Linux exports architecture name
- **WHEN** `OSTYPE` is `linux*`
- **THEN** `APPS_ARCHITECTURE_NAME` SHALL be `linux-${ARCH_NAME}`

### Requirement: Module follows three-layer architecture
The module SHALL follow the three-layer architecture from `docs/guides/create-module.md` with idempotent guard, OS dispatch in every layer, and all placeholder OS files present.

#### Scenario: Guard prevents double-loading
- **WHEN** `plugin.zsh` is sourced twice
- **THEN** the second source SHALL be a no-op due to `__ZSH_APPS_LOADED` guard

#### Scenario: All scaffold files exist
- **WHEN** examining `zsh/modules/apps/`
- **THEN** all 16 files from the guide's scaffold checklist SHALL exist, including OS placeholders

#### Scenario: OS files are sourced unconditionally
- **WHEN** the module loads on macOS
- **THEN** `config/osx.zsh`, `internal/osx.zsh`, and `pkg/osx.zsh` SHALL be sourced
- **WHEN** the module loads on Linux
- **THEN** `config/linux.zsh`, `internal/linux.zsh`, and `pkg/linux.zsh` SHALL be sourced
