## Context

The Hyprland configuration at `zsh/modules/hyprland/data/` uses a Lua-based config system (Hyprland 0.55+). The entry point `hyprland.lua` requires sub-modules from `configs/`:

- `configs/colors.lua` — color scheme
- `configs/general.lua` — monitors, input settings
- `configs/rules.lua` — window rules
- `configs/binds.lua` — keybindings
- `configs/envs.lua` — environment variables
- `configs/execs.lua` — autostart executables

The `general.lua` file currently defines monitors and a minimal `input` block:

```lua
hl.config({
    input = {
        repeat_rate = 35,
        repeat_delay = 200,
    },
})
```

No touchpad settings exist. Hyprland's Lua config supports a `touchpad` sub-table inside `input` that maps to libinput driver settings. The settings applied here are global — all touchpads (both built-in and Bluetooth) inherit them unless overridden by a device-specific block.

## Goals / Non-Goals

**Goals:**
- Add a `touchpad { }` sub-table to the existing `input` block with all preferred libinput settings
- Preserve existing keyboard repeat rate/delay settings unchanged
- Follow Hyprland 0.55+ Lua config naming conventions exactly
- Keep the change in a single file with no new module dependencies

**Non-Goals:**
- No changes to `hyprland.lua` orchestrator or any other config module
- No device-specific overrides (Bluetooth trackpads inherit global touchpad settings)
- No dynamic/profile-based touchpad switching
- No GUI/OSC for adjusting touchpad settings at runtime
- No changes to legacy `.conf` files in `conf/` or `dms/`

## Decisions

### Decision 1: Touchpad block inside existing `input` table

**Choice:** Add `touchpad = { ... }` as a sub-table of the existing `input` block in `configs/general.lua`.

**Rationale:**
- Hyprland's Lua API mirrors the config structure — `input` supports a `touchpad` key directly
- No new files or require chains needed
- Co-locates all input configuration in one place
- Easy to find and edit

### Decision 2: No device-specific override (global settings only)

**Choice:** Apply touchpad settings globally rather than creating a separate device block for the Bluetooth trackpad.

**Rationale:**
- The user's Magic Trackpad is the only pointer — no internal touchpad to differentiate from
- Global settings apply to all libinput devices equally
- Device-specific overrides can be added later if needed (e.g., if a built-in touchpad and Bluetooth trackpad both exist and need different settings)
- Simpler, fewer lines, less maintenance

### Decision 3: Settings follow macOS/libinput best-practice defaults

**Choice:** Enable natural scroll, tap-to-click, clickfinger behavior, drag lock; reduce scroll factor to 0.5; disable middle button emulation.

| Setting | Value | Rationale |
|---------|-------|-----------|
| `natural_scroll` | `true` | macOS-style scroll direction (content follows finger) |
| `tap_to_click` | `true` | Essential for laptop usability without physical click |
| `clickfinger_behavior` | `true` | Two-finger click = right-click (standard on macOS) |
| `scroll_factor` | `0.5` | Slower scroll = more precise control |
| `disable_while_typing` | `true` | Prevents palm/thumb activation while keyboard active |
| `middle_button_emulation` | `false` | Not needed with clickfinger (three-finger = middle) |
| `drag_lock` | `true` | Lift finger during drag without dropping — matches macOS behavior |

**Rationale:**
- Matches the user's existing macOS (Hammerspoon/Magic Trackpad) muscle memory
- `clickfinger_behavior` replaces `middle_button_emulation` — three-finger tap becomes middle click
- `scroll_factor = 0.5` prevents "scrolling too fast" on high-DPI Bluetooth trackpads

## Risks / Trade-offs

- **[Ergonomics]** `natural_scroll = true` inverts scroll direction globally. Users sharing the machine who prefer traditional scroll must override. Mitigation: document the setting is toggleable.
- **[Desktop vs Laptop]** If a built-in touchpad is later enabled (e.g., eDP-1 monitor re-enabled), global settings may not be ideal for both devices. Mitigation: device-specific overrides documented as a future option.
- **[Hyprland version]** Touchpad settings require Hyprland 0.40+ with libinput backend. Current version (0.55+ Lua) fully supports them. Risk: low.
