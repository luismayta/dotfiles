## Why

Our Hyprland Lua config (`zsh/modules/hyprland/data/`) is functional but lacks several capabilities present in the [omarchy](https://github.com/basecamp/omarchy) project — a mature Hyprland configuration framework. The omarchy default modules offer richer window rules, clipboard workarounds, notification management, dynamic monitor scaling, detailed animation curves, keyboard/hardware controls, and a more comprehensive window/group management system.

Adopting selected patterns from omarchy will improve daily UX without requiring a full framework migration.

## What Changes

### Window Rules & App Config (`configs/rules.lua`)
- Add tag-based window rule system (e.g., `+terminal`, `+chromium-based-browser`, `+floating-window`)
- Add per-app window tweaks: terminal opacity, browser opacity, JetBrains `no_follow_mouse`, Bitwarden `no_screen_share`, floating window centering/sizing
- Add media app opacity rules (VLC, mpv, imv, Zoom)
- Add screen sharing notification window rule

### Clipboard (`configs/binds/window.lua`)
- Add universal clipboard bindings (`SUPER+C`/`SUPER+V`/`SUPER+X`) using `send_shortcut_once` workaround for XWayland clipboard

### Window Management (`configs/binds/window.lua`)
- Add pop-out (float+pin) bind, close-all-windows, pseudo window toggle
- Add fine-grained resize binds (small/large increments via ALT/CTRL modifiers)
- Add workspace navigation: next/prev/former workspace

### Group Management (`configs/binds/window.lua`)
- Add move-window-to-group (directional), group window index (1-5) binds

### Hardware Controls (`configs/binds/window.lua`)
- Add keyboard backlight up/down/cycle, touchpad toggle/on/off
- Add precise volume/brightness controls (ALT + XF86 keys, ±1% increments)

### System & Utility Binds (`configs/binds/workspace.lua`)
- Add notification controls: dismiss last/all, silence toggle, restore last
- Add lock system bind, color picker, OCR from screenshot
- Add window transparency/gaps toggles
- Add zoom in/reset binds

### Look'n'Feel (`configs/` — new or existing)
- Adopt omarchy animation curves and bezier configuration
- Add groupbar styling (font, colors, indicator, gradients)
- Add scrolling layout column width default
- Add cursor config (hide on key press, warp on workspace change)
- Add misc config (disable logo, focus on activate, ANR settings)

### Environment Variables (`configs/envs.lua`)
- Add comprehensive Wayland forcing: `GDK_BACKEND`, `MOZ_ENABLE_WAYLAND`, `OZONE_PLATFORM`
- Add `XDG_CURRENT_DESKTOP`/`XDG_SESSION_DESKTOP` for screen sharing

### Monitor Management (`configs/binds/monitor.lua` + new scripts)
- Add monitor scaling cycle (`SUPER+=` / `SUPER+ALT+=`) cycling through 1x, 1.25x, 1.6x, 2x, 3x, 4x with matching GDK_SCALE
- Improve internal display toggle (`SUPER+CTRL+Delete`) with safety check (won't disable without external monitor)
- Add internal display mirror toggle (`SUPER+CTRL+ALT+Delete`)
- Add Lid Switch auto-handling: disable internal on close, enable on open
- Add focus next/previous monitor (`CTRL+ALT+TAB` / `CTRL+ALT+SHIFT+TAB`)
- Add move workspace to adjacent monitor (`SUPER+SHIFT+ALT+arrows`)

### Autostart (`configs/execs.lua`)
- Add optional desktop portal autostart, polkit agent

## Capabilities

### New Capabilities
- `clipboard-bindings`: Universal clipboard shortcuts (copy/paste/cut) with XWayland `send_shortcut_once` workaround
- `window-rules-tagging`: Tag-based window rule system for opacity, floating, tiling, and per-app behavior
- `group-management-enhanced`: Extended group navigation (directional move, window index 1-5)
- `hardware-controls`: Keyboard backlight, touchpad toggle, precise volume/brightness
- `notification-controls`: Dismiss, silence, restore last notification
- `workspace-navigation-enhanced`: Next/prev/former workspace, focus next/prev monitor, move workspace to adjacent monitor
- `monitor-management`: Scaling cycle, internal display toggle (with safety), lid switch handling, mirror toggle
- `utility-binds`: Lock, color picker, OCR, zoom, transparency/gaps toggles
- `looknfeel-animations`: Animation curves, bezier config, groupbar styling
- `envs-wayland`: Comprehensive Wayland environment variable setup

### Modified Capabilities
*(No existing specs to modify — first time using openspec for this area)*

## Impact

- **Files modified**: `zsh/modules/hyprland/data/configs/rules.lua`, `zsh/modules/hyprland/data/configs/binds/window.lua`, `zsh/modules/hyprland/data/configs/binds/workspace.lua`, `zsh/modules/hyprland/data/configs/binds/monitor.lua`, `zsh/modules/hyprland/data/configs/envs.lua`, `zsh/modules/hyprland/data/configs/execs.lua`, `zsh/modules/hyprland/data/configs/general.lua`
- **Files potentially created**: `zsh/modules/hyprland/data/configs/animations.lua` (extracted from general.lua), `bin/omarchy-hyprland-monitor-scaling-cycle` (adapted script for scaling cycle)
- **No breaking changes**: All new binds use unused key combinations. Existing behavior preserved.
- **No new dependencies**: All capabilities use existing Hyprland Lua API (`hl.*`). Clipboard workaround is pure Lua dispatch.
