## ADDED Requirements

### Requirement: fnm install URL declared in config
The fnm module SHALL declare its install URL as `FNM_INSTALL_URL` in `config/base.zsh`.

#### Scenario: Variable is defined
- **WHEN** inspecting `zsh/modules/fnm/config/base.zsh`
- **THEN** `export FNM_INSTALL_URL` SHALL be defined with value `https://fnm.vercel.app/install`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/fnm/internal/base.zsh`
- **THEN** the install command SHALL use `${FNM_INSTALL_URL}`
- **AND** SHALL NOT contain a hardcoded `https://fnm.vercel.app/install` URL