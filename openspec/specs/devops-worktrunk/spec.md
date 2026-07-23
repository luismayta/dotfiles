## ADDED Requirements

### Requirement: Worktrunk installation via core::install

The devops module SHALL install Worktrunk using core::install when the `wt` binary is not found.

#### Scenario: Worktrunk not installed triggers install
- **WHEN** `devops::worktrunk::internal::main::factory` is called
- **AND** the `wt` binary is not found via `core::exists wt`
- **THEN** the module SHALL execute `core::install worktrunk` to install Worktrunk

#### Scenario: Worktrunk already installed skips install
- **WHEN** `devops::worktrunk::internal::main::factory` is called
- **AND** the `wt` binary already exists
- **THEN** the module SHALL skip installation and proceed to shell integration

### Requirement: Worktrunk shell integration

The devops module SHALL initialize Worktrunk's shell integration during module load.

#### Scenario: Shell init executed
- **WHEN** the devops module loads
- **AND** Worktrunk is installed
- **THEN** the module SHALL execute `wt config shell install` to set up shell integration

#### Scenario: Shell integration already configured
- **WHEN** the devops module loads
- **AND** Worktrunk shell integration is already configured
- **THEN** the module SHALL skip shell integration setup

### Requirement: Worktrunk lifecycle management

The devops module SHALL provide install, upgrade, and post_install functions for Worktrunk following the standard devops convention.

#### Scenario: Install function delegates to factory
- **WHEN** `devops::worktrunk::install` is called
- **THEN** it SHALL delegate to `devops::worktrunk::internal::main::factory`

#### Scenario: Upgrade function upgrades Worktrunk binary
- **WHEN** `devops::worktrunk::upgrade` is called
- **THEN** it SHALL run `brew upgrade worktrunk` to upgrade the binary

#### Scenario: Post-install prints guidance
- **WHEN** `devops::worktrunk::post_install` is called
- **THEN** it SHALL print a message guiding the user to run `wt config shell install` for shell integration

### Requirement: Worktrunk configuration variables

The devops module SHALL declare Worktrunk-specific configuration variables in `config/worktrunk.zsh`.

#### Scenario: Config variables are exported
- **WHEN** the devops config layer loads
- **THEN** the following variables SHALL be available:
  - `DEVOPS_WORKTRUNK_PACKAGE_NAME` set to `"worktrunk"`
  - `DEVOPS_WORKTRUNK_ROOT_BIN` set to `"${HOME}/.worktrunk/bin"`
  - `DEVOPS_WORKTRUNK_INIT_FLAGS` defaulting to an empty array

### Requirement: Worktrunk PATH integration

The devops module SHALL add Worktrunk's binary directory to the system PATH.

#### Scenario: PATH updated on load
- **WHEN** the devops module loads
- **AND** Worktrunk is installed
- **THEN** the module SHALL prepend `${DEVOPS_WORKTRUNK_ROOT_BIN}` to the system PATH using `core::path::prepend`

#### Scenario: PATH not updated if not installed
- **WHEN** the devops module loads
- **AND** Worktrunk is not installed
- **THEN** the module SHALL NOT modify the system PATH
