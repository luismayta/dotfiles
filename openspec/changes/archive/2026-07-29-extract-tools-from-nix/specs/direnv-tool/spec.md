## ADDED Requirements

### Requirement: Direnv tool follows three-layer architecture
The direnv tool SHALL follow the three-layer architecture defined in `docs/guides/implement-tool-in-module.md` with config variables (`config/`), internal implementation (`internal/`), and public API (`pkg/`), using the `DEVOPS_DIRENV_` prefix for variables and `devops::direnv::` prefix for functions.

#### Scenario: Config file exports DEVOPS_DIRENV variables
- **WHEN** `zsh/modules/devops/config/direnv.zsh` is sourced
- **THEN** `DEVOPS_DIRENV_PACKAGE_NAME` SHALL be exported
- **AND** `DEVOPS_DIRENV_NIX_DIRENV_PACKAGE` SHALL be exported
- **AND** `DEVOPS_DIRENV_DATA_PATH` SHALL be exported

#### Scenario: Internal file provides load, install, upgrade
- **WHEN** `zsh/modules/devops/internal/direnv.zsh` is sourced
- **THEN** `devops::direnv::internal::load` SHALL be defined
- **AND** `devops::direnv::internal::install` SHALL be defined
- **AND** `devops::direnv::internal::upgrade` SHALL be defined
- **AND** `devops::direnv::internal::main::factory` SHALL be defined

#### Scenario: Public file provides install, upgrade, sync
- **WHEN** `zsh/modules/devops/pkg/direnv.zsh` is sourced
- **THEN** `devops::direnv::install` SHALL be defined
- **AND** `devops::direnv::upgrade` SHALL be defined
- **AND** `devops::direnv::sync` SHALL be defined
- **AND** `devops::direnv::post_install` SHALL be defined

### Requirement: Direnv shell hook loads on startup
The `devops::direnv::internal::load` function SHALL evaluate the direnv zsh hook when direnv is installed, and SHALL use a core::exists guard to skip if direnv is missing.

#### Scenario: Shell hook evaluated when direnv installed
- **WHEN** `devops::direnv::internal::load` is called and `direnv` exists in PATH
- **THEN** `eval "$(direnv hook zsh)"` SHALL execute

#### Scenario: Guard skips when direnv not installed
- **WHEN** `devops::direnv::internal::load` is called and `direnv` does NOT exist in PATH
- **THEN** the function SHALL return without error

### Requirement: Nix-direnv plugin is managed by direnv tool
The direnv tool SHALL manage the nix-direnv plugin: install via `nix profile install`, and reference it in the direnvrc config file.

#### Scenario: Nix-direnv installs via nix profile
- **WHEN** `devops::direnv::internal::install` is called
- **THEN** `nix profile install nixpkgs#nix-direnv` SHALL be invoked if not already installed
- **AND** the function SHALL check `nix profile list` before installing

#### Scenario: Direnvrc is synced to home directory
- **WHEN** `devops::direnv::internal::sync` is called
- **THEN** rsync SHALL copy `data/direnv/direnvrc` to `~/.config/direnv/direnvrc`

### Requirement: Core direnv hook is removed
The file `zsh/system/core/internal/direnv.zsh` SHALL be removed. Its `core::internal::direnv::load` function SHALL be replaced by `devops::direnv::internal::load` in the new module.

#### Scenario: Core no longer owns direnv
- **WHEN** `zsh/system/core/internal/main.zsh` is sourced
- **THEN** it SHALL NOT source `internal/direnv.zsh`

### Requirement: Nix module direnv references are removed
The files `zsh/system/nix/internal/direnv.zsh` and `zsh/system/nix/data/sync/.config/direnv/direnvrc` SHALL be removed. The `nix::internal::direnv::setup` function SHALL be removed.

#### Scenario: Nix main no longer calls direnv setup
- **WHEN** `zsh/system/nix/internal/main.zsh` is sourced
- **THEN** it SHALL NOT source `internal/direnv.zsh`
- **AND** it SHALL NOT call `nix::internal::direnv::setup`

#### Scenario: Nix sync no longer includes direnvrc
- **WHEN** `nix::internal::config::sync` runs
- **THEN** it SHALL NOT copy `.config/direnv/direnvrc` to home directory
