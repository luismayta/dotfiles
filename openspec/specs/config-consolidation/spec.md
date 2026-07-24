## ADDED Requirements

### Requirement: All config in config/ directory
The Neovim configuration SHALL live entirely in `lua/config/` directory. The `lua/core/` directory SHALL NOT exist after this change.

#### Scenario: No core/ directory
- **WHEN** user examines `~/.config/nvim/lua/`
- **THEN** only `config/` and `plugins/` directories exist (no `core/`)

### Requirement: Options loaded from config/options.lua
The system SHALL load Neovim options from `config/options.lua`.

#### Scenario: Options are applied
- **WHEN** Neovim starts
- **THEN** all options from the merged options file are active (updatetime=50, scrolloff=8, wrap=false, foldmethod=manual)

### Requirement: Keymaps loaded from config/keymaps.lua
The system SHALL load all keymaps from `config/keymaps.lua`.

#### Scenario: Keymaps are available
- **WHEN** Neovim starts
- **THEN** all keymaps including `<C-x>` prefix, visual indent, leader-based splits, and terminal toggle are functional

### Requirement: No duplicate option definitions
Options SHALL be defined in exactly one file. No duplicate settings across files.

#### Scenario: Single source of truth
- **WHEN** user searches for `opt.updatetime` across all lua files
- **THEN** exactly one definition exists (in config/options.lua)
