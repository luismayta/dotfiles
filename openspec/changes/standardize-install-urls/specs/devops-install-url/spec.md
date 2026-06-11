## ADDED Requirements

### Requirement: tfenv install URL declared in config
The devops module SHALL declare its tfenv git clone URL as `DEVOPS_INSTALL_URL_TFENV` in `config/tfenv.zsh`.

#### Scenario: Variable is defined
- **WHEN** inspecting `zsh/modules/devops/config/tfenv.zsh`
- **THEN** `export DEVOPS_INSTALL_URL_TFENV` SHALL be defined with value `https://github.com/tfutils/tfenv.git`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/devops/internal/tfenv.zsh`
- **THEN** the git clone command SHALL use `${DEVOPS_INSTALL_URL_TFENV}`
- **AND** SHALL NOT contain a hardcoded `https://github.com/tfutils/tfenv.git` URL