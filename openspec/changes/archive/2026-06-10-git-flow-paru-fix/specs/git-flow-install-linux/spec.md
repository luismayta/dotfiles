## ADDED Requirements

### Requirement: Linux git-flow package name override

The git module SHALL define `GIT_FLOW_PACKAGE_NAME` in `config/linux.zsh` to `gitflow-avh`, and `internal/main.zsh` SHALL use `${GIT_FLOW_PACKAGE_NAME:-git-flow}` when ensuring git-flow is installed.

#### Scenario: Linux install uses correct AUR package
- **WHEN** the git module loads on Linux
- **AND** `git-flow` binary is not yet installed
- **THEN** `core::ensure` SHALL install the package named by `GIT_FLOW_PACKAGE_NAME` (i.e., `gitflow-avh`)

#### Scenario: macOS install unchanged
- **WHEN** the git module loads on macOS
- **THEN** `core::ensure` SHALL use the default fallback `git-flow` (via `${GIT_FLOW_PACKAGE_NAME:-git-flow}`)

#### Scenario: Existing git-flow detection works
- **WHEN** `gitflow-avh` is installed via paru
- **THEN** `type -p git-flow` SHALL return the correct path
- **AND** the existing `gitflow::is_installed` check SHALL return 1