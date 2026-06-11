## ADDED Requirements

### Requirement: pyenv install URL declared in config
The pyenv module SHALL declare its pyenv git clone URL as `PYENV_INSTALL_URL` in `config/base.zsh`.

#### Scenario: Variable is defined
- **WHEN** inspecting `zsh/modules/pyenv/config/base.zsh`
- **THEN** `export PYENV_INSTALL_URL` SHALL be defined with value `https://github.com/pyenv/pyenv.git`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/pyenv/internal/base.zsh`
- **THEN** the git clone command SHALL use `${PYENV_INSTALL_URL}`
- **AND** SHALL NOT contain a hardcoded `https://github.com/pyenv/pyenv.git` URL