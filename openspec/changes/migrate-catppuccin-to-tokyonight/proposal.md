# Proposal: Migrate Catppuccin → TokyoNight across all modules

## Context

The entire dotfiles ecosystem uses Catppuccin Macchiato as the unified colorscheme. Neovim was already migrated to TokyoNight (storm) in a previous change (`swap-catppuccin-for-tokyonight`). This change extends the migration to all remaining 9 tools.

## What changes

Replace Catppuccin Macchiato with TokyoNight (storm where available) across:

| Tool | Config File | Current | Target |
|------|------------|---------|--------|
| tmux | `zsh/modules/tmux/data/conf/.tmux.conf` | `@catppuccin_flavor 'macchiato'` | `tokyo-night-tmux` plugin |
| starship | `zsh/modules/starship/data/starship.toml` | `palette = "catppuccin_macchiato"` | `starship preset tokyo-night` |
| ghostty | `zsh/modules/ghostty/data/config` | `theme = Catppuccin Macchiato` | `theme = tokyonight` |
| alacritty | `zsh/modules/alacritty/data/alacritty.toml` | `catppuccin/catppuccin-macchiato.toml` | `tokyonight.toml` |
| wezterm | `zsh/modules/wezterm/data/config/color.lua` | `"Catppuccin Macchiato"` | `"Tokyo Night"` |
| zed | `zsh/modules/zed/data/settings.json` | `"Catppuccin Macchiato"` | `"Tokyo Night"` |
| herdr | `zsh/modules/herdr/data/config.toml` | `name = "catppuccin"` | `name = "tokyo-night"` |
| hunk | `zsh/modules/ai/data/hunk/config.toml` | `theme = "catppuccin-macchiato"` | `theme = "tokyonight"` |
| yazi | `zsh/modules/yazi/data/theme.toml` + `base.zsh` | Catppuccin macchiato theme | TokyoNight yazi theme |

## Why

- Visual consistency with the already-migrated Neovim config
- TokyoNight storm has better contrast and readability than Catppuccin Macchiato
- User preference: "más bonito"

## Out of scope

- `fd` and `ripgrep`: no theme system (they inherit terminal colors)
- Archived openspec changes: historical artifacts, not migrated
- `.codi/reports/` and `.codi/jira/`: documentation references only

## Risk

- tmux: The `catppuccin/tmux` plugin provides status bar components (`@catppuccin_status_*`). Replacing it requires a different plugin or manual status bar config.
- starship: `starship preset tokyo-night` overwrites the entire config — must merge with existing customizations.
- yazi: The theme file references a `.tmTheme` file that needs to be downloaded/installed.
