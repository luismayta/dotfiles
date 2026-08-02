# Design: Migrate Catppuccin → TokyoNight across all modules

## Overview

Replace Catppuccin Macchiato with TokyoNight across 9 tools. Each tool has a different theme mechanism, so the approach is per-tool.

## Per-Tool Design

### 1. tmux
- **Current**: `catppuccin/tmux` plugin v2.1.0 with `@catppuccin_flavor 'macchiato'` and status bar components
- **Target**: `janoamaral/tokyo-night-tmux` plugin — provides native Tokyo Night theme with status bar
- **Change**: Replace plugin line, remove all `@catppuccin_*` status bar vars, use tokyo-night-tmux defaults
- **Risk**: Status bar layout will change (tokyo-night-tmux has its own status components)

### 2. starship
- **Current**: Custom palette `catppuccin_macchiato` with hand-picked colors
- **Target**: `starship preset tokyo-night -o starship.toml` — but this overwrites everything
- **Better approach**: Extract tokyonight color values from the preset, apply them to the existing custom palette sections. Keep the existing prompt layout, just swap colors.
- **Key colors**: Blue=#7aa2f7, Purple=#bb9af7, Cyan=#7dcfff, Green=#9ece6a, Red=#f7768e, Yellow=#e0af68, Orange=#ff9e64

### 3. ghostty
- **Current**: `theme = Catppuccin Macchiato`
- **Target**: `theme = tokyonight` (built-in support via folke/tokyonight.nvim extras)
- **Change**: Single line edit

### 4. alacritty
- **Current**: Imports `catppuccin/catppuccin-macchiato.toml` from themes dir
- **Target**: Download `tokyonight.toml` from `alacritty/alacritty-theme`, replace import
- **Change**: Swap import path, download new theme file, optionally delete old catppuccin themes dir

### 5. wezterm
- **Current**: `color_scheme = "Catppuccin Macchiato"`
- **Target**: `color_scheme = "Tokyo Night"` (built-in WezTerm scheme)
- **Change**: Single string replacement in color.lua

### 6. zed
- **Current**: `"theme": "Catppuccin Macchiato"`
- **Target**: `"theme": "Tokyo Night"` (built-in Zed theme)
- **Change**: Single string replacement in settings.json

### 7. herdr
- **Current**: `name = "catppuccin"`
- **Target**: `name = "tokyo-night"` (herdr has built-in tokyo-night support per config comments)
- **Change**: Single string replacement

### 8. hunk
- **Current**: `theme = "catppuccin-macchiato"`
- **Target**: `theme = "tokyonight"` (hunk uses ghostty themes)
- **Change**: Single string replacement

### 9. yazi
- **Current**: `syntect_theme` points to Catppuccin `.tmTheme`, `base.zsh` downloads catppuccin flavors
- **Target**: TokyoNight yazi theme from `BriBian08/tokyonight-yazi`
- **Change**: Download tokyonight theme, update `theme.toml` reference, update `base.zsh` download URL

## Approach Order

1. **Simple single-line swaps** (ghostty, wezterm, zed, herdr, hunk) — lowest risk
2. **Theme file downloads + import swaps** (alacritty, yazi) — medium risk
3. **Complex plugin rewrites** (tmux, starship) — highest risk, save for last

## Verification

After each tool migration:
- Launch the tool and verify colors render correctly
- For tmux: verify status bar renders and is functional
- For starship: verify prompt renders with correct colors
