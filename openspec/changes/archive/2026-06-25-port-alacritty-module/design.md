# Design: Alacritty Module

## Architecture

The alacritty module follows the same 4-layer architecture as ghostty:

```
plugin.zsh (entrypoint, idempotency guard)
  └─ config/main.zsh (env var setup)
       └─ base.zsh (ALACRITTY_PACKAGE_NAME, DATA_PATH, FILE_SETTINGS, THEMES_PATH)
       └─ osx.zsh / linux.zsh (OS-specific vars)
  └─ internal/main.zsh (config sync, install logic)
       └─ base.zsh (conf::sync via rsync, alacritty::install via core::install)
       └─ helper.zsh / osx.zsh / linux.zsh (placeholders)
  └─ pkg/main.zsh (user-facing commands + auto-install)
       └─ base.zsh (dependences, sync, install, post_install)
       └─ helper.zsh (editalacritty function)
       └─ alias.zsh / osx.zsh / linux.zsh (placeholders)
```

## Naming Conventions

- **Module path variable:** `ALACRITTY_PATH` (set in `plugin.zsh`)
- **Idempotency guard:** `__ZSH_ALACRITTY_LOADED`
- **Config env vars:**
  - `ALACRITTY_PACKAGE_NAME=alacritty`
  - `ALACRITTY_DATA_PATH="${ALACRITTY_PATH}/data"`
  - `ALACRITTY_FILE_SETTINGS="${ALACRITTY_DATA_PATH}/alacritty.toml"`
  - `ALACRITTY_THEMES_PATH="${ALACRITTY_DATA_PATH}/themes"`
  - `ALACRITTY_APPLICATION=/Applications/Alacritty.app` (macOS only)
- **Function names:** `alacritty::*` (3-level namespace matching layer)

## Data Layer

The `data/` directory mirrors what the standalone module kept in `conf/`:

```
data/
├── alacritty.toml          # Entry point — TOML imports
├── core.toml               # Font, colors, cursor, window, env, scrolling
└── themes/
    └── catppuccin/         # Catppuccin TOML theme files
        ├── catppuccin-latte.toml
        ├── catppuccin-macchiato.toml
        └── catppuccin-mocha.toml
```

- `alacritty.toml` uses `import = ["~/.config/alacritty/core.toml", "~/.config/alacritty/themes/catppuccin/catppuccin-mocha.toml"]`
- `core.toml` sets font (FiraCode Nerd Font 20pt), opacity 0.8, padding 4px, Block cursor
- `env.TMUX_SOCKET = "alacritty"` set in `core.toml`
- Synced to `~/.config/alacritty/` via rsync

## Sync Flow

```
alacritty::sync
  → alacritty::internal::conf::sync
    → rsync -avh --no-perms "${ALACRITTY_DATA_PATH}/" "${HOME}/.config/alacritty/"
```

## Install Flow

```
alacritty::install (called from pkg/main.zsh if not on PATH)
  → alacritty::internal::alacritty::install
    → core::install alacritty (handles brew/cargo/apt based on OS)
```

## Edit Alias

```
function editalacritty {
    "${EDITOR}" "${ALACRITTY_PATH}"
}
```

Following the same pattern as `editghostty` and `editwezterm`.

## TMUX_SOCKET Integration

The `data/core.toml` sets `env.TMUX_SOCKET = "alacritty"`, which the tmux helper module (`core/pkg/helper/tmux.zsh`) reads to connect to the correct socket. This is identical to ghostty's `env.TMUX_SOCKET=ghostty` pattern.

## What NOT to Port

The standalone module has a `core/` layer (with `base.zsh`, `osx.zsh`, `linux.zsh`) that is empty or contains only stubs. These were dependency placeholders for the hadenlabs framework and have no equivalent in the monorepo pattern. **Skipped.** The ghostty module also doesn't have this layer.
