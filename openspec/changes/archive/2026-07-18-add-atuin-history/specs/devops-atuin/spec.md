## ADDED Requirements

### Requirement: Atuin installation via official installer

The devops module SHALL install Atuin using the official cross-platform installer when the `atuin` binary is not found.

#### Scenario: Atuin not installed triggers install
- **WHEN** `devops::atuin::internal::main::factory` is called
- **AND** the `atuin` binary is not found via `core::exists atuin`
- **THEN** the module SHALL execute `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh` to install Atuin

#### Scenario: Atuin already installed skips install
- **WHEN** `devops::atuin::internal::main::factory` is called
- **AND** the `atuin` binary already exists
- **THEN** the module SHALL skip installation and proceed to shell integration

### Requirement: Atuin shell integration

The devops module SHALL initialize Atuin's ZSH shell integration during module load.

#### Scenario: Shell init executed
- **WHEN** the devops module loads
- **AND** Atuin is installed
- **THEN** the module SHALL execute `eval "$(atuin init zsh)"` with any flags from `DEVOPS_ATUIN_INIT_FLAGS`

#### Scenario: Custom init flags
- **WHEN** `DEVOPS_ATUIN_INIT_FLAGS` is set to `("--disable-up-arrow" "--no-ctrl-r")`
- **THEN** the shell init SHALL pass those flags to `atuin init zsh`

### Requirement: Atuin lifecycle management

The devops module SHALL provide install, upgrade, and post_install functions for Atuin following the standard devops convention.

#### Scenario: Install function delegates to factory
- **WHEN** `devops::atuin::install` is called
- **THEN** it SHALL delegate to `devops::atuin::internal::main::factory`

#### Scenario: Upgrade function upgrades Atuin binary
- **WHEN** `devops::atuin::upgrade` is called
- **THEN** it SHALL run the Atuin upgrade command (re-run installer or `atuin upgrade`)

#### Scenario: Post-install prints guidance
- **WHEN** `devops::atuin::post_install` is called
- **THEN** it SHALL print a message guiding the user to run `atuin login` for sync or `atuin import zsh` to import existing history

### Requirement: Atuin configuration variables

The devops module SHALL declare Atuin-specific configuration variables in `config/atuin.zsh`.

#### Scenario: Config variables are exported
- **WHEN** the devops config layer loads
- **THEN** the following variables SHALL be available:
  - `DEVOPS_ATUIN_PACKAGE_NAME` set to `"atuin"`
  - `DEVOPS_ATUIN_CONFIG_DIR` set to `"${HOME}/.config/atuin"`
  - `DEVOPS_ATUIN_INIT_FLAGS` defaulting to an empty array
