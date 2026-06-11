## ADDED Requirements

### Requirement: Install kubecolor via core::install
The system SHALL install kubecolor using `core::install kubecolor` instead of calling `brew install` directly.

#### Scenario: kubecolor installed via core path
- **WHEN** `devops::kubectl::internal::kubecolor::install` is called
- **THEN** it SHALL invoke `core::install kubecolor`
- **AND** it SHALL NOT call `brew install` directly

#### Scenario: kubecolor already installed
- **WHEN** `kubecolor` is already present on the system
- **THEN** the install function SHALL be skipped (guard via `core::exists kubecolor`)

### Requirement: Remove crossplane install
Crossplane is no longer used in the project. The system SHALL NOT install crossplane during devops factory initialization.

#### Scenario: crossplane not installed during factory
- **WHEN** `devops::kubectl::internal::main::factory` is called
- **THEN** crossplane SHALL NOT be installed or verified

### Requirement: Install krew via core::install
The system SHALL install krew using `core::install krew` instead of downloading and extracting a tarball.

#### Scenario: krew installed via core path
- **WHEN** `devops::kubectl::internal::krew::install` is called
- **THEN** it SHALL invoke `core::install krew`
- **AND** it SHALL NOT download tarballs from GitHub releases

#### Scenario: krew already installed
- **WHEN** `kubectl-krew` is already present on the system
- **THEN** the install function SHALL be skipped

### Requirement: Factory orchestrates all installs
The `devops::kubectl::internal::main::factory` function SHALL continue to call all three install paths, using `core::ensure` for tools that no longer need a separate install function.

#### Scenario: factory installs all tools
- **WHEN** `main::factory` is called
- **THEN** `kubectl`, `helm`, `kubectx`, `kubecolor`, `crossplane`, and `krew` SHALL all be installed or verified
- **AND** the completion setup SHALL still be loaded