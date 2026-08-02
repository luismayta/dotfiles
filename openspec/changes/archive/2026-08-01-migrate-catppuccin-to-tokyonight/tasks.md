# Tasks: Migrate Catppuccin → TokyoNight

## 1. Simple single-line swaps (low risk)

- [x] 1.1 **ghostty**: Change `theme = Catppuccin Macchiato` → `theme = tokyonight` in `zsh/modules/ghostty/data/config`
- [x] 1.2 **wezterm**: Change `"Catppuccin Macchiato"` → `"Tokyo Night"` in `zsh/modules/wezterm/data/config/color.lua`
- [x] 1.3 **zed**: Change `"Catppuccin Macchiato"` → `"Tokyo Night"` in `zsh/modules/zed/data/settings.json`
- [x] 1.4 **herdr**: Change `name = "catppuccin"` → `name = "tokyo-night"` in `zsh/modules/herdr/data/config.toml`
- [x] 1.5 **hunk**: Change `theme = "catppuccin-macchiato"` → `theme = "tokyonight"` in `zsh/modules/ai/data/hunk/config.toml`

## 2. Theme file downloads + import swaps (medium risk)

- [x] 2.1 **alacritty**: Download `tokyonight.toml` from `alacritty/alacritty-theme` → `zsh/modules/alacritty/data/themes/tokyonight/`
- [x] 2.2 **alacritty**: Update import in `alacritty.toml`: `"~/.config/alacritty/themes/tokyonight/tokyonight.toml"`
- [x] 2.3 **alacritty**: Optionally remove old `catppuccin/` themes directory
- [x] 2.4 **yazi**: Download TokyoNight theme from `BriBian08/tokyonight-yazi` → `zsh/modules/yazi/data/`
- [x] 2.5 **yazi**: Update `syntect_theme` in `zsh/modules/yazi/data/theme.toml`
- [x] 2.6 **yazi**: Update download URL in `zsh/modules/yazi/internal/base.zsh`

## 3. Plugin rewrites (high risk)

- [x] 3.1 **tmux**: Replace `catppuccin/tmux` plugin with `janoamaral/tokyo-night-tmux` in `.tmux.conf`
- [x] 3.2 **tmux**: Remove all `@catppuccin_*` status bar variables from `.tmux.conf`
- [x] 3.3 **tmux**: Verify status bar renders correctly with tokyo-night-tmux
- [x] 3.4 **starship**: Extract TokyoNight color values and apply to existing `starship.toml` palette
- [x] 3.5 **starship**: Update `palette = "catppuccin_macchiato"` → `palette = "tokyonight"`

## 4. Cleanup

- [x] 4.1 Run `grep -ri "catppuccin" zsh/modules/` — verify zero matches
- [x] 4.2 Update openspec spec `openspec/specs/plugin-colorscheme/spec.md` to reference TokyoNight
- [x] 4.3 Verify all tools render correctly (visual smoke test)

## 5. Commit

- [x] 5.1 Stage all changes with descriptive commit message
