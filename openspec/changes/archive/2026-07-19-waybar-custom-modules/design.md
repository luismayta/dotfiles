## Context

The waybar zsh module (`zsh/modules/waybar/`) has a complete lifecycle framework — install via `core::install`, config sync via `rsync data/ → ~/.config/waybar/`, and health checks. However, the `data/` directory is empty: no config, no styles, no scripts.

The target is a working waybar setup with custom modules. The reference implementation (waybar-mpd-module) demonstrates the pattern: pure Bash scripts in `~/.config/waybar/scripts/`, invoked by `"custom/*"` blocks in waybar's config. No build system, no compilation — just `chmod +x` and config wiring.

The dotfiles use rsync-based config sync (not stow/symlinks), so all waybar files live under `zsh/modules/waybar/data/` and get synced to `~/.config/waybar/`.

MPD daemon management (install, start, stop) is handled by a separate `zsh/modules/mpd/` module. The waybar MPD scripts only handle the UI layer — querying mpc for display data.

## Goals / Non-Goals

**Goals:**
- Bootstrap waybar with a working base config (modules, bar layout, styling)
- Establish a reusable pattern for adding custom modules (script conventions + config blocks)
- Integrate MPD module as the first custom module
- Keep the pattern simple: Bash scripts, no build system, easy to add new modules

**Non-Goals:**
- Creating a module marketplace or dynamic module loading
- Supporting compiled (C/C++/Rust) custom modules (out of scope for now)
- Waybar theme/design polish (functional first, beauty later)

## Decisions

### 1. Scripts directory: `data/scripts/` → `~/.config/waybar/scripts/`

**Decision**: Place all custom module scripts in `zsh/modules/waybar/data/scripts/`. The existing rsync sync handles the rest — `data/scripts/mpd-waybar.sh` becomes `~/.config/waybar/scripts/mpd-waybar.sh`.

**Rationale**: The rsync already mirrors `data/` → `~/.config/waybar/`. No changes needed to the sync function. Scripts land exactly where waybar expects them.

**Alternative considered**: Separate per-module directories (e.g., `data/modules/mpd/`). Rejected — adds complexity for no benefit. Waybar expects a flat `scripts/` dir.

### 2. Config format: jsonc (single config file)

**Decision**: Use waybar's `config` file in jsonc format (JSON with comments). Single file, not split.

**Rationale**: Waybar's default config format. Comments allowed. Splitting into multiple files requires waybar's `--config` flag or includes, which adds complexity.

**Alternative considered**: Split config (base.jsonc + modules.jsonc). Rejected — waybar doesn't natively support config includes.

### 3. Module registration: explicit blocks in config

**Decision**: Each custom module gets a `"custom/<name>"` block in the config's `"modules-left"` / `"modules-center"` / `"modules-right"` arrays.

**Rationale**: Standard waybar pattern. No magic, no auto-discovery. Adding a module = adding a script + adding a config block.

**Alternative considered**: Auto-discovery of scripts in `scripts/`. Rejected — fragile, no control over module ordering in the bar.

### 4. Script conventions

**Decision**: Follow the MPD module's conventions:
- Scripts are executable Bash (`#!/bin/bash`)
- Long-lived modules use `mpc idle` / `inotifywait` / `sleep` loops (not polling)
- Output is plain text to stdout (waybar reads it)
- Click/scroll handlers are separate scripts or `on-click` commands
- Scripts use Nerd Font icons for status indicators

**Rationale**: Proven pattern from the reference implementation. Event-driven > polling for battery/CPU.

### 5. MPD as separate zsh module

**Decision**: MPD daemon management lives in `zsh/modules/mpd/`, not in waybar. The mpd module handles package installation (mpd, mpc) and service lifecycle (systemd on Linux, brew services on macOS). Waybar scripts only query mpc for display data.

**Rationale**: Separation of concerns. MPD is a standalone service — other tools besides waybar may want to interact with it. The waybar module depends on mpc being available, not on managing the daemon.

**Dependency chain**: `mpd` module (installs mpd + mpc) → `waybar` module (scripts use mpc for display)

## Risks / Trade-offs

- **[Risk] MPD not running** → Module shows empty/error. Mitigation: Scripts handle missing MPD gracefully (check `mpc status` before querying).
- **[Risk] Script permissions** → Scripts must be `chmod +x`. Mitigation: Include `chmod +x` in the sync/post_install step, or document it.
- **[Risk] Nerd Font dependency** → Icons won't render without Nerd Fonts. Mitigation: Already handled by font-install specs; document requirement.
- **[Risk] Module load order** → MPD module must load before waybar scripts run. Mitigation: Module load order is controlled by the user's zshrc; document that mpd should be listed before waybar.
- **[Trade-off] Single config file** → All module config in one place can get large. Accepted — waybar configs are typically <200 lines even with many modules.
