## ADDED Requirements

### Requirement: Bitwarden CLI integration
The Bitwarden module SHALL provide fzf-based Bitwarden vault item search and clipboard copy for macOS and Linux.

#### Scenario: Module loads on zsh start
- **WHEN** zsh starts and sources `zsh/modules/bitwarden/plugin.zsh`
- **THEN** the module SHALL set `BITWARDEN_PATH` and SHALL source `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh`
- **THEN** the module SHALL define `__ZSH_BITWARDEN_LOADED=1` to prevent double-loading

#### Scenario: Environment variables are set
- **WHEN** the module loads
- **THEN** `BITWARDEN_PACKAGE_NAME` SHALL be `bitwarden`

#### Scenario: Keybinding is registered
- **WHEN** the module loads
- **THEN** `^Xk` SHALL be bound to `fbw` via `bindkey '^Xk' fbw`

#### Scenario: bw CLI search via fzf
- **WHEN** user runs `bw::search` (or `fbw`)
- **THEN** the module SHALL list all Bitwarden vault items via `bw list items`
- **AND** SHALL present an fzf picker with item names
- **AND** SHALL copy the selected item's password to clipboard

#### Scenario: Search items by type
- **WHEN** user runs `bw::search::login`
- **THEN** the module SHALL filter vault items to login type only
- **WHEN** user runs `bw::search::notes`
- **THEN** the module SHALL filter vault items to secure notes only
- **WHEN** user runs `bw::search::cards`
- **THEN** the module SHALL filter vault items to card type only
- **WHEN** user runs `bw::search::all`
- **THEN** the module SHALL list all vault items

#### Scenario: Copy value types
- **WHEN** user selects a login item
- **THEN** the module SHALL call `bw::value::login` to copy the password
- **WHEN** user selects a secure note
- **THEN** the module SHALL call `bw::value::notes` to copy the notes content
- **WHEN** user selects a card item
- **THEN** the module SHALL call `bw::value::cards` to copy the card number

#### Scenario: Internal item parsing
- **WHEN** parsing Bitwarden JSON output
- **THEN** `_get_type` SHALL extract the item type
- **AND** `_get_id` SHALL extract the item ID
- **AND** `_get_type_field` SHALL extract the type-specific field (login.password, notes, card.number)
- **AND** `_get_item_by_type` SHALL filter items by type

#### Scenario: Environment loading
- **WHEN** user runs `bw::load::env`
- **THEN** the module SHALL source the Bitwarden session environment (from `bw login` or `bw unlock`)

#### Scenario: Dependency check
- **WHEN** the module loads
- **THEN** it SHALL ensure `fzf`, `rsync`, and `bw` (Bitwarden CLI) are installed

#### Scenario: Bitwarden CLI installation
- **WHEN** `bw` is not found
- **THEN** the module SHALL install `@bitwarden/cli` via `yarn global add`
