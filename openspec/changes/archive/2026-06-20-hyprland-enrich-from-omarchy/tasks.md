## 1. Window Rules — Tag System

- [x] 1.1 Add `tag_window()` helper function in `configs/rules.lua` that registers composable rules by tag name
- [x] 1.2 Register `+terminal` tag with opacity 0.97 for Alacritty, Kitty, foot, GNOME Terminal
- [x] 1.3 Register `+chromium-based-browser` tag with opacity 0.97 + tiling for Chrome, Chromium, Brave, Edge, Vivaldi, Opera
- [x] 1.4 Register `+firefox-browser` tag with opacity 0.97 + tiling for Firefox
- [x] 1.5 Register `+floating-window` tag with centered 60x60 sizing for tool windows, dialogs, wofi, rofi
- [x] 1.6 Register `+jetbrains` tag with `no_follow_mouse = true` for all JetBrains IDEs
- [x] 1.7 Register `+bitwarden` tag with `no_screen_share = true` for Bitwarden
- [x] 1.8 Register `+media` tag with opacity 0.95 for VLC, mpv, imv, Wireshark, Zoom
- [ ] 1.9 Verify all window rules compile with `hyprctl dispatch` test

## 2. Environment Variables

- [x] 2.1 Add `GDK_BACKEND=wayland` to Wayland GTK forcing in `configs/envs.lua`
- [x] 2.2 Add `MOZ_ENABLE_WAYLAND=1` for Firefox Wayland in `configs/envs.lua`
- [x] 2.3 Add Ozone/Electron Wayland env vars (`OZONE_PLATFORM_HINT`, `ELECTRON_OZONE_PLATFORM_HINT`, `NIXOS_OZONE_WL`)
- [x] 2.4 Add `XDG_CURRENT_DESKTOP=Hyprland` and `XDG_SESSION_DESKTOP=Hyprland` for portal/screen share compat
- [x] 2.5 Verify env vars are loaded before any app starts

## 3. Clipboard Bindings

- [x] 3.1 Add `send_shortcut_once()` inline Lua function in `configs/binds/window.lua`
- [x] 3.2 Register `SUPER+C` as universal copy using `send_shortcut_once`
- [x] 3.3 Register `SUPER+V` as universal paste using `send_shortcut_once`
- [x] 3.4 Register `SHIFT+SUPER+X` as universal cut using `send_shortcut_once`
- [ ] 3.5 Test clipboard in both XWayland and native Wayland apps

## 4. Hardware Controls

- [x] 4.1 Add keyboard backlight binds: `SUPER+F12` (cycle), `SUPER+SHIFT+F12` (toggle), `SUPER+CTRL+BRIGHTNESSDOWN/UP` (fine)
- [x] 4.2 Add touchpad binds: `SUPER+SHIFT+SPACE` (toggle), `SUPER+SHIFT+CTRL+SPACE` (enable), `SUPER+SHIFT+ALT+SPACE` (disable)
- [x] 4.3 Add precise volume binds: `ALT+XF86AudioLowerVolume` (-1%), `ALT+XF86AudioRaiseVolume` (+1%)
- [x] 4.4 Add precise brightness binds: `ALT+XF86MonBrightnessDown` (-1%), `ALT+XF86MonBrightnessUp` (+1%)

## 5. Notification Controls

- [x] 5.1 Add `SUPER+SHIFT+N` to dismiss last notification via DMS IPC
- [x] 5.2 Add `SUPER+CTRL+N` to dismiss all notifications via DMS IPC
- [x] 5.3 Add `SUPER+ALT+N` to toggle notification silence via DMS IPC
- [x] 5.4 Add `SUPER+SHIFT+M` to restore last dismissed notification via DMS IPC

## 6. Workspace Navigation Enhancements

- [x] 6.1 Add `SUPER+CTRL+BRIGHTNESSDOWN` for previous workspace, `SUPER+CTRL+BRIGHTNESSUP` for next workspace
- [x] 6.2 Add `SUPER+SHIFT+TAB` to swap to previous/former workspace
- [x] 6.3 Add `CTRL+ALT+TAB` for focus next monitor, `CTRL+ALT+SHIFT+TAB` for focus previous monitor
- [x] 6.4 Add `SUPER+SHIFT+ALT+LEFT/RIGHT/UP/DOWN` to move workspace to adjacent monitor

## 7. Monitor Management

- [x] 7.1 Create `bin/monitor-scaling-cycle` script adapted from omarchy (cycles 1x, 1.25x, 1.6x, 2x, 3x, 4x)
- [x] 7.2 Add `SUPER+=` for monitor scaling cycle forward, `SUPER+ALT+=` for reverse
- [x] 7.3 Improve `configs/binds/monitor.lua` — replace one-way `ALT+D` with `SUPER+CTRL+Delete` toggle (with external monitor safety check)
- [x] 7.4 Add `SUPER+CTRL+ALT+Delete` for internal display mirror toggle
- [x] 7.5 Add Lid Switch bindings: `switch:on:Lid Switch` (disable internal if external connected) and `switch:off:Lid Switch` (re-enable internal)
- [ ] 7.6 Verify safety: disabling the only active display is blocked

## 8. Group Management

- [x] 8.1 Add `SUPER+ALT+H/J/K/L` to move focused window into adjacent group (directional)
- [x] 8.2 Add `SUPER+ALT+1` through `SUPER+ALT+5` to select group tab by index
- [x] 8.3 Add `SUPER+SHIFT+F` to pop focused window out of group

## 9. Utility Binds

- [x] 9.1 Add `SUPER+ALT+ESCAPE` to lock screen via DMS IPC
- [x] 9.2 Add `SUPER+PRINT` to launch color picker
- [x] 9.3 Add `SUPER+SHIFT+PRINT` for OCR screenshot
- [x] 9.4 Add `SUPER+O` to cycle window transparency (0.97 → 0.60 → 1.0)
- [x] 9.5 Add `SUPER+SHIFT+G` to toggle window gaps (0px ↔ default)
- [x] 9.6 Add `SUPER+CTRL+equal` to zoom in, `SUPER+CTRL+0` to reset zoom

## 10. Look'n'Feel — Animation Curves

- [x] 10.1 Create `configs/animations.lua` extracted from `general.lua`
- [x] 10.2 Add bezier curves from omarchy defaults
- [x] 10.3 Add window animation settings (open/close/move/reshape)
- [x] 10.4 Add fade animation settings (windows, popups, menus)
- [x] 10.5 Add border animation settings
- [x] 10.6 Add workspace slide animation settings
- [x] 10.7 Update `hyprland.lua` entry point to `require` animations.lua

## 11. Look'n'Feel — Groupbar, Cursor, Misc

- [x] 11.1 Add groupbar config (font, colors, indicator, gradients) in `configs/general.lua`
- [x] 11.2 Add cursor config (hide_on_key_press, warp_on_workspace_change) in `configs/general.lua`
- [x] 11.3 Add misc config (disable_logo, focus_on_activate, animate_manual_resizes, disable_xdg_anr)

## 12. Autostart Enhancements

- [x] 12.1 Add desktop portal autostart to `configs/execs.lua` if not already present
- [x] 12.2 Add polkit authentication agent autostart to `configs/execs.lua` if not already present

## 13. Verification

- [ ] 13.1 Run LSP diagnostics on all modified Lua files
- [ ] 13.2 Reload Hyprland config and verify no startup errors
- [ ] 13.3 Test monitor scaling cycle with `hyprctl monitors -j`
- [ ] 13.4 Test internal display toggle with and without external monitor
- [ ] 13.5 Test a representative subset of all new binds
