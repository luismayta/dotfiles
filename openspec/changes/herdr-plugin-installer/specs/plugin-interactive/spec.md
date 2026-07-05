## ADDED Requirements

### Requirement: FZF-based interactive plugin management

The system SHALL provide an interactive `hrd::plugin` function using fzf to select and manage plugins, following the same pattern as `hrd` and `hrdk` in `pkg/helper.zsh`.

#### Scenario: Interactive plugin menu with configured plugins
- **WHEN** the user calls `hrd::plugin` with no arguments
- **THEN** the system presents an fzf selector with options: install, list, update, uninstall
- **AND** executes the chosen action

#### Scenario: Install via interactive menu
- **WHEN** the user selects "install" from `hrd::plugin`
- **THEN** the system installs all plugins from `ZSH_HERDR_INSTALL_PLUGINS` that are not yet installed

#### Scenario: List via interactive menu
- **WHEN** the user selects "list" from `hrd::plugin`
- **THEN** the system displays currently installed plugins

#### Scenario: Update via interactive menu
- **WHEN** the user selects "update" from `hrd::plugin`
- **THEN** the system reinstalls all configured plugins

#### Scenario: Uninstall via interactive menu
- **WHEN** the user selects "uninstall" from `hrd::plugin`
- **THEN** the system presents a list of installed plugins via fzf
- **AND** uninstalls the selected plugin
