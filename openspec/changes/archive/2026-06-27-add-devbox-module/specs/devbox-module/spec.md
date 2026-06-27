## ADDED Requirements

### Requirement: Module auto-loads with idempotency guard

The module SHALL be loaded via `zsh/modules/devbox/plugin.zsh` with an idempotency guard `__ZSH_DEVBOX_LOADED` that prevents double-sourcing. The `plugin.zsh` SHALL source `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh` in that order.

#### Scenario: Module loads once
- **WHEN** `zsh/zshrc` sources `zsh/modules/devbox/plugin.zsh`
- **THEN** the idempotency guard `__ZSH_DEVBOX_LOADED` SHALL be set
- **AND** sourcing `plugin.zsh` a second time SHALL be a no-op

### Requirement: Pre-flight check for Nix

The module SHALL verify that `nix` is available in PATH before attempting to install or use Devbox. If Nix is not present, the module SHALL attempt to install it via `core::ensure nix` before proceeding.

#### Scenario: Nix is already installed
- **WHEN** `devbox::internal::devbox::install` is called
- **AND** `nix` is available in PATH
- **THEN** the module SHALL proceed with Devbox installation

#### Scenario: Nix is missing
- **WHEN** `devbox::internal::devbox::install` is called
- **AND** `nix` is not available
- **THEN** `core::ensure nix` SHALL be called first
- **AND** after Nix is installed, Devbox installation SHALL proceed

### Requirement: Installation via package manager

The module SHALL install Devbox using Homebrew on macOS (`brew install devbox`) and paru on Arch Linux (`paru -S --noconfirm devbox`). If no supported package manager is found, the module SHALL display a warning and exit gracefully.

#### Scenario: Install on macOS with Homebrew
- **WHEN** `core::ensure devbox` is called on macOS
- **AND** `brew` is available
- **THEN** `brew install devbox` SHALL be executed
- **AND** a success message SHALL be displayed after installation

#### Scenario: Install on Linux with paru
- **WHEN** `core::ensure devbox` is called on Linux with `paru` available
- **THEN** `paru -S --noconfirm devbox` SHALL be executed

#### Scenario: No supported package manager
- **WHEN** neither `brew` nor `paru` is available
- **THEN** a warning message SHALL be displayed
- **AND** the function SHALL return 1

### Requirement: Configuration via environment variables

The module SHALL export environment variables prefixed with `DEVBOX_*` for paths and package name in `config/base.zsh`.

#### Scenario: Environment variables are exported
- **WHEN** `config/base.zsh` is sourced
- **THEN** `DEVBOX_PACKAGE_NAME` SHALL be set to `devbox`
- **AND** `DEVBOX_DATA_PATH` SHALL point to `{module_path}/data`
- **AND** `DEVBOX_GLOBAL_CONFIG_PATH` SHALL be `~/.config/devbox/global`

### Requirement: Public API functions

The module SHALL provide the following public functions via `pkg/base.zsh`:

- `devbox::install` — installs or updates Devbox
- `devbox::sync` — syncs global Devbox configuration
- `devbox::shell` — opens a Devbox shell in the current directory (or specified path)
- `devbox::init` — initializes a Devbox project in the current directory

#### Scenario: devbox::install succeeds
- **WHEN** `devbox::install` is called
- **THEN** it SHALL delegate to `core::ensure devbox`

#### Scenario: devbox::shell opens environment
- **WHEN** `devbox::shell` is called
- **THEN** it SHALL execute `devbox shell` in the current directory

#### Scenario: devbox::init creates devbox.json
- **WHEN** `devbox::init` is called
- **THEN** it SHALL execute `devbox init` in the current directory
- **AND** a basic `devbox.json` SHALL be created

### Requirement: Shell aliases for common commands

If a `pkg/alias.zsh` file is present, it SHALL define shell aliases for common Devbox operations.

#### Scenario: Aliases are available
- **WHEN** the module is loaded
- **THEN** `devbox` SHALL be available as `dbx`

### Requirement: Configuration sync via rsync

The module SHALL sync its bundled configuration from `data/` to `~/.config/devbox/` when `devbox::sync` is called.

#### Scenario: Sync copies global config
- **WHEN** `devbox::sync` is called
- **THEN** `rsync -avh --no-perms` SHALL copy files from `DEVBOX_DATA_PATH` to `~/.config/devbox/`
- **AND** a success message SHALL be displayed
