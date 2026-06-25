# Tasks: Port Alacritty Module

## Layer 1: Scaffold module structure

- [x] 1.1 Create `zsh/modules/alacritty/plugin.zsh` with `__ZSH_ALACRITTY_LOADED` guard and `ALACRITTY_PATH` — mirrors ghostty pattern
- [x] 1.2 Create `zsh/modules/alacritty/config/base.zsh` with env vars (`ALACRITTY_PACKAGE_NAME`, `ALACRITTY_DATA_PATH`, `ALACRITTY_FILE_SETTINGS`, `ALACRITTY_THEMES_PATH`)
- [x] 1.3 Create `zsh/modules/alacritty/config/main.zsh` with OS dispatch sourcing `osx.zsh` + `linux.zsh` before `base.zsh`
- [x] 1.4 Create `zsh/modules/alacritty/config/osx.zsh` with `ALACRITTY_APPLICATION=/Applications/Alacritty.app`
- [x] 1.5 Create `zsh/modules/alacritty/config/linux.zsh` (placeholder)

## Layer 2: Internal functions

- [x] 2.1 Create `zsh/modules/alacritty/internal/base.zsh` with `alacritty::internal::conf::sync` (rsync data/ → `~/.config/alacritty/`) and `alacritty::internal::alacritty::install` (via `core::install alacritty`)
- [x] 2.2 Create `zsh/modules/alacritty/internal/main.zsh` with factory + rsync dependency check (`if ! core::exists rsync; then core::install rsync; fi`)
- [x] 2.3 Create `zsh/modules/alacritty/internal/helper.zsh` (placeholder)
- [x] 2.4 Create `zsh/modules/alacritty/internal/osx.zsh` (placeholder)
- [x] 2.5 Create `zsh/modules/alacritty/internal/linux.zsh` (placeholder)

## Layer 3: Package/user-facing commands

- [x] 3.1 Create `zsh/modules/alacritty/pkg/base.zsh` with `alacritty::dependences`, `alacritty::sync`, `alacritty::install`, `alacritty::post_install`
- [x] 3.2 Create `zsh/modules/alacritty/pkg/helper.zsh` with `editalacritty()` using `"${EDITOR}" "${ALACRITTY_PATH}"`
- [x] 3.3 Create `zsh/modules/alacritty/pkg/alias.zsh` (placeholder)
- [x] 3.4 Create `zsh/modules/alacritty/pkg/main.zsh` with factory + auto-install guard (`if ! core::exists alacritty; then alacritty::install; fi`)
- [x] 3.5 Create `zsh/modules/alacritty/pkg/osx.zsh` (placeholder)
- [x] 3.6 Create `zsh/modules/alacritty/pkg/linux.zsh` (placeholder)

## Layer 4: Data files

- [x] 4.1 Create `zsh/modules/alacritty/data/alacritty.toml` — imports core.toml + catppuccin-mocha theme
- [x] 4.2 Create `zsh/modules/alacritty/data/core.toml` — font, colors, cursor, window, env (with `TMUX_SOCKET=alacritty`), scrolling, mouse config
- [x] 4.3 Copy catppuccin themes from standalone `conf/themes/` → `data/themes/catppuccin/*.toml`

## Verification

- [x] 5.1 Verify `zsh/modules/alacritty/plugin.zsh` exists in module dir — will be picked up by zshrc `for __module_dir` loop automatically
- [x] 5.2 Run `source plugin.zsh` and verify no errors — module loaded cleanly (`core::exists`/`core::install` warnings expected — these come from zsh-core which loads first in real zshrc)
- [ ] 5.3 Run `alacritty::sync` and verify files land in `~/.config/alacritty/` — **requires running in real zsh session** (rsync + core::exists needed)
- [ ] 5.4 Run `editalacritty` and verify it opens the module path in `$EDITOR` — **requires interactive zsh session with EDITOR set**
- [ ] 5.5 Run `alacritty::install` and verify idempotency (skips if already installed) — **requires interactive zsh session**
