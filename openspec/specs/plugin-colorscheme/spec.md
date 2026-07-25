## MODIFIED Requirements

### Requirement: Configure TokyoNight theme
The system SHALL configure the TokyoNight colorscheme (storm variant) as the default Neovim theme via a dedicated plugin spec file.

#### Scenario: TokyoNight is the default theme
- **WHEN** Neovim starts
- **THEN** the TokyoNight storm colorscheme SHALL be applied

#### Scenario: Theme respects LazyVim integration
- **WHEN** Neovim starts with LazyVim
- **THEN** the TokyoNight theme SHALL be properly integrated with LazyVim's UI components (bufferline, which-key, noice, etc.)

#### Scenario: TokyoNight across all tools
- **WHEN** any terminal tool starts (tmux, starship, alacritty, ghostty, wezterm, zed, yazi, herdr, hunk)
- **THEN** the TokyoNight color palette SHALL be applied consistently
