## 1. Add touchpad block to `general.lua`

- [x] 1.1 Read current `zsh/modules/hyprland/data/configs/general.lua` to confirm block boundaries
- [x] 1.2 Open the `hl.config({ input = { ... } })` block and append `touchpad = { ... }` after `repeat_delay = 200,`
- [x] 1.3 Add the following settings inside the touchpad block:
  - `natural_scroll = true`
  - `tap_to_click = true`
  - `clickfinger_behavior = true`
  - `scroll_factor = 0.5`
  - `disable_while_typing = true`
  - `middle_button_emulation = false`
  - `drag_lock = true`
- [x] 1.4 Add inline comments documenting each setting and its purpose
- [x] 1.5 Verify resulting Lua is syntactically valid (`luac -p` or similar)

## 2. Verification

- [x] 2.1 Run `task validate` to ensure pre-commit hooks and format checks pass
- [x] 2.2 Run `hyprland::sync` to rsync data to `~/.config/hypr/`
- [x] 2.3 Run `hyprctl reload` to apply configuration
- [ ] 2.4 Verify touchpad behavior in a live session:
  - Natural scroll direction
  - Tap-to-click works
  - Two-finger click triggers right-click
  - Three-finger tap triggers middle-click
  - Scroll speed is slower/smoother
  - Typing does not trigger accidental cursor movement
  - Drag lock allows lift-and-continue during drag
- [x] 2.5 Check `hyprctl getoption input:touchpad:natural_scroll` returns the configured value
