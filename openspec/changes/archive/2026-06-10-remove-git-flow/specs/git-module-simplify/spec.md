## REMOVED Requirements

### Requirement: Git-flow package installation
**Reason**: Git-flow is no longer used. The team uses GitHub Flow exclusively.
**Migration**: Remove `core::ensure "${GIT_FLOW_PACKAGE_NAME:-git-flow}"` from `internal/main.zsh` and the `GIT_FLOW_PACKAGE_NAME` variable from `config/linux.zsh`.

### Requirement: git-flow feature helper (`gff`)
**Reason**: The `gff` function wrapped `git flow feature start/publish/finish`. Since git-flow is not used, this helper is dead code.
**Migration**: Remove the `gff` function definition from `pkg/base.zsh`.

### Requirement: git-flow branch detection functions
**Reason**: Functions `git::internal::gitflow::branch::develop`, `git::internal::gitflow::branch::base`, `git::internal::gitflow::validate::exist::develop`, `git::internal::gitflow::validate::exist::master`, `git::internal::gitflow::has_master::configured`, `git::internal::gitflow::has_develop::configured`, and `git::internal::gitflow::setup` in `internal/base.zsh` are only consumed internally and have no callers outside git-flow paths.
**Migration**: Remove all seven functions from `internal/base.zsh`. Update the two call sites (lines 155 and 204) that reference `git::internal::gitflow::branch::develop` — those paths are conditional on git-flow detection and will be removed as part of the issues workflow simplification.

## ADDED Requirements

### Requirement: Git module loads without git-flow dependencies
The git module SHALL load successfully without the `git-flow` or `gitflow-avh` package installed.

#### Scenario: Module init without git-flow
- **WHEN** the git module initializes
- **THEN** it SHALL NOT attempt to ensure `git-flow` is installed
- **THEN** it SHALL NOT define any git-flow related functions or aliases

### Requirement: Existing git helpers remain functional
All non-git-flow git helpers (e.g., branch checkout, push, pull helpers) SHALL continue to work identically after removal.

#### Scenario: Standard git operations
- **WHEN** a user runs any standard git helper function
- **THEN** the behavior SHALL be identical to pre-removal behavior
