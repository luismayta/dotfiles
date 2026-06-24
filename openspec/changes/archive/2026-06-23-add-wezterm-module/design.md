## Context

<!-- Background and current state -->

The dotfiles project provides ZSH modules under `zsh/modules/` following a three-layer architecture: `config/`, `internal/`, `pkg/`. The reference implementation is `ghostty/` which manages config sync for Ghostty terminal. Wezterm is the primary terminal on this system, with a modular Lua configuration stored on an external drive (`/run/media/lucho/Jasper/.config/wezterm/`). The config is structured as a Lua-based project with `config/`, `events/`, `backdrops/`, `colors/`, and `utils/` directories.

The module must:
- Sync wezterm config from the data source to `~/.config/wezterm/`
- Install wezterm if missing (Arch Linux via `paru`, macOS via `brew`)
- Provide shell-level convenience commands

## Goals / Non-Goals

**Goals:**
- Create a ZSH module following the `ghostty/` pattern with full three-layer architecture
- Auto-sync wezterm Lua config files from `data/` to `~/.config/wezterm/`
- Auto-install wezterm binary if not present
- Expose `wezterm::install`, `wezterm::sync`, `wezterm::setup` public API
- Provide `editwezterm` alias to open the module data path
- Populate `data/` with the full wezterm config from the external source

**Non-Goals:**
- Modifying or transforming the wezterm Lua config (pure sync)
- Managing wezterm versions or upgrades
- Cross-platform config differences (Linux-only for now; macOS placeholders created)

## Decisions

<!-- Key design decisions and rationale -->

1. **Module name**: `wezterm` — matches binary name, consistent with `ghostty`, `zed`, `nvim` modules
2. **Config sync via rsync**: Same approach as ghostty — `rsync -avh --no-perms` copies everything from `data/` to `~/.config/wezterm/`. This preserves the modular Lua structure.
3. **Data path**: Config data stored under `zsh/modules/wezterm/data/` synced from `/run/media/lucho/Jasper/.config/wezterm/` — keeps the external drive as source of truth while allowing local sync
4. **Install mechanism**: Use `core::ensure wezterm` which delegates to `paru` on Arch / `brew` on macOS via `zsh/core/`
5. **No brew dependency check**: Unlike ghostty, wezterm is available via `paru` on Arch so we skip the brew requirement; `core::install` handles it
6. **File structure**: Mirror ghostty exactly — `plugin.zsh` → `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh` with OS dispatch at each layer

## Risks / Trade-offs

<!-- Known risks and trade-offs -->

- **External drive dependency**: Data source is on external drive; initial `data/` population is manual. Mitigation: populate once during module creation, subsequent syncs are local.
- **Config size**: Backdrop images (~15 JPG/PNG files) add ~50MB to the repo. Mitigation: include them — they're part of the config and the repo already handles binary files.
- **rsync required**: Module needs rsync for config sync. Mitigation: `internal/main.zsh` ensures rsync is installed via `core::install rsync`.
