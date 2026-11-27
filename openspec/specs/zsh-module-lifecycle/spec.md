# zsh-module-lifecycle Specification

## Purpose

Classifies every module under `zsh/modules/` as ARCHIVE, DISABLE, or KEEP now that nix and mise are the source of truth for toolchains, and defines how default disables are applied through existing mechanisms, verified, reversed, scoped, and documented — without changing the `zsh/zshrc` loader.

## Requirements

### Requirement: Lifecycle decision recorded in transversal ADR

The project SHALL maintain a transversal ADR that records the lifecycle classification of every directory under `zsh/modules/` as ARCHIVE, DISABLE, or KEEP.

#### Scenario: All modules classified

- **WHEN** the ADR is read
- **THEN** every directory under `zsh/modules/` SHALL appear in a decision matrix with an ARCHIVE, DISABLE, or KEEP classification
- **AND** each row SHALL carry a one-line rationale

#### Scenario: Criteria applied to every row

- **WHEN** any matrix row is inspected
- **THEN** criteria C1 through C6 SHALL each be addressed for that module

#### Scenario: Criteria defined in the record

- **WHEN** criteria C1–C6 are referenced
- **THEN** the ADR SHALL state their definitions, noting they were authored for this proposal because the source requirements referenced them without defining them

### Requirement: Decision criteria C1–C6 govern classification

Each module SHALL be classified by applying: C1 nix/mise installation redundancy, C2 duplicate shell integration, C3 cross-boundary shared-helper usage, C4 platform scope, C5 interactive/user-facing value, C6 startup cost and reversibility.

#### Scenario: Redundant toolchain module classified by C1/C2

- **WHEN** a module installs or activates a version manager that nix or mise already owns, or registers hooks duplicating an existing startup integration
- **THEN** its classification SHALL reflect that redundancy rather than default-keep

#### Scenario: Platform-only module classified by C4

- **WHEN** a module is relevant on only one platform
- **THEN** its classification SHALL note that any disable belongs in that platform's config file with a `:-true` base default, not in a global exclusion

### Requirement: DISABLE uses existing mechanisms only

Modules SHALL be disabled only through the existing `ZSH_DISABLED_MODULES` list or the per-module `ZSH_<MODULE>_ENABLED` guard, and `zsh/zshrc` SHALL NOT gain a new module-exclusion branch or central blacklist.

#### Scenario: Loader unchanged

- **WHEN** `zsh/zshrc` is inspected after the change
- **THEN** module skipping SHALL occur only at the two existing `ZSH_DISABLED_MODULES` checks (system loop and module loop)
- **AND** no new exclusion condition SHALL be added

#### Scenario: Enabled override wins over default disable

- **WHEN** a fresh shell starts with `export ZSH_<MODULE>_ENABLED=true` set for a default-disabled module
- **THEN** that module's `plugin.zsh` SHALL load

### Requirement: Changed default disables module cleanly

For every module whose default this change sets to disabled, startup SHALL leave the load guard unset and public functions undefined when disabled, and SHALL define both when enabled.

#### Scenario: Disabled state

- **WHEN** a module with a changed default is disabled by its default or via `ZSH_DISABLED_MODULES` and a fresh shell starts
- **THEN** its `__ZSH_<MODULE>_LOADED` guard SHALL be unset
- **AND** its public functions SHALL be undefined

#### Scenario: Enabled state

- **WHEN** the same module is opted in (`export ZSH_<MODULE>_ENABLED=true`) and a fresh shell starts
- **THEN** its `__ZSH_<MODULE>_LOADED` guard SHALL be set
- **AND** its public functions SHALL be defined

### Requirement: ARCHIVE decisions blocked by cross-boundary references

A module SHALL be marked ARCHIVE only when no strict namespace-prefix reference to it exists outside its own directory in `zsh/modules/` or `zsh/system/`.

#### Scenario: Zero external references before archiving

- **WHEN** a strict-prefix search for the module's namespace is run across `zsh/modules/` and `zsh/system/`, excluding the module's own directory
- **THEN** it SHALL return zero matches for every module marked ARCHIVE

#### Scenario: Reference blocks archiving until migrated

- **WHEN** such a reference exists
- **THEN** the module SHALL NOT be marked ARCHIVE until the dependency is migrated

### Requirement: Shared helpers remain available after startup

The cross-boundary helpers that other layers depend on SHALL remain defined after a fresh shell startup.

#### Scenario: Helper smoke test

- **WHEN** a fresh shell finishes startup with default configuration
- **THEN** `git::internal::get_module_path` (acceptance name `git::get_module_path`), `devops::direnv::install`, `goenv::internal::package::install`, and `hrd::internal::osx::ensure_clipboard` (acceptance name `osx::ensure_clipboard`) SHALL be defined

### Requirement: Disabled modules are reversible per fresh shell

Disabling SHALL be reversible in a fresh shell without code changes, via `$CUSTOMRC`.

#### Scenario: Clear the disabled list

- **WHEN** `$CUSTOMRC` sets `ZSH_DISABLED_MODULES=""` and a fresh shell starts
- **THEN** all modules SHALL load as before the disable defaults were applied

#### Scenario: Force-enable one module

- **WHEN** `$CUSTOMRC` sets `export ZSH_<MODULE>_ENABLED=true` and a fresh shell starts
- **THEN** that module SHALL load and its public functions SHALL be defined

### Requirement: Platform- and host-scoped disables are placed correctly

Platform-scoped disables SHALL live only in `config/osx.zsh` or `config/linux.zsh` over a `:-true` base default in `config/base.zsh`; host-scoped disables SHALL live only in `$CUSTOMRC`.

#### Scenario: Platform disable placement

- **WHEN** a module is disabled on one platform only
- **THEN** the override SHALL be in that module's `config/osx.zsh` or `config/linux.zsh`
- **AND** its `config/base.zsh` SHALL default with `:-true`

#### Scenario: Host disable placement

- **WHEN** a single host must disable a module
- **THEN** the override SHALL be set only in that host's `$CUSTOMRC`, not in repository config files

### Requirement: Failure diagnostics are preserved

Disabling modules SHALL NOT suppress diagnostics for genuine dependency failures.

#### Scenario: Real failure still reports

- **WHEN** a loaded module or user code hits a missing dependency
- **THEN** `message_warning` or `message_error` SHALL still be emitted as before

#### Scenario: No suppression to hide disabled modules

- **WHEN** the change is inspected
- **THEN** no diagnostic output SHALL have been removed or silenced merely because a disabled module's helper is now missing

### Requirement: Lifecycle documentation is maintained

The root README (via its generator source), `zsh/modules/README.md`, `.customrc.example`, and `docs/env-vars.md` SHALL document module lifecycle usage and the `$CUSTOMRC` sourcing order.

#### Scenario: Disable mechanisms documented

- **WHEN** a user reads `zsh/modules/README.md`, `.customrc.example`, and `docs/env-vars.md`
- **THEN** they SHALL find `ZSH_DISABLED_MODULES` and `ZSH_<MODULE>_ENABLED` usage including restoring disabled modules

#### Scenario: CUSTOMRC sourcing order documented

- **WHEN** a user reads those documents
- **THEN** they SHALL learn that `$CUSTOMRC` is sourced after the `zsh/system/*` loop and before the `zsh/modules/*` loop

#### Scenario: Generated README not edited directly

- **WHEN** root README content changes
- **THEN** the edit SHALL be made in `provision/generators/README.yaml` or by running `task readme`, never by editing `README.md` directly
