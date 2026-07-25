## MODIFIED Requirements

### Requirement: Configure Catppuccin theme
The system SHALL configure the TokyoNight colorscheme (storm variant) as the default Neovim theme via a dedicated plugin spec file, replacing the previous Catppuccin configuration.

#### Scenario: TokyoNight storm is the default theme
- **WHEN** Neovim starts
- **THEN** the TokyoNight storm colorscheme SHALL be applied

#### Scenario: Theme respects LazyVim integration
- **WHEN** Neovim starts with LazyVim
- **THEN** the TokyoNight theme SHALL be properly integrated with LazyVim's UI components (bufferline, which-key, noice, etc.)

#### Scenario: Terminal colors are enabled
- **WHEN** a `:terminal` is opened inside Neovim
- **THEN** the terminal SHALL use TokyoNight's terminal color palette

#### Scenario: Plugin auto-detection works
- **WHEN** lazy.nvim loads plugins
- **THEN** TokyoNight SHALL automatically apply integrations for detected plugins (telescope, treesitter, gitsigns, etc.) without manual configuration
