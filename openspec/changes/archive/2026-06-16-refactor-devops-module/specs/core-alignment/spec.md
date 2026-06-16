## ADDED Requirements

### Requirement: Remove DEVOPS_KUBECTL_KUBE_EDITOR
The system SHALL NOT define `DEVOPS_KUBECTL_KUBE_EDITOR`. All editor references in the devops module SHALL use `$EDITOR` from zsh/core.

#### Scenario: Editor is resolved from core
- **WHEN** the devops module is loaded
- **THEN** `DEVOPS_KUBECTL_KUBE_EDITOR` SHALL NOT be set
- **AND** `$EDITOR` SHALL be sourced from zsh/core/config/env.zsh

### Requirement: Remove DEVOPS_KUBECTL_LOCAL_PATH_BIN
The system SHALL NOT define `DEVOPS_KUBECTL_LOCAL_PATH_BIN`. The path `LOCAL_PATH_BIN` from zsh/core SHALL be used instead.

#### Scenario: Local bin path uses core variable
- **WHEN** the devops config loads
- **THEN** `DEVOPS_KUBECTL_LOCAL_PATH_BIN` SHALL NOT exist
- **AND** `LOCAL_PATH_BIN` SHALL be used for local binary paths

### Requirement: Remove DEVOPS_ARCHITECTURE_NAME and DEVOPS_APPLICATION_PATH
Unused variables `DEVOPS_ARCHITECTURE_NAME` and `DEVOPS_APPLICATION_PATH` SHALL be removed from devops config.

#### Scenario: Dead variables are removed
- **WHEN** config/osx.zsh and config/linux.zsh are loaded
- **THEN** `DEVOPS_ARCHITECTURE_NAME` SHALL NOT be set
- **AND** `DEVOPS_APPLICATION_PATH` SHALL NOT be set

### Requirement: Use path::append / path::prepend from core
Manual PATH manipulations in devops internal scripts SHALL be replaced with `path::append` and `path::prepend` from zsh/core.

#### Scenario: Krew path uses path::append
- **WHEN** `devops::kubectl::internal::krew::load` runs
- **THEN** the krew bin path SHALL be added via `path::append "${KREW_ROOT_BIN}"`

#### Scenario: Tfenv path uses path::append
- **WHEN** `devops::tfenv::internal::tfenv::load` runs
- **THEN** the tfenv bin path SHALL be added via `path::append "${DEVOPS_TFENV_ROOT_BIN}"`
