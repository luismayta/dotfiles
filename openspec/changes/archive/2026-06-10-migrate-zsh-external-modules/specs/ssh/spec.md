## ADDED Requirements

### Requirement: SSH connection manager
The SSH module SHALL provide fzf-based SSH connection management with assh integration for macOS and Linux.

#### Scenario: Module loads on zsh start
- **WHEN** zsh starts and sources `zsh/modules/ssh/plugin.zsh`
- **THEN** the module SHALL set `SSH_PATH` and SHALL source `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh`
- **THEN** the module SHALL define `__ZSH_SSH_LOADED=1` to prevent double-loading

#### Scenario: Environment variables are set
- **WHEN** the module loads
- **THEN** `SSH_CONFIG_FILE` SHALL be `~/.ssh/config`
- **AND** `SSH_PATH_CONF` SHALL be `$SSH_PATH/conf`
- **AND** `SSH_PACKAGE_NAME` SHALL be `assh`

#### Scenario: Keybinding is registered
- **WHEN** the module loads
- **THEN** `^Xs` SHALL be bound to `ssh::connect` via `bindkey '^Xs' ssh::connect`

#### Scenario: SSH alias is set
- **WHEN** the module loads
- **THEN** `ssh` SHALL be aliased to `assh wrapper ssh`

#### Scenario: SSH connect via fzf
- **WHEN** user runs `ssh::connect` (or presses `^Xs`)
- **THEN** the module SHALL present an fzf list of SSH hosts from `$SSH_CONFIG_FILE`
- **AND** SHALL establish an SSH connection to the selected host

#### Scenario: SSH host list
- **WHEN** user runs `ssh::list`
- **THEN** the module SHALL display parsed hosts from `$SSH_CONFIG_FILE`

#### Scenario: SSH build config
- **WHEN** user runs `ssh::build`
- **THEN** the module SHALL rebuild the assh configuration

#### Scenario: SSH sync config
- **WHEN** user runs `ssh::sync`
- **THEN** the module SHALL rsync `$SSH_PATH_CONF/` to `~/.ssh/`

#### Scenario: SSH upgrade
- **WHEN** user runs `ssh::upgrade`
- **THEN** the module SHALL upgrade assh to the latest version

#### Scenario: Config editing via editassh
- **WHEN** user runs `editassh`
- **THEN** the module SHALL open `$SSH_PATH_CONF/assh.yml` in `$EDITOR`

#### Scenario: Dependency check
- **WHEN** the module loads
- **THEN** it SHALL ensure `curl`, `fzf`, `jq`, `less`, and `assh` are installed

#### Scenario: assh.yml is available
- **WHEN** the module loads
- **THEN** `$SSH_PATH_CONF/assh.yml` SHALL exist with assh configuration (compression, keepalive, hashing)