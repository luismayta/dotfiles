## ADDED Requirements

### Requirement: golangci-lint install URL declared in config
The goenv module SHALL declare the golangci-lint install URL as `GOENV_INSTALL_URL_LINT` in `config/base.zsh`.

#### Scenario: Variable is defined
- **WHEN** inspecting `zsh/modules/goenv/config/base.zsh`
- **THEN** `export GOENV_INSTALL_URL_LINT` SHALL be defined with value `https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/goenv/internal/base.zsh`
- **THEN** the lint install command SHALL use `${GOENV_INSTALL_URL_LINT}`
- **AND** SHALL NOT contain a hardcoded `https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh` URL

### Requirement: gobrew upgrade URL declared in config
The goenv module SHALL declare the gobrew upgrade URL as `GOBREW_INSTALL_URL` (replacing the partial `GOBREW_DOWNLOAD_URL` convention) in `config/base.zsh`.

#### Scenario: GoBrew install URL is defined
- **WHEN** inspecting `zsh/modules/goenv/config/base.zsh`
- **THEN** `export GOBREW_INSTALL_URL` SHALL be defined with value `https://git.io/gobrew`

#### Scenario: Internal references gobrew variable
- **WHEN** inspecting `zsh/modules/goenv/internal/base.zsh`
- **THEN** the gobrew upgrade command SHALL use `${GOBREW_INSTALL_URL}`
- **AND** SHALL NOT contain a hardcoded `https://git.io/gobrew` URL

### Requirement: Existing GOBREW_DOWNLOAD_URL unchanged
The existing `GOBREW_DOWNLOAD_URL` SHALL remain defined in config for backward compatibility.

#### Scenario: Legacy variable preserved
- **WHEN** inspecting `zsh/modules/goenv/config/base.zsh`
- **THEN** `export GOBREW_DOWNLOAD_URL` SHALL remain defined