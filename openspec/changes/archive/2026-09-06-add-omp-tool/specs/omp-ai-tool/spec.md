## Purpose

Integrates omp (Oh My Pi) as an AI tool in the zsh/modules/ai/ module, providing installation, configuration synchronization, and PATH loading following the established three-layer architecture pattern.

## ADDED Requirements

### Requirement: omp configuration variables

The system SHALL export environment variables for omp configuration in `config/omp.zsh`:

- `ZSH_AI_OMP_BIN_PATH` — omp binary directory
- `ZSH_AI_OMP_CONFIG_PATH` — omp config directory (`~/.omp/agent`)
- `ZSH_AI_OMP_CONFIG_SOURCE_PATH` — module data source for config sync
- `ZSH_AI_OMP_INSTALL_URL` — installation URL (`https://omp.sh/install`)

#### Scenario: Config variables are exported

- **WHEN** the AI module loads
- **THEN** all `ZSH_AI_OMP_*` variables SHALL be available in the shell environment

### Requirement: omp PATH loading

The system SHALL provide `ai::internal::omp::load` to add the omp binary directory to PATH.

#### Scenario: Binary directory added to PATH

- **WHEN** `ai::internal::omp::load` is called and the omp binary exists
- **THEN** `ZSH_AI_OMP_BIN_PATH` SHALL be prepended to `PATH`

#### Scenario: Missing binary

- **WHEN** `ai::internal::omp::load` is called and the omp binary does not exist
- **THEN** the system SHALL return silently without modifying PATH

### Requirement: omp installation

The system SHALL provide `ai::internal::omp::install` to install omp via curl, following the pi pattern.

#### Scenario: Guard present in load

- **WHEN** the omp load flow runs
- **THEN** a guard using `core::exists omp` SHALL be present

#### Scenario: Successful installation

- **WHEN** `ai::internal::omp::install` is called and omp is not installed
- **THEN** the system SHALL execute `curl -fsSL https://omp.sh/install | sh`
- **AND** display a success message upon completion

#### Scenario: Already installed

- **WHEN** `ai::internal::omp::install` is called and omp is already installed
- **THEN** the system SHALL return 0 without running the installer

#### Scenario: Installation failure

- **WHEN** `ai::internal::omp::install` is called and the curl command fails
- **THEN** the system SHALL display an error message and return 1

### Requirement: omp config synchronization

The system SHALL provide `ai::internal::omp::config::sync` to synchronize omp configuration from the module data directory to the user config directory.

#### Scenario: Successful sync

- **WHEN** `ai::internal::omp::config::sync` is called
- **THEN** the system SHALL rsync `ZSH_AI_OMP_CONFIG_SOURCE_PATH` to `ZSH_AI_OMP_CONFIG_PATH`
- **AND** create the target directory if it does not exist
- **AND** display a success message upon completion

#### Scenario: Missing config source

- **WHEN** `ai::internal::omp::config::sync` is called and the source directory does not exist
- **THEN** the system SHALL display a warning message

### Requirement: Public API functions

The system SHALL expose public functions in `pkg/omp.zsh`:

- `ai::omp::install` — delegates to `ai::internal::omp::install`
- `ai::omp::config::sync` — delegates to `ai::internal::omp::config::sync`

#### Scenario: Public install function available

- **WHEN** the AI module pkg layer loads
- **THEN** `type ai::omp::install` SHALL return `function`

#### Scenario: Public config sync function available

- **WHEN** the AI module pkg layer loads
- **THEN** `type ai::omp::config::sync` SHALL return `function`

### Requirement: Registration in module files

The system SHALL register omp in three locations:

1. `config/base.zsh` — source `config/omp.zsh` and add `omp` to `ZSH_AI_TOOLS` array
2. `internal/main.zsh` — source `internal/omp.zsh` and call `ai::internal::omp::load`
3. `pkg/main.zsh` — source `pkg/omp.zsh`

#### Scenario: Config sourced from base.zsh

- **WHEN** the AI module config layer loads
- **THEN** `config/omp.zsh` SHALL be sourced

#### Scenario: omp in tool registry

- **WHEN** the AI module config layer loads
- **THEN** `omp` SHALL be present in the `ZSH_AI_TOOLS` array

#### Scenario: Internal sourced from main.zsh

- **WHEN** the AI module internal layer loads
- **THEN** `internal/omp.zsh` SHALL be sourced
- **AND** `ai::internal::omp::load` SHALL be called

#### Scenario: Pkg sourced from main.zsh

- **WHEN** the AI module pkg layer loads
- **THEN** `pkg/omp.zsh` SHALL be sourced

### Requirement: Module loads without errors

The system SHALL load the AI module without errors after omp integration.

#### Scenario: Module source succeeds

- **WHEN** `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh` is executed
- **THEN** the module SHALL load without errors

### Requirement: No plugin.zsh modification required

The system SHALL NOT require modifications to `plugin.zsh` — it already chains config/main.zsh → internal/main.zsh → pkg/main.zsh.

#### Scenario: Plugin loads omp automatically

- **WHEN** `plugin.zsh` is sourced
- **THEN** omp functions SHALL be available without any changes to `plugin.zsh`