## Why

The current Hyprland input configuration (`configs/general.lua`) only sets keyboard repeat rate and delay — there is no touchpad configuration at all. Users of Bluetooth trackpads (Magic Trackpad, MX Master, etc.) get default libinput behavior: no natural scroll, no tap-to-click, default scroll speed. This degrades the user experience significantly, especially on laptops where the trackpad is the primary pointing device.

The existing `input` block:

```lua
input = {
    repeat_rate = 35,
    repeat_delay = 200,
},
```

Lacks the `touchpad { }` sub-table that Hyprland 0.55+ (Lua config) supports for configuring libinput settings per-device or globally.

## What Changes

- **Add a `touchpad` sub-table** to the existing `input` block in `configs/general.lua` with preferred libinput settings:
  - `natural_scroll = true` — content follows finger direction (macOS-style)
  - `tap_to_click = true` — tap to left-click
  - `clickfinger_behavior = true` — two-finger click = right-click, three-finger = middle-click
  - `scroll_factor = 0.5` — slower/smoother scroll speed
  - `disable_while_typing = true` — prevent palm activation while typing
  - `middle_button_emulation = false` — off by default
  - `drag_lock = true` — lock drag without holding finger down
- **No structural changes** — the `input` block grows by one sub-table, no new files, no new modules.
- **No breaking changes** — default behavior is preserved if touchpad block is omitted.

## Capabilities

### New Capabilities
- `touchpad-input-config`: Global touchpad input settings under `input { touchpad { ... } }` in the Hyprland Lua config.

### Modified Capabilities
- *(none)*

## Impact

- **`zsh/modules/hyprland/data/configs/general.lua`** — adds `touchpad = { ... }` sub-table inside the existing `input` block; all existing lines unchanged.
- **No new files** — single change in one file.
- **No breaking changes** — Hyprland treats missing `touchpad` as default libinput behavior.
