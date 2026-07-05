## ADDED Requirements

### Requirement: ZSH_HERDR_PACKAGE_NAME

The system SHALL define `ZSH_HERDR_PACKAGE_NAME` as the canonical variable for the herdr package name.
The system SHALL preserve `HERDR_PACKAGE_NAME` as an exported alias pointing to `ZSH_HERDR_PACKAGE_NAME`.

#### Scenario: Variable is defined in config/base.zsh
- **WHEN** `config/base.zsh` is sourced
- **THEN** `ZSH_HERDR_PACKAGE_NAME` SHALL be set to `herdr`
- **THEN** `HERDR_PACKAGE_NAME` SHALL be set to the same value via alias

#### Scenario: All references use the new name
- **WHEN** searching for `${HERDR_PACKAGE_NAME}` in `internal/base.zsh` and `pkg/base.zsh`
- **THEN** all references SHALL use `${ZSH_HERDR_PACKAGE_NAME}` instead

### Requirement: ZSH_HERDR_INSTALL_URL

The system SHALL define `ZSH_HERDR_INSTALL_URL` as the canonical variable for the herdr install script URL.
The system SHALL preserve `HERDR_INSTALL_URL` as an exported alias.

#### Scenario: Variable is defined in config/base.zsh
- **WHEN** `config/base.zsh` is sourced
- **THEN** `ZSH_HERDR_INSTALL_URL` SHALL be set to `https://herdr.dev/install.sh`

#### Scenario: Internal reference uses new name
- **WHEN** `internal/base.zsh` references the install URL
- **THEN** it SHALL use `${ZSH_HERDR_INSTALL_URL}`

### Requirement: ZSH_HERDR_WORKSPACE_PREFIX

The system SHALL define `ZSH_HERDR_WORKSPACE_PREFIX` as the canonical variable for workspace prefix.
The system SHALL preserve `HERDR_WORKSPACE_PREFIX` as an exported alias.

#### Scenario: Variable is defined in config/base.zsh
- **WHEN** `config/base.zsh` is sourced
- **THEN** `ZSH_HERDR_WORKSPACE_PREFIX` SHALL default to empty string

### Requirement: ZSH_HERDR_PROJECT_TEMPLATE_PATH

The system SHALL rename `ZSH_HRD_PROJECT_TEMPLATE_PATH` to `ZSH_HERDR_PROJECT_TEMPLATE_PATH`.
The system SHALL preserve `ZSH_HRD_PROJECT_TEMPLATE_PATH` as an exported alias.

#### Scenario: Variable is renamed in config/base.zsh
- **WHEN** `config/base.zsh` is sourced
- **THEN** `ZSH_HERDR_PROJECT_TEMPLATE_PATH` SHALL be set to `${ZSH_HERDR_DATA_PATH}/plugins/config/cloudmanic.herdr-plus/projects`

#### Scenario: All internal references use new name
- **WHEN** searching for `ZSH_HRD_PROJECT_TEMPLATE_PATH` in `internal/base.zsh` and `pkg/helper.zsh`
- **THEN** all references SHALL use `ZSH_HERDR_PROJECT_TEMPLATE_PATH` instead

### Requirement: ZSH_HERDR_CLIPBOARD_COPY_CMD

The system SHALL define `ZSH_HERDR_CLIPBOARD_COPY_CMD` as the canonical clipboard copy command variable.
The system SHALL preserve `HERDR_CLIPBOARD_COPY_CMD` as an exported alias.

#### Scenario: Linux variable uses xclip
- **WHEN** `config/linux.zsh` is sourced on Linux
- **THEN** `ZSH_HERDR_CLIPBOARD_COPY_CMD` SHALL default to `xclip -selection clipboard`

#### Scenario: macOS variable uses pbcopy
- **WHEN** `config/osx.zsh` is sourced on macOS
- **THEN** `ZSH_HERDR_CLIPBOARD_COPY_CMD` SHALL default to `pbcopy`

### Requirement: ZSH_HERDR_CLIPBOARD_PASTE_CMD

The system SHALL define `ZSH_HERDR_CLIPBOARD_PASTE_CMD` as the canonical clipboard paste command variable.
The system SHALL preserve `HERDR_CLIPBOARD_PASTE_CMD` as an exported alias.

#### Scenario: Linux variable uses xclip
- **WHEN** `config/linux.zsh` is sourced on Linux
- **THEN** `ZSH_HERDR_CLIPBOARD_PASTE_CMD` SHALL default to `xclip -selection clipboard -o`

#### Scenario: macOS variable uses pbpaste
- **WHEN** `config/osx.zsh` is sourced on macOS
- **THEN** `ZSH_HERDR_CLIPBOARD_PASTE_CMD` SHALL default to `pbpaste`
