## ADDED Requirements

### Requirement: rvm install URL declared in config
The rvm module SHALL declare its rvm install URL as `RVM_INSTALL_URL` in `config/base.zsh`.

#### Scenario: Variable is defined
- **WHEN** inspecting `zsh/modules/rvm/config/base.zsh`
- **THEN** `export RVM_INSTALL_URL` SHALL be defined with value `https://get.rvm.io`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/rvm/internal/base.zsh`
- **THEN** the install command SHALL use `${RVM_INSTALL_URL}`
- **AND** SHALL NOT contain a hardcoded `https://get.rvm.io` URL

### Requirement: rvm GPG key URLs declared in config
The rvm module SHALL declare its GPG key import URLs as `RVM_INSTALL_URL_MPAPIS` and `RVM_INSTALL_URL_PKUCZYNSKI` in `config/base.zsh`.

#### Scenario: GPG URLs are defined
- **WHEN** inspecting `zsh/modules/rvm/config/base.zsh`
- **THEN** `export RVM_INSTALL_URL_MPAPIS` SHALL be `https://rvm.io/mpapis.asc`
- **AND** `export RVM_INSTALL_URL_PKUCZYNSKI` SHALL be `https://rvm.io/pkuczynski.asc`

#### Scenario: Internal references GPG variables
- **WHEN** inspecting `zsh/modules/rvm/internal/base.zsh`
- **THEN** the GPG import commands SHALL use `${RVM_INSTALL_URL_MPAPIS}` and `${RVM_INSTALL_URL_PKUCZYNSKI}`
- **AND** SHALL NOT contain hardcoded `rvm.io` URLs