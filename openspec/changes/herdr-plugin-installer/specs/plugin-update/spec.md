## ADDED Requirements

### Requirement: Update a single plugin

The system SHALL update a specific herdr plugin by reinstalling it via `herdr plugin install <shorthand> --yes` (herdr's idempotent install replaces managed checkouts).

#### Scenario: Update a specific plugin
- **WHEN** the user calls `herdr::plugin::update "0x5c0f/herdr-insight"`
- **THEN** the system runs `herdr plugin install 0x5c0f/herdr-insight --yes`
- **AND** displays a success message

#### Scenario: Update all configured plugins
- **WHEN** the user calls `herdr::plugin::update::all`
- **THEN** the system iterates over `ZSH_HERDR_INSTALL_PLUGINS`
- **AND** reinstalls each plugin via `herdr plugin install`
