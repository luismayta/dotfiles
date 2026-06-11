## Context

The dotfiles project uses a modular zsh architecture under `zsh/modules/<name>/`. The tmux module (`zsh/modules/tmux/`) served as structural reference with its `data/` directory containing dotfiles. The Hyprland module follows the same module layout but with a simpler sync pattern: `data/` contents go directly to `~/.config/hypr/`.

```
hyprland/
├── plugin.zsh      # Entry point (sourced by .zshrc)
├── config/         # Variables and paths (base.zsh + OS dispatcher)
├── data/
│   └── hypr/       # Lua config files → rsync → ~/.config/hypr/
├── internal/       # Private install functions
└── pkg/            # Public API (install, sync, post_install) + helpers + aliases
```

DankMaterialShell (`AvengeMedia/DankMaterialShell`) provides reference Hyprland Lua configurations for keybinds, window rules, layout, outputs, cursor, and colors. These use Hyprland's native Lua API (`hl.*`) introduced in Hyprland 0.55.

**Key constraint**: Hyprland is Linux-only (Wayland compositor). The module must gracefully no-op on macOS.

## Goals / Non-Goals

**Goals:**
- Create `zsh/modules/hyprland/` with identical structure to `zsh/modules/tmux/`
- Provide declarative Lua configs for Hyprland synced via `data/hypr/` → `rsync` → `~/.config/hypr/`
- Install Hyprland and ecosystem packages (hypridle, hyprlock, hyprpaper, waybar, dunst) on Linux
- Expose `hyprland::install`, `hyprland::sync`, `hyprland::post_install` public API
- Provide helper commands: `edithypr`, workspace/session management, wallpaper helpers
- OS dispatch: module only activates when `$OSTYPE == linux*`

**Non-Goals:**
- macOS/Hyprland support (not possible — Wayland-only)
- Integration with specific display managers (SDDM, GDM) — that belongs in system config, not zsh module
- Theme generation via Matugen (that's DMS-specific tooling; we provide static Catppuccin colors instead)
- QML shell components (not in scope for a zsh dotfiles module)

## Decisions

### 1. Lua config format over .conf
**Decision**: Use Hyprland's native Lua format (`hyprland.lua` with `require()` includes).
**Rationale**: Lua is more expressive (conditionals, variables, loops), is natively supported since Hyprland 0.55, and matches the reference implementation from DankMaterialShell. The modular `require("dms.*")` pattern maps cleanly to separate files per concern.
**Alternatives considered**: `.conf` format is simpler but less maintainable for modular configs.

### 2. Modular config split (one file per concern)
**Decision**: Split config into `hyprland.lua` (main, orchestrates requires) + separate files for binds, windowrules, layout, outputs, cursor, colors, binds-user.
**Rationale**: Mirrors the DankMaterialShell approach where each concern has its own file. Makes it easy to override or replace individual sections without touching the whole config. Follows the principle of separation of concerns.
**Alternatives considered**: Single monolithic file — simpler initially but harder to maintain.

### 3. Package manager abstraction via `core::install`
**Decision**: Use the existing `core::install` and `core::exists` functions (same as tmux module).
**Rationale**: The dotfiles already abstract package management through `core::install`, which dispatches to `brew` (macOS) or the appropriate Linux package manager. Hyprland packages on Arch use `pacman`, on NixOS they come via the flake. `core::install` handles this.
**Alternatives considered**: Hardcoding `pacman -S` — breaks on NixOS and other distros.

### 4. Sync: `data/hypr/` → `~/.config/hypr/`
**Decision**: Sync is direct: `rsync $HYPRLAND_PATH/data/` → `~/.config/`.
**Rationale**: Hyprland reads configs from `~/.config/hypr/`. Unlike tmux (which has files at `$HOME/.tmux.conf` AND subdirectories under `~/.config/`), Hyprland configs live entirely under `~/.config/hypr/`. A single rsync from `data/` to `~/.config/` is cleaner and avoids unnecessary nesting.

### 5. Catppuccin Mocha theme as default colors
**Decision**: Ship Catppuccin Mocha colors matching the tmux module's status bar theme.
**Rationale**: Consistency with the existing tmux config which uses Catppuccin Mocha. Users can override via `hypr-colors.lua`.

### 6. Linux-only dispatch
**Decision**: `config/main.zsh` checks `$OSTYPE` and only sources Hyprland config on `linux*`.
**Rationale**: Hyprland is a Linux-only Wayland compositor. The module should be loadable on macOS (no crash) but do nothing.

## Risks / Trade-offs

- **[Lua version requirement]** Hyprland < 0.55 does not support Lua configs. **Mitigation**: Document minimum version requirement. Users on older Hyprland can manually use `.conf` equivalents.
- **[Package availability]** `hypridle`, `hyprlock`, `hyprpaper`, `waybar`, `dunst` may have different package names across distros. **Mitigation**: Rely on `core::install` abstraction; add distro-specific package name mappings in `internal/` if needed.
- **[Breaking Hyprland updates]** Hyprland is rapidly developed — Lua API may change. **Mitigation**: Pin to known-stable patterns; track Hyprland releases for breaking changes.
- **[macOS no-op]** Importing the module on macOS should not error. **Mitigation**: OS-level dispatch in `config/main.zsh` and `internal/main.zsh` with empty stubs for non-Linux.