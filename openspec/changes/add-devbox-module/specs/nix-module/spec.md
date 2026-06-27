## ADDED Requirements

Nota: La instalación real de Nix reside en el core (`zsh/core/internal/nix.zsh`). El módulo nix mantiene la estructura de delegación estándar (internal → core).

### Requirement: Module auto-loads with idempotency guard

The module SHALL be loaded via `zsh/modules/nix/plugin.zsh` with an idempotency guard `__ZSH_NIX_LOADED` that prevents double-sourcing. The `plugin.zsh` SHALL source `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh` in that order.

#### Scenario: Module loads once
- **WHEN** `zsh/zshrc` sources `zsh/modules/nix/plugin.zsh`
- **THEN** the idempotency guard `__ZSH_NIX_LOADED` SHALL be set
- **AND** sourcing `plugin.zsh` a second time SHALL be a no-op

### Requirement: Delegación de instalación al core

El módulo nix debe delegar la instalación de Nix al core via `core::nix::ensure`. Si Nix no está presente, `nix::internal::nix::install` llama a `core::nix::ensure` que ejecuta el script oficial de Nix con `--no-daemon`.

#### Installation flow
- **GIVEN** Nix no está instalado
- **WHEN** el módulo nix se carga
- **THEN** nix::internal::nix::install invoca core::nix::ensure
- **AND** core::internal::nix::install ejecuta el script oficial de Nix con --no-daemon
- **AND** nix está disponible en el sistema

### Requirement: Channel management

The module SHALL provide functions to add and switch between Nix channels, specifically `nixpkgs-stable` and `nixpkgs-unstable`.

#### Scenario: Set channel to unstable
- **WHEN** `nix::channel::set nixpkgs-unstable` is called
- **THEN** `nix-channel --add https://nixos.org/channels/nixpkgs-unstable` SHALL be executed
- **AND** `nix-channel --update` SHALL be executed
- **AND** a success message SHALL confirm the channel change

#### Scenario: Set channel to stable
- **WHEN** `nix::channel::set nixpkgs-stable` is called
- **THEN** `nix-channel --add https://nixos.org/channels/nixpkgs-stable` SHALL be executed
- **AND** `nix-channel --update` SHALL be executed

#### Scenario: List active channels
- **WHEN** `nix::channel::list` is called
- **THEN** it SHALL display the output of `nix-channel --list`

### Requirement: Garbage collection

The module SHALL trigger Nix garbage collection to remove unused store paths and free disk space.

#### Scenario: Run garbage collector
- **WHEN** `nix::gc` is called
- **THEN** `nix-collect-garbage -d` SHALL be executed
- **AND** a success message SHALL display the freed space

### Requirement: Configuration via environment variables

The module SHALL export environment variables prefixed with `NIX_*` for paths and configuration in `config/base.zsh`.

#### Scenario: Environment variables are exported
- **WHEN** `config/base.zsh` is sourced
- **THEN** `NIX_PACKAGE_NAME` SHALL be set to `nix`
- **AND** `NIX_INSTALL_URL` SHALL point to `https://nixos.org/nix/install`
- **AND** `NIX_CONF_DIR` SHALL be `~/.config/nix`

### Requirement: Public API functions

The module SHALL provide the following public functions via `pkg/base.zsh`:
- `nix::install` — installs Nix via official script
- `nix::channel::set <channel>` — switches Nix channel
- `nix::channel::list` — lists active channels
- `nix::gc` — runs garbage collector

#### Scenario: nix::install succeeds
- **WHEN** `nix::install` is called
- **THEN** it SHALL delegate to `core::ensure nix`

#### Scenario: nix::gc succeeds
- **WHEN** `nix::gc` is called
- **THEN** it SHALL execute `nix-collect-garbage -d`
