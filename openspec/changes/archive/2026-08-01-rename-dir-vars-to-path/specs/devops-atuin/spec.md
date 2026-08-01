## MODIFIED Requirements

### Requirement: Atuin configuration variables

The devops module SHALL declare Atuin-specific configuration variables in `config/atuin.zsh`.

#### Scenario: Config variables are exported
- **WHEN** the devops config layer loads
- **THEN** the following variables SHALL be available:
  - `DEVOPS_ATUIN_PACKAGE_NAME` set to `"atuin"`
  - `DEVOPS_ATUIN_CONFIG_PATH` set to `"${HOME}/.config/atuin"`
  - `DEVOPS_ATUIN_INIT_FLAGS` defaulting to an empty array
