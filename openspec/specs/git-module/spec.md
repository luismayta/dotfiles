# git-module Specification

## Purpose
The git module owns installation and configuration of `delta` (git-delta) as a nix dependency, consolidating pager configuration that was previously duplicated and dead in the rust module.

## Requirements

### Requirement: Git module declares the delta nix package reference
The git module SHALL declare a configuration variable `GIT_DELTA_NIX_PACKAGE` set to `nixpkgs#delta`, following the existing devops nix dependency pattern.

#### Scenario: Package reference declared
- **WHEN** the git module config is sourced
- **THEN** `GIT_DELTA_NIX_PACKAGE` SHALL equal `nixpkgs#delta`

### Requirement: Git module installs delta via nix when missing
The git module SHALL install `delta` using `nix profile install` with `${GIT_DELTA_NIX_PACKAGE}` when `delta` is not already available on `PATH`, and SHALL skip installation when it is present.

#### Scenario: Delta missing
- **WHEN** `delta` is not found on `PATH` at module load
- **THEN** the module SHALL run `nix profile install "${GIT_DELTA_NIX_PACKAGE}"`

#### Scenario: Delta present
- **WHEN** `delta` is already on `PATH` at module load
- **THEN** the module SHALL not reinstall delta

### Requirement: Git module applies delta git configuration
The git module SHALL apply the delta git configuration when delta is available: `core.pager = delta`, `interactive.diffFilter = delta --color-only`, `delta.navigate = true`, and `merge.conflictStyle = zdiff3`.

#### Scenario: Configuration applied
- **WHEN** `git::internal::delta::load` runs with delta available
- **THEN** the four git config values SHALL be set

### Requirement: Synced gitconfig uses delta as pager
The synced `.gitconfig` SHALL set `core.pager = delta`, with `hunk pager` retained as a commented alternative.

#### Scenario: Pager set to delta
- **WHEN** the synced `.gitconfig` is applied
- **THEN** `core.pager` SHALL be `delta` and `hunk pager` SHALL appear only as a comment

### Requirement: Git module lists delta as a requirement
The git module README SHALL list delta among its requirements.

#### Scenario: README updated
- **WHEN** the git module metadata is read
- **THEN** delta SHALL be present in the requirements list

### Requirement: Delta ownership consolidated in git module
The git module SHALL be the sole owner of delta installation and configuration; the rust module SHALL no longer declare `git-delta` in its cargo packages nor define a delta configuration function.

#### Scenario: Rust module no longer owns delta
- **WHEN** the rust module config and internal files are inspected
- **THEN** `git-delta` SHALL NOT appear in `RUST_CARGO_PACKAGES_SIMPLE` and no `rust::internal::delta::load` function SHALL exist