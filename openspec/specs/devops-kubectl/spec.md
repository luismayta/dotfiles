# devops-kubectl Specification

## Purpose
TBD - created by archiving change migrate-k8s-tools-to-devops. Update Purpose after archive.
## Requirements
### Requirement: kubectl and kubecolor installation
The devops module SHALL install kubectl and kubecolor if not present on the system.

#### Scenario: kubectl not installed
- **WHEN** the devops module loads and kubectl binary is not found
- **THEN** core::install kubectl SHALL be called

#### Scenario: kubecolor not installed
- **WHEN** the devops module loads and kubecolor is not found
- **THEN** core::install kubecolor SHALL be called

### Requirement: krew plugin management
The devops module SHALL install krew and manage krew plugins (ctx, ns, access-matrix, ktop, ca-cert, sniff, etc.).

#### Scenario: krew installation
- **WHEN** the devops module loads and kubectl-krew is not found
- **THEN** devops::kubectl::internal::krew::install SHALL be called

#### Scenario: krew plugin loading
- **WHEN** krew is installed
- **THEN** krew root bin directory SHALL be added to PATH

### Requirement: crossplane CLI installation
The devops module SHALL install crossplane CLI if not present.

#### Scenario: crossplane not installed
- **WHEN** the devops module loads and crossplane binary is not found
- **THEN** devops::kubectl::internal::crossplane::install SHALL be called

### Requirement: Go package management for kubectl tools
The devops module SHALL install Go-based kubectl tooling (kubectl-who-can, kconf, kustomize, kube-linter).

#### Scenario: Go packages installation
- **WHEN** devops::kubectl::go::packages::install is called
- **THEN** all packages in DEVOPS_KUBECTL_GO_PACKAGES SHALL be installed via go install

### Requirement: kubectl completion loading
The devops module SHALL load kubectl zsh completion on module init.

#### Scenario: completion loaded
- **WHEN** the devops module loads
- **THEN** source <(kubectl completion zsh) SHALL be executed

### Requirement: kubectl aliases
The devops module SHALL define the following kubectl aliases: k, kg, kd, kdel, kucx, kgcx, kscn, kgp, kdp, kgd, kdd, kgs, kds, ka, kl, klf.

#### Scenario: alias definitions
- **WHEN** the devops module loads
- **THEN** alias k SHALL point to kubecolor
- **THEN** alias kubectl SHALL point to kubecolor
- **THEN** alias kg SHALL point to kubectl get
- **THEN** alias kd SHALL point to kubectl describe
- **THEN** alias kdel SHALL point to kubectl delete