# Spec Delta

## MODIFIED Requirements

### Requirement: mise zsh shell activation

The shell SHALL evaluate `mise activate zsh` at most once per startup across `zsh/zshrc` and the devops module, running only when the `mise` binary exists.

#### Scenario: Activation executed when binary exists

- **WHEN** a fresh shell starts with default configuration
- **AND** the `mise` binary exists
- **THEN** `mise activate zsh` SHALL have been evaluated exactly once across `zsh/zshrc` and the devops module

#### Scenario: No activation when binary is missing

- **WHEN** the devops module loads
- **AND** the `mise` binary does not exist
- **THEN** neither the devops module nor `zsh/zshrc` SHALL execute `mise activate zsh`

#### Scenario: Custom activation flags

- **WHEN** `DEVOPS_MISE_INIT_FLAGS` is set to `("--shims")`
- **THEN** the retained activation SHALL pass those flags to `mise activate zsh`

#### Scenario: Duplicate activation removed

- **WHEN** `zsh/zshrc` is inspected after the change
- **THEN** it SHALL contain no unconditional `mise activate` alongside the devops module's guarded activation
