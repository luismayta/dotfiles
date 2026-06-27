# Hyprland Keybindings Reference

> **Modifier convention:** `SUPER` refers to the Windows/Command key.
> All bindings use `SUPER` as the primary modifier unless otherwise noted.
> Definitions in Lua config files override legacy `dms/binds.conf` entries.

---

## Table of Contents

- [Layout](#layout)
- [Workspace](#workspace)
- [Window Management](#window-management)
- [Group Management](#group-management)
- [Clipboard](#clipboard)
- [Hardware Controls](#hardware-controls)
- [Notification Controls](#notification-controls)
- [Monitor Management](#monitor-management)
- [DMS IPC Utilities](#dms-ipc-utilities)
- [Utility Binds](#utility-binds)
- [App Launchers](#app-launchers)
- [Additional Legacy Binds](#additional-legacy-binds)

---

## Layout

| Key | Action | Defined in |
|---|---|---|
| `SUPER + R` | Toggle split orientation | `binds/layout.lua` |
| `SUPER + Backslash` | Next layout | `binds/layout.lua` |
| `SUPER + SHIFT + Backslash` | Previous layout | `binds/layout.lua` |

---

## Workspace

| Key | Action | Defined in |
|---|---|---|
| `SUPER + S` | Toggle scratchpad | `binds/workspace.lua` |
| `SUPER + SHIFT + S` | Move window to scratchpad | `binds/workspace.lua` |
| `SUPER + {1-9}` | Focus workspace N | `binds/workspace.lua` |
| `SUPER + SHIFT + {1-9}` | Move window to workspace N | `binds/workspace.lua` |
| `SUPER + SHIFT + TAB` | Previous workspace | `binds/workspace.lua` |
| `SUPER + CTRL + BRIGHTNESS_DOWN` | Focus workspace e-1 | `binds/workspace.lua` |
| `SUPER + CTRL + BRIGHTNESS_UP` | Focus workspace e+1 | `binds/workspace.lua` |
| `CTRL + ALT + TAB` | Focus next monitor | `binds/workspace.lua` |
| `CTRL + ALT + SHIFT + TAB` | Focus previous monitor | `binds/workspace.lua` |
| `SUPER + SHIFT + ALT + {LEFT,RIGHT,UP,DOWN}` | Move workspace to adjacent monitor | `binds/workspace.lua` |
| `SUPER + SHIFT + ALT + H` | Focus monitor on the left | `binds/workspace.lua` |
| `SUPER + SHIFT + ALT + L` | Focus monitor on the right | `binds/workspace.lua` |

---

## Window Management

| Key | Action | Defined in |
|---|---|---|
| `SUPER + {H,J,K,L}` | Focus direction (left, down, up, right) | `binds/window.lua` |
| `SUPER + SHIFT + {H,J,K,L}` | Move window in direction | `binds/window.lua` |
| `SUPER + CTRL + {H,J,K,L}` | Swap window (dwindle-aware; scrolling: swapcol) | `binds/window.lua` |
| `SHIFT + CTRL + ALT + {H,J,K,L}` | Focus direction (SHIFT+CTRL+ALT tier alternative) | `binds/window.lua` |
| `SHIFT + CTRL + ALT + SHIFT + {H,J,K,L}` | Move window in direction (SHIFT+CTRL+ALT tier alternative) | `binds/window.lua` |
| `SUPER + Q` | Close active window | `binds/window.lua` |
| `SUPER + SHIFT + C` | Center window on screen | `binds/window.lua` |
| `SUPER + T` | Toggle floating window | `binds/window.lua` |
| `SUPER + F` | Fullscreen (maximized mode) | `binds/window.lua` |
| `SUPER + equal` | Resize window width + (dwindle: +5px; scrolling: colresize) | `binds/window.lua` |
| `SUPER + minus` | Resize window width − | `binds/window.lua` |
| `SUPER + SHIFT + equal` | Resize window height + | `binds/window.lua` |
| `SUPER + SHIFT + minus` | Resize window height − | `binds/window.lua` |
| `SUPER + mouse:272` | Drag/move window | `binds/window.lua` |
| `SUPER + mouse:273` | Resize window with mouse | `binds/window.lua` |

---

## Group Management

| Key | Action | Defined in |
|---|---|---|
| `SUPER + W` | Toggle window group | `binds/window.lua` |
| `SUPER + BracketLeft` | Focus previous group member | `binds/window.lua` |
| `SUPER + BracketRight` | Focus next group member | `binds/window.lua` |
| `SUPER + ALT + {H,J,K,L}` | Move window into group in direction | `binds/window.lua` |
| `SUPER + ALT + {1-5}` | Select group tab by index N | `binds/window.lua` |
| `SUPER + SHIFT + F` | Pop window out of group | `binds/window.lua` |

---

## Clipboard

Implement a workaround for Hyprland's `send_shortcut` leaving synthetic key states
stuck (see hyprwm/Hyprland/discussions/14099).

| Key | Action | Defined in |
|---|---|---|
| `SUPER + C` | Universal copy (emits `CTRL+Insert`) | `binds/window.lua` |
| `SUPER + V` | Universal paste (emits `SHIFT+Insert`) | `binds/window.lua` |
| `SUPER + SHIFT + X` | Universal cut (emits `CTRL+X`) | `binds/window.lua` |
| `SUPER + CTRL + V` | Open clipboard manager (walker) | `binds/window.lua` |

---

## Hardware Controls

### Media Keys

Media keys are bound without a modifier prefix for direct access.

| Key | Action | Defined in |
|---|---|---|
| `XF86AudioRaiseVolume` | Volume +3% | `binds/window.lua` |
| `XF86AudioLowerVolume` | Volume −3% | `binds/window.lua` |
| `XF86AudioMute` | Mute/unmute audio | `binds/window.lua` |
| `XF86AudioMicMute` | Mute/unmute microphone | `binds/window.lua` |
| `XF86AudioNext` | Next track (MPRIS) | `binds/window.lua` |
| `XF86AudioPrev` | Previous track (MPRIS) | `binds/window.lua` |
| `XF86AudioPlay` | Play/Pause (MPRIS) | `binds/window.lua` |
| `XF86AudioPause` | Play/Pause (MPRIS) | `binds/window.lua` |
| `XF86MonBrightnessUp` | Brightness +5% | `binds/window.lua` |
| `XF86MonBrightnessDown` | Brightness −5% | `binds/window.lua` |

### Precise Controls

| Key | Action | Defined in |
|---|---|---|
| `ALT + XF86AudioLowerVolume` | Precise volume −1% | `binds/window.lua` |
| `ALT + XF86AudioRaiseVolume` | Precise volume +1% | `binds/window.lua` |
| `ALT + XF86MonBrightnessDown` | Precise brightness −1% | `binds/window.lua` |
| `ALT + XF86MonBrightnessUp` | Precise brightness +1% | `binds/window.lua` |

### Keyboard Backlight

| Key | Action | Defined in |
|---|---|---|
| `XF86KbdBrightnessUp` | Keyboard backlight +33% | `binds/window.lua` |
| `XF86KbdBrightnessDown` | Keyboard backlight −33% | `binds/window.lua` |
| `SUPER + F12` | Keyboard backlight 100% | `binds/window.lua` |
| `SUPER + SHIFT + F12` | Keyboard backlight 0% | `binds/window.lua` |

### Touchpad

| Key | Action | Defined in |
|---|---|---|
| `SUPER + SHIFT + SPACE` | Toggle touchpad | `binds/window.lua` |
| `SUPER + SHIFT + CTRL + SPACE` | Enable touchpad | `binds/window.lua` |
| `SUPER + SHIFT + ALT + SPACE` | Disable touchpad | `binds/window.lua` |

---

## Notification Controls

All routed through **DMS IPC**.

| Key | Action | Defined in |
|---|---|---|
| `SUPER + N` | Toggle notification center | `binds/workspace.lua` |
| `SUPER + SHIFT + N` | Dismiss last notification | `binds/workspace.lua` |
| `SUPER + CTRL + N` | Dismiss all notifications | `binds/workspace.lua` |
| `SUPER + ALT + N` | Toggle silence mode | `binds/workspace.lua` |
| `SUPER + SHIFT + M` | Restore last dismissed notification | `binds/workspace.lua` |

---

## Monitor Management

| Key | Action | Defined in |
|---|---|---|
| `ALT + O` | Move window to next monitor (cycles 1→2→3→1 with 3+ monitors) | `binds/monitor.lua` |
| `ALT + M` | Maximize window (fill workspace, keep bar visible) | `binds/monitor.lua` |
| `SUPER + period` | Cycle monitor scaling forward (1× → 1.25× → 1.6× → 2× → 3× → 4×) | `binds/monitor.lua` |
| `SUPER + ALT + equal` | Cycle monitor scaling backward | `binds/monitor.lua` |
| `SUPER + CTRL + Delete` | Toggle internal display (eDP-1) — safety check prevents disabling without external monitor | `binds/monitor.lua` |
| `SUPER + CTRL + ALT + Delete` | Mirror internal display onto external monitor | `binds/monitor.lua` |
| `switch:on:Lid Switch` | Disable internal display when lid closed (only if external monitor connected) | `binds/monitor.lua` |
| `switch:off:Lid Switch` | Re-enable internal display when lid opened | `binds/monitor.lua` |

> **Note:** `SUPER + equal` is reserved for window resize. Scaling forward uses `SUPER + period` to avoid conflict.

---

## DMS IPC Utilities

| Key | Action | Defined in |
|---|---|---|
| `SUPER + TAB` | Toggle overview (workspace overview) | `binds/workspace.lua` |
| `SUPER + M` | Toggle process list | `binds/workspace.lua` |
| `SUPER + X` | Toggle power menu | `binds/workspace.lua` |
| `SUPER + space` | Toggle spotlight search | `binds/workspace.lua` |
| `SUPER + Y` | Toggle wallpaper carousel | `binds/workspace.lua` |
| `SUPER + comma` | Toggle settings panel | `binds/workspace.lua` |
| `SUPER + V` | Toggle clipboard manager (DMS) | `dms/binds.conf` |
| `SUPER + SHIFT + Slash` | Show keybindings overlay | `dms/binds.conf` |
| `SUPER + ALT + L` | Lock screen | `binds/workspace.lua` |
| `SUPER + ALT + ESCAPE` | Lock screen (alternative) | `binds/workspace.lua` |
| `CTRL + ALT + Delete` | Toggle process list (alternative) | `dms/binds.conf` |
| `SUPER + CTRL + ALT + Delete` | Toggle process list (alternative) | `binds/workspace.lua` |

---

## Utility Binds

| Key | Action | Defined in |
|---|---|---|
| `SUPER + O` | Cycle window transparency: 0.97 → 0.60 → 1.0 | `binds/workspace.lua` |
| `SUPER + PRINT` | Color picker (hyprpicker, copies to clipboard) | `binds/workspace.lua` |
| `SUPER + SHIFT + PRINT` | OCR screenshot (DMS) | `binds/workspace.lua` |
| `SUPER + SHIFT + G` | Toggle window gaps between 0px and default (5px/3px) | `binds/workspace.lua` |
| `SUPER + CTRL + equal` | Zoom in — increment cursor zoom factor by 0.5 (max 5) | `binds/workspace.lua` |
| `SUPER + CTRL + 0` | Reset cursor zoom to 1× | `binds/workspace.lua` |

---

## App Launchers

Applications are organized in three tiers based on modifier complexity.

### Direct Tier — `SUPER + key`

| Key | Application | Defined in |
|---|---|---|
| `SUPER + E` | Dolphin (file manager) | `binds/apps.lua` |
| `SUPER + P` | Screenshot (full screen) | `binds/apps.lua` |
| `SUPER + SHIFT + P` | Screenshot (active window) | `binds/apps.lua` |
| `SUPER + CTRL + P` | Screenshot (area selection) | `binds/apps.lua` |

### Hyper Tier — `SUPER + ALT + CTRL + key`

Development tools and power-user applications.

| Key | Application | Defined in |
|---|---|---|
| `SUPER + ALT + CTRL + [` | Android Studio | `binds/apps.lua` |
| `SUPER + ALT + CTRL + ]` | IntelliJ IDEA | `binds/apps.lua` |
| `SUPER + ALT + CTRL + ;` | Zed (code editor) | `binds/apps.lua` |
| `SUPER + ALT + CTRL + B` | Bitwarden (password manager) | `binds/apps.lua` |
| `SUPER + ALT + CTRL + D` | draw.io (diagrams) | `binds/apps.lua` |
| `SUPER + ALT + CTRL + T` | Alacritty (terminal) | `binds/apps.lua` |
| `SUPER + ALT + CTRL + I` | Insomnia (API client) | `binds/apps.lua` |
| `SUPER + ALT + CTRL + S` | DataGrip (database IDE) | `binds/apps.lua` |
| `SUPER + ALT + CTRL + K` | Keybase | `binds/apps.lua` |
| `SUPER + ALT + CTRL + J` | Jira (Brave web app) | `binds/apps.lua` |
| `SUPER + ALT + CTRL + O` | Obsidian | `binds/apps.lua` |

### Secondary Tier — `CTRL + ALT + key`

System and communication applications.

| Key | Application | Defined in |
|---|---|---|
| `CTRL + ALT + A` | ChatGPT (Brave web app) | `binds/apps.lua` |
| `CTRL + ALT + B` | Brave Browser | `binds/apps.lua` |
| `CTRL + ALT + C` | Zen Browser | `binds/apps.lua` |
| `CTRL + ALT + D` | Discord | `binds/apps.lua` |
| `CTRL + ALT + F` | Figma | `binds/apps.lua` |
| `CTRL + ALT + H` | WhatsApp (Brave web app) | `binds/apps.lua` |
| `CTRL + ALT + T` | Google Tasks (Brave web app) | `binds/apps.lua` |
| `CTRL + ALT + M` | Spotify | `binds/apps.lua` |
| `CTRL + ALT + O` | Dolphin (file manager) | `binds/apps.lua` |

---

## Additional Legacy Binds

These are defined in `dms/binds.conf` (raw Hyprland config). Some may be
overridden by Lua module binds loaded afterwards.

| Key | Action |
|---|---|
| `SUPER + SHIFT + E` | Exit Hyprland |
| `SUPER + DOWN` | Focus down |
| `SUPER + LEFT` | Focus left |
| `SUPER + RIGHT` | Focus right |
| `SUPER + UP` | Focus up |
| `SUPER + SHIFT + F` | Fullscreen mode 0 |
| `SUPER + CTRL + F` | Resize active window to exact 100% |
| `SUPER + SHIFT + equal` | Resizeactive 0 10% (legacy) |
| `SUPER + SHIFT + minus` | Resizeactive 0 -10% (legacy) |

---

## Architecture Notes

### Loading Order

Bind modules are loaded in a specific sequence to manage dependencies:

1. **layout** — togglesplit, layout cycle
2. **workspace** — scratchpad, workspace focus/move, DMS IPC, utilities
3. **window** — HJKL navigation, window actions, multimedia, clipboard, hardware
4. **monitor** — window/monitor movement, scaling, lid switch
5. **apps** — app launcher tiers (direct, hyper, secondary)

### Configuration Sources

| Source | Format | Priority |
|---|---|---|
| `data/configs/binds/*.lua` | Lua (Hyprland `hl.bind()`) | Highest — loaded last |
| `data/dms/binds.conf` | Raw Hyprland `bind = ...` | Lower — may be overridden |

### Clipboard Workaround

Clipboard bindings use a custom `send_shortcut_once()` helper that manually
sends key state down/up with a 50ms timer to avoid Hyprland's stuck-key bug
when using `send_shortcut` with modifier keys. See `binds/window.lua` for
the implementation.

### Monitor Scaling Script

The scaling cycle is handled by a standalone Bash script at
`data/bin/monitor-scaling-cycle`. It queries monitor properties via
`hyprctl` + `jq` and cycles through 1× → 1.25× → 1.6× → 2× → 3× → 4×.
The `--reverse` flag cycles in the opposite direction.

### Internal Display Safety

The internal display toggle (`SUPER + CTRL + Delete`) includes a safety
check: it refuses to disable eDP-1 when no external monitor is connected,
preventing a complete loss of display output.
