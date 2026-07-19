## Why

The waybar zsh module has a fully built lifecycle (install, sync, post_install) but ships zero config — the `data/` directory is empty. We need to bootstrap waybar with a working config and establish a reusable pattern for adding custom modules (scripts that waybar executes as `custom/*` blocks). The MPD module (waybar-mpd-module) serves as the reference implementation: pure Bash scripts, no build system, placed in `~/.config/waybar/scripts/`.

## What Changes

- Create waybar base config (`config` and `style.css`) in `zsh/modules/waybar/data/`
- Set up `zsh/modules/waybar/data/scripts/` as the home for custom module scripts
- Add MPD module scripts (mpd-waybar.sh, is_in_playlist.sh, mpd-heart-toggle.sh) as the first custom module
- Wire MPD custom modules into the waybar config's module list and bar layout
- Document the pattern for adding future custom modules (what files to create, what config blocks to add)

## Capabilities

### New Capabilities

- `waybar-base-config`: Base waybar configuration (config, style.css) with standard modules and bar layout
- `waybar-custom-module-pattern`: Reusable pattern for adding custom modules — script conventions, config block structure, installation into data/scripts/
- `waybar-mpd-module`: MPD music player integration — scrolling song title, play/pause/stop icons, favorite playlist heart toggle

### Modified Capabilities

(none — no existing waybar specs)

## Impact

- `zsh/modules/waybar/data/` — new config files and scripts directory
- `zsh/modules/waybar/pkg/base.zsh` — sync function may need adjustment to handle scripts/ subdirectory
- Waybar runtime — custom modules require their dependencies (mpc, mpd for MPD module)
- Nerd Fonts — icon glyphs require Nerd Font installation (already handled by font specs)
