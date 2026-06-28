## ADDED Requirements

### Requirement: Unify terminal font to JetBrainsMono Nerd Font
All terminal emulators in the dotfiles SHALL use `JetBrainsMono Nerd Font` as the primary font family.

#### Scenario: Ghostty uses JetBrainsMono Nerd Font
- **WHEN** Ghostty loads configuration from `zsh/modules/ghostty/data/config`
- **THEN** `font-family` SHALL be `"JetBrainsMono Nerd Font"`

#### Scenario: Alacritty uses JetBrainsMono Nerd Font
- **WHEN** Alacritty loads configuration from `zsh/modules/alacritty/data/core.toml`
- **THEN** `font.normal.family`, `font.bold.family`, `font.italic.family`, and `font.bold_italic.family` SHALL be `"JetBrainsMono Nerd Font"`

#### Scenario: Wezterm uses JetBrainsMono Nerd Font
- **WHEN** Wezterm loads configuration from `zsh/modules/wezterm/data/config/fonts.lua`
- **THEN** `font_family` SHALL be `"JetBrainsMono Nerd Font"`

### Requirement: Unify editor font to JetBrainsMono Nerd Font
All code editors in the dotfiles SHALL use `JetBrainsMono Nerd Font` for both UI and buffer fonts, except tools with separate font needs (e.g., CodeSnap).

#### Scenario: Zed uses JetBrainsMono Nerd Font
- **WHEN** Zed loads configuration from `zsh/modules/zed/data/settings.json`
- **THEN** `ui_font_family` SHALL be `"JetBrainsMono Nerd Font"`
- **THEN** `buffer_font_family` SHALL be `"JetBrainsMono Nerd Font"`

### Requirement: Provision JetBrainsMono Nerd Font on Linux
The dotfiles provisioning system SHALL install JetBrainsMono Nerd Font on Linux systems.

#### Scenario: Linux package list includes JetBrainsMono Nerd Font
- **WHEN** provisioning runs on Linux via `config/packages.sh`
- **THEN** the package list SHALL include `ttf-jetbrains-mono-nerd` (or equivalent distro package)

#### Scenario: macOS provisioning includes JetBrainsMono Nerd Font
- **WHEN** provisioning runs on macOS
- **THEN** the font provisioning SHALL include JetBrainsMono Nerd Font (via brew cask or font directory)

### Requirement: Legacy fonts remain unchanged
GVim (`conf/app/gvimrc`) and Terminal.app Nord (`provision/themes/Nord.terminal`) SHALL NOT be modified, as they use Powerline-patched fonts without Nerd Font support.

#### Scenario: GVim font is preserved
- **WHEN** reviewing font configurations
- **THEN** `conf/app/gvimrc` SHALL retain `Inconsolata for Powerline`

#### Scenario: Terminal.app Nord font is preserved
- **WHEN** reviewing font configurations
- **THEN** `provision/themes/Nord.terminal` SHALL retain `SourceCodePro-Regular`
