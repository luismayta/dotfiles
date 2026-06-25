# Proposal: Port Alacritty Module into Dotfiles Monorepo

## Summary

Port the standalone `hadenlabs/zsh-alacritty` module into the dotfiles monorepo at `zsh/modules/alacritty/`, following the ghostty module pattern exactly — config sync via rsync, theme management, auto-install, and alias editing.

## Motivation

Alacritty is a primary terminal on this system (alongside ghostty and wezterm). Its configuration is currently maintained outside the dotfiles monorepo in a standalone zsh module at `/home/lucho/Projects/src/github.com/hadenlabs/zsh-alacritty/`. Bringing it into the monorepo gives us:

- **Single source of truth** — all terminal configs in one repo
- **Consistent module pattern** — same structure as ghostty, wezterm
- **Auto-sync + auto-install** — config files synced via `ghostty::sync`-style rsync, brew install if missing
- **`"${EDITOR}"` standard** — edit aliases use `"${EDITOR}"` not hardcoded `code`
- **TMUX_SOCKET integration** — consistent cross-terminal tmux socket naming

## Approach

1. Create `zsh/modules/alacritty/` mirroring ghostty's file structure
2. Port config variables, internal functions, package functions from the standalone module
3. Adapt syntax to `shellcheck shell=bash` convention (ghostty style)
4. Place alacritty TOML config in `data/alacritty.toml` and `data/core.toml`
5. Place catppuccin themes in `data/themes/catppuccin/*.toml`
6. Set `env.TMUX_SOCKET=alacritty` in the synced config
7. Use `"${EDITOR}"` in the edit alias
8. Auto-install via `core::install alacritty` if not found on PATH

## Files to Create

~16 files total, following ghostty's exact layout:

```
zsh/modules/alacritty/
├── plugin.zsh              # Entrypoint, sets ALACRITTY_PATH, chain-loads
├── config/
│   ├── main.zsh            # OS-dispatch
│   ├── base.zsh            # Env vars (PACKAGE_NAME, DATA_PATH, FILE_SETTINGS, THEMES_PATH)
│   ├── osx.zsh             # ALACRITTY_APPLICATION path
│   └── linux.zsh           # (placeholder)
├── internal/
│   ├── main.zsh            # Factory + rsync guard
│   ├── base.zsh            # conf::sync, alacritty::install
│   ├── helper.zsh          # (placeholder)
│   ├── osx.zsh             # (placeholder)
│   └── linux.zsh           # (placeholder)
├── pkg/
│   ├── main.zsh            # Factory + auto-install guard
│   ├── base.zsh            # dependences, sync, install, post_install
│   ├── helper.zsh          # editalacritty alias function
│   ├── alias.zsh           # (empty, aliases in helper.zsh like ghostty)
│   ├── osx.zsh             # (placeholder)
│   └── linux.zsh           # (placeholder)
└── data/
    ├── alacritty.toml      # Main config (imports core.toml + theme)
    ├── core.toml           # Fonts, colors, cursor, window, env settings
    └── themes/
        └── catppuccin/
            ├── catppuccin-latte.toml
            ├── catppuccin-macchiato.toml
            └── catppuccin-mocha.toml
```

## Risk Assessment

| Risk | Mitigation |
|------|-----------|
| Config drift from standalone module | Port is a snapshot; future changes happen in the monorepo `data/`, standalone can be archived |
| Naming collisions | All functions namespaced with `alacritty::*` prefix; module guard `__ZSH_ALACRITTY_LOADED` |
| Missing features from standalone | `core/` layer in standalone is just empty stubs (dependency placeholders), not ported |
| Theme file format drift | TOML catppuccin themes copied verbatim from standalone's `conf/themes/` |
