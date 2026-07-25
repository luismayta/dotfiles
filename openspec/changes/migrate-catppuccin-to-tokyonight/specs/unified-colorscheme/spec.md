### Requirement: All tools use TokyoNight colorscheme

The system SHALL use TokyoNight as the unified colorscheme across all configurable tools. All previously Catppuccin-themed tools SHALL be migrated to TokyoNight.

#### Scenario: Simple theme swap tools
- **GIVEN** ghostty, wezterm, zed, herdr, or hunk is configured
- **WHEN** the tool reads its theme configuration
- **THEN** the tool SHALL reference a TokyoNight theme variant

#### Scenario: Theme file tools
- **GIVEN** alacritty or yazi is configured
- **WHEN** the tool reads its theme file
- **THEN** the tool SHALL import/reference a TokyoNight theme file
- **AND** the TokyoNight theme file SHALL exist in the expected location

#### Scenario: Plugin-based tools
- **GIVEN** tmux or starship is configured
- **WHEN** the tool loads its theme plugin/preset
- **THEN** the tool SHALL use a TokyoNight-compatible theme
- **AND** status bar/prompt SHALL render with TokyoNight colors
- **AND** no Catppuccin references SHALL remain in the active configuration

### Requirement: No Catppuccin references in active configs

After migration, no active configuration file SHALL contain references to "catppuccin" except:
- Archived openspec changes (historical)
- `.codi/reports/` documentation
- Comments noting the migration history

#### Scenario: Grep verification
- **WHEN** running `grep -ri "catppuccin" zsh/modules/` after migration
- **THEN** zero matches SHALL be found in active config files

### Requirement: Terminal tools inherit TokyoNight colors

Tools without explicit theme support (fd, ripgrep) SHALL inherit colors from the terminal emulator (ghostty/alacritty/wezterm) which now uses TokyoNight.

#### Scenario: fd and ripgrep output
- **GIVEN** the terminal emulator uses TokyoNight
- **WHEN** fd or ripgrep produces colored output
- **THEN** colors SHALL be consistent with the TokyoNight palette via terminal inheritance
