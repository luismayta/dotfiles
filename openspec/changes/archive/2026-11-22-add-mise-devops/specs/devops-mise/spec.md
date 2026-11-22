# Spec Delta

## Purpose

Integrates `mise` (https://mise.jdx.dev/), an asdf-compatible tool version manager, as a first-class tool of the devops module: nix-first installation with native fallback, zsh activation on shell load, and the standard public lifecycle API.

## ADDED Requirements

### Requirement: mise installation prefers nix with native fallback

The devops module SHALL install `mise` when the binary is missing, preferring the nix package `nixpkgs#mise` and falling back to the native package manager when nix is unavailable.

#### Scenario: Binary already present skips install
- **WHEN** `devops::mise::internal::main::factory` is called
- **AND** the `mise` binary is found via `core::exists mise`
- **THEN** the module SHALL skip installation

#### Scenario: nix available installs via nix
- **WHEN** installation runs
- **AND** the `mise` binary is missing
- **AND** `nix` is available in PATH
- **THEN** the module SHALL install `mise` through `core::nix::package::install` using `nixpkgs#mise`

#### Scenario: nix absent falls back to native install
- **WHEN** installation runs
- **AND** the `mise` binary is missing
- **AND** `nix` is not available in PATH
- **THEN** the module SHALL install with `core::install "${DEVOPS_MISE_PACKAGE_NAME}"`

#### Scenario: nix-darwin manages the machine
- **WHEN** installation runs
- **AND** `ZSH_NIX_DARWIN_AVAILABLE` is `"true"`
- **THEN** the module SHALL skip the user-profile install and SHALL warn that nix-darwin manages `mise`

### Requirement: mise zsh shell activation

The devops module SHALL activate mise's zsh shell integration during module load, only when the `mise` binary exists.

#### Scenario: Activation executed when binary exists
- **WHEN** the devops module loads
- **AND** the `mise` binary exists
- **THEN** the module SHALL run `eval "$(mise activate zsh ...)"` passing any flags from `DEVOPS_MISE_INIT_FLAGS`

#### Scenario: No activation when binary is missing
- **WHEN** the devops module loads
- **AND** the `mise` binary does not exist
- **THEN** the module SHALL NOT execute `mise activate zsh`

#### Scenario: Custom activation flags
- **WHEN** `DEVOPS_MISE_INIT_FLAGS` is set to `("--shims")`
- **THEN** shell activation SHALL pass those flags to `mise activate zsh`

### Requirement: mise lifecycle API

The devops module SHALL expose the public functions `devops::mise::install`, `devops::mise::upgrade`, and `devops::mise::post_install`, delegating to the internal layer.

#### Scenario: Install ensures mise is present
- **WHEN** `devops::mise::install` is called
- **THEN** it SHALL delegate to the internal install path so `mise` is installed when missing and reported as already installed otherwise

#### Scenario: Upgrade upgrades mise
- **WHEN** `devops::mise::upgrade` is called
- **THEN** the module SHALL upgrade the installed `mise` package and report success

#### Scenario: Post-install prints first-steps guidance
- **WHEN** `devops::mise::post_install` is called
- **THEN** it SHALL print guidance that includes running `mise use node@latest`

### Requirement: mise configuration variables

The devops module SHALL declare mise configuration in `config/mise.zsh` as variable exports only, with no installation logic.

#### Scenario: Config variables are exported
- **WHEN** the devops config layer loads
- **THEN** `DEVOPS_MISE_PACKAGE_NAME` SHALL be `"mise"`, `DEVOPS_MISE_NIX_PACKAGE` SHALL be `"nixpkgs#mise"`, and `DEVOPS_MISE_INIT_FLAGS` SHALL default to an empty array

#### Scenario: Config layer contains no install logic
- **WHEN** `config/mise.zsh` is inspected
- **THEN** it SHALL contain only variable exports and no installation commands

### Requirement: mise module wiring

The devops module SHALL source the mise config, internal, and pkg layers from the module aggregators so the public API is available after load.

#### Scenario: Public function available after load
- **WHEN** `source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh` completes without error
- **THEN** `type devops::mise::install` SHALL report `function`

#### Scenario: Auto-install when mise is missing
- **WHEN** the devops module loads
- **AND** the `mise` binary is not installed
- **THEN** the factory SHALL trigger installation of `mise`
