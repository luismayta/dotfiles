---
## Purpose

Adds a ZSH module that installs, verifies, and manages the smolvm microVM engine (pinned v1.3.2) for running coding agents in ephemeral microVMs via the herdr smolbox plugin.

## ADDED Requirements

### Requirement: Module structure
The smolvm module SHALL live in `zsh/modules/smolvm/` and SHALL contain `plugin.zsh`, `config/`, `internal/`, `pkg/`, and `data/` according to `docs/guides/create-module.md`.

#### Scenario: Scaffold exists
- **WHEN** the module is created
- **THEN** `zsh/modules/smolvm/plugin.zsh`, `config/`, `internal/`, `pkg/`, and `data/` exist

### Requirement: Single entry point with idempotent load chain
`plugin.zsh` SHALL be the only file sourced by the zshrc for this module. It SHALL source `config/main.zsh`, then `internal/main.zsh`, then `pkg/main.zsh`. It SHALL set `__ZSH_SMOLVM_LOADED` so a second source is a no-op.

#### Scenario: Single load chain
- **WHEN** the zshrc sources the module
- **THEN** only `plugin.zsh` is sourced and it chains config, internal, and pkg in order

#### Scenario: Idempotency guard
- **WHEN** `plugin.zsh` is sourced twice
- **THEN** the loading logic runs only once and the second source is a no-op

### Requirement: Enable/disable toggle
The module SHALL be enabled by default (repo convention: unset defaults to enabled via `ZSH_SMOLVM_ENABLED="${ZSH_SMOLVM_ENABLED:-true}"`). It SHALL be disabled only when `ZSH_SMOLVM_ENABLED` is set to a value other than `true` (opt-out), in which case it SHALL NOT load the internal or pkg layers.

#### Scenario: Module disabled
- **WHEN** `ZSH_SMOLVM_ENABLED` is set to a value other than `true` (e.g. `false`)
- **THEN** the module returns before loading the internal and pkg layers

#### Scenario: Module enabled
- **WHEN** `ZSH_SMOLVM_ENABLED` is unset or `true`
- **THEN** the internal and pkg layers load normally (repo convention: unset defaults to enabled)

### Requirement: Pinned installation with checksum verification
`internal/install.zsh` SHALL install smolvm v1.3.2 by downloading the official release asset, verifying its SHA256 checksum, and installing the binary to `~/.local/bin`. The install SHALL use `core::ensure` for dependencies and SHALL abort without installing when the checksum does not match.

#### Scenario: Clean install
- **WHEN** smolvm is not installed and the release asset downloads with a matching SHA256 checksum
- **THEN** the binary is installed at `~/.local/bin` and dependencies are ensured via `core::ensure`

#### Scenario: Checksum mismatch
- **WHEN** the downloaded asset fails SHA256 verification
- **THEN** installation aborts with an error message and no binary is installed

#### Scenario: Already installed
- **WHEN** `core::exists smolvm` is true
- **THEN** the install function reports it is already installed and returns without re-installing

### Requirement: Post-install verification
The module SHALL verify the installation: `smolvm --version` SHALL report version 1.3.2 and `smolvm machine run --help` SHALL respond successfully.

#### Scenario: Version and help respond
- **WHEN** the module loads and smolvm is installed
- **THEN** `smolvm --version` reports 1.3.2 and `smolvm machine run --help` responds

### Requirement: Shell quality checks
All new module files SHALL pass `bash -n` and shellcheck.

#### Scenario: Syntax and lint clean
- **WHEN** new module files are checked with `bash -n` and shellcheck
- **THEN** no errors are reported

### Requirement: Generated module README
The module SHALL have a `README.md` generated from `provision/templates/README.module.tpl.md` using its `README.yaml` and the module's `readme` task.

#### Scenario: README generated from template
- **WHEN** the module's `readme` task runs
- **THEN** `zsh/modules/smolvm/README.md` is produced from `provision/templates/README.module.tpl.md` with `README.yaml` as datasource
---
