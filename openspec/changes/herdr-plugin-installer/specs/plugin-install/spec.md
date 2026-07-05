## ADDED Requirements

### Requirement: Install a single plugin from GitHub shorthand

The system SHALL install a herdr plugin using `herdr plugin install <shorthand>` when given a GitHub shorthand (e.g., `owner/repo` or `owner/repo/subdir`).

#### Scenario: Install a plugin successfully
- **WHEN** the user calls `herdr::plugin::install "0x5c0f/herdr-insight"`
- **THEN** the system runs `herdr plugin install 0x5c0f/herdr-insight --yes`
- **AND** displays a success message with the plugin name

#### Scenario: Install fails due to invalid shorthand
- **WHEN** the user calls `herdr::plugin::install "invalid-shorthand"`
- **THEN** the system displays an error message indicating installation failed

#### Scenario: Install when herdr binary is missing
- **WHEN** the herdr binary is not installed
- **THEN** the system displays an error message and does not attempt installation

### Requirement: Bulk install all configured plugins

The system SHALL iterate over `ZSH_HERDR_INSTALL_PLUGINS` and install any missing plugins.

#### Scenario: Bulk install all configured plugins
- **WHEN** `ZSH_HERDR_INSTALL_PLUGINS` contains `("0x5c0f/herdr-insight" "yigitkonur/herdr-pm")`
- **AND** neither plugin is installed
- **THEN** both plugins are installed via `herdr plugin install`

#### Scenario: Bulk install with empty array
- **WHEN** `ZSH_HERDR_INSTALL_PLUGINS` is empty
- **THEN** no installation occurs and the function returns successfully

#### Scenario: Bulk install skips already-installed plugins
- **WHEN** one plugin from the array is already installed
- **THEN** only missing plugins are installed
- **AND** already-installed plugins are skipped with an info message
