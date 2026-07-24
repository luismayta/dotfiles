## MODIFIED Requirements

### Requirement: Devops tools array
The `DEVOPS_TOOLS` array SHALL NOT include `github-cli`.

#### Scenario: github-cli removed from tools
- **WHEN** the devops module loads
- **THEN** `DEVOPS_TOOLS` array SHALL NOT contain `github-cli`

### Requirement: Devops config layer
The devops config layer SHALL NOT source GitHub configuration.

#### Scenario: No gh.zsh sourcing
- **WHEN** `devops/config/main.zsh` loads
- **THEN** it SHALL NOT source `gh.zsh`

### Requirement: Devops internal layer
The devops internal layer SHALL NOT source GitHub internal functions.

#### Scenario: No gh.zsh sourcing
- **WHEN** `devops/internal/main.zsh` loads
- **THEN** it SHALL NOT source `gh.zsh`

### Requirement: Devops pkg layer
The devops pkg layer SHALL NOT source GitHub public functions.

#### Scenario: No gh.zsh sourcing
- **WHEN** `devops/pkg/main.zsh` loads
- **THEN** it SHALL NOT source `gh.zsh`

## REMOVED Requirements

### Requirement: Devops GitHub configuration
The devops module SHALL NOT contain GitHub CLI configuration.

**Reason**: GitHub CLI has been extracted to its own `github` module.
**Migration**: Use the `github` module with `ZSH_GITHUB_*` variables.

### Requirement: Devops GitHub internal functions
The devops module SHALL NOT contain GitHub internal functions.

**Reason**: GitHub CLI has been extracted to its own `github` module.
**Migration**: Use `github::internal::*` functions from the `github` module.

### Requirement: Devops GitHub public functions
The devops module SHALL NOT contain GitHub public functions.

**Reason**: GitHub CLI has been extracted to its own `github` module.
**Migration**: Use `github::*` functions from the `github` module.

### Requirement: Devops GitHub data directory
The devops module SHALL NOT contain `data/gh/` directory.

**Reason**: GitHub CLI has been extracted to its own `github` module.
**Migration**: Use `ZSH_GITHUB_DATA_PATH` from the `github` module.
