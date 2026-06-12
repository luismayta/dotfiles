## ADDED Requirements

### Requirement: scm_breeze install URL declared in config
The scmbreeze module SHALL declare its git clone URL as `SCMBREEZE_INSTALL_URL` in `config/base.zsh`.

#### Scenario: Variable is defined
- **WHEN** inspecting `zsh/modules/scmbreeze/config/base.zsh`
- **THEN** `export SCMBREEZE_INSTALL_URL` SHALL be defined with value `https://github.com/scmbreeze/scm_breeze.git`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/scmbreeze/internal/base.zsh`
- **THEN** the git clone command SHALL use `${SCMBREEZE_INSTALL_URL}`
- **AND** SHALL NOT contain a hardcoded `https://github.com/scmbreeze/scm_breeze.git` URL