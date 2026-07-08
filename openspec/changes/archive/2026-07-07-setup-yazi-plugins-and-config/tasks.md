## 1. Add source assets

- [x] 1.1 Create `zsh/modules/yazi/data/package.toml` with pinned plugin and flavor dependencies (full-border@c2c16c8, no-status@c2c16c8, starship@a837101, catppuccin-mocha@36c49ac)
- [x] 1.2 Create `zsh/modules/yazi/data/init.lua` with full-border, no-status, starship plugin loading and custom "size perms mtime" linemode with Catppuccin-colored permissions
- [x] 1.3 Create `zsh/modules/yazi/data/yazi.toml` with `[mgr] linemode = "custom"` and other sensible defaults

## 2. Update sync function

- [x] 2.1 Extend `yazi::internal::config::sync` in `zsh/modules/yazi/internal/base.zsh` to rsync `init.lua`, `yazi.toml`, and `package.toml` alongside the existing `theme.toml` (no change needed — existing `rsync -avzh "${ZSH_YAZI_DATA_PATH}/" "${ZSH_YAZI_CONFIG_DIR}/"` already copies all files in `data/`, new files are picked up automatically)

## 3. Verify

- [x] 3.1 Run `yazi::sync` and confirm all four files exist in `~/.config/yazi/`
- [x] 3.2 Launch `yazi` and verify plugins load and linemode renders correctly
