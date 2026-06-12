## ADDED Requirements

### Requirement: nvim install URL declared in config
The nvim module SHALL declare its full git clone URL as `NVIM_INSTALL_URL` in `config/base.zsh`, replacing the current partial `NVIM_REPO_HTTPS` variable that only contains a repo path.

#### Scenario: Full URL variable is defined
- **WHEN** inspecting `zsh/modules/nvim/config/base.zsh`
- **THEN** `export NVIM_INSTALL_URL` SHALL be defined with value `https://github.com/luismayta/nvimrc.git`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/nvim/internal/base.zsh`
- **THEN** the git clone command SHALL use `${NVIM_INSTALL_URL}`
- **AND** SHALL NOT compose the URL from `NVIM_REPO_HTTPS`

#### Scenario: Existing NVIM_REPO_HTTPS is retained
- **WHEN** inspecting `zsh/modules/nvim/config/base.zsh`
- **THEN** `export NVIM_REPO_HTTPS` SHALL remain defined for backward compatibility