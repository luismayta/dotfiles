## MODIFIED Requirements

### Requirement: Configure Catppuccin theme
The system SHALL configure the Catppuccin colorscheme (macchiato variant) as the default Neovim theme via a dedicated plugin spec file.

#### Scenario: Catppuccin is the default theme
- **WHEN** Neovim starts
- **THEN** the Catppuccin macchiato colorscheme SHALL be applied

#### Scenario: Theme respects LazyVim integration
- **WHEN** Neovim starts with LazyVim
- **THEN** the Catppuccin theme SHALL be properly integrated with LazyVim's UI components (bufferline, which-key, noice, etc.)

## ADDED Requirements

### Requirement: Catppuccin is the active theme (not fallback)
The Catppuccin Macchiato colorscheme SHALL be the active default theme, not merely a lazy.nvim fallback.

#### Scenario: Catppuccin loads before any UI components
- **WHEN** Neovim finishes loading
- **THEN** `vim.cmd.colorscheme("catppuccin-macchiato")` SHALL have been executed
- **AND** the catppuccin plugin spec SHALL have `lazy = false` to ensure it loads before UI plugins

#### Scenario: dankcolors is disabled
- **WHEN** Neovim starts
- **THEN** the `dankcolors.lua` plugin spec SHALL be set to `enabled = false`
- **AND** Neovim SHALL NOT load the base16-nvim colorscheme

## REMOVED Requirements

### Requirement: Configure Catppuccin theme (mocha variant)
**Reason**: Replaced by macchiato variant to unify with the dotfiles standard (6 tools already use Macchiato)
**Migration**: Use `catppuccin-macchiato` instead of `catppuccin-mocha` in the plugin setup
