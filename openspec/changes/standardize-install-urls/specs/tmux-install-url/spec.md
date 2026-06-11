## ADDED Requirements

### Requirement: tmux TPM install URL declared in config
The tmux module SHALL declare its TPM plugin git clone URL as `TMUX_INSTALL_URL_TPM` in `config/base.zsh`.

#### Scenario: Variable is defined
- **WHEN** inspecting `zsh/modules/tmux/config/base.zsh`
- **THEN** `export TMUX_INSTALL_URL_TPM` SHALL be defined with value `https://github.com/tmux-plugins/tpm`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/tmux/internal/base.zsh`
- **THEN** the git clone command SHALL use `${TMUX_INSTALL_URL_TPM}`
- **AND** SHALL NOT contain a hardcoded `https://github.com/tmux-plugins/tpm` URL