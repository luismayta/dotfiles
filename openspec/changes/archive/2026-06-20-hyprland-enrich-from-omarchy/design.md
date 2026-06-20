## Context

Our Hyprland config lives in `zsh/modules/tmux`... actually `zsh/modules/hyprland/data/` as a Lua-based Hyprland configuration managed via dotfiles. The config uses the `hl.*` Lua API and is structured as:

- `hyprland.lua` → entry point, loads custom module, envs, execs, general, rules, binds
- `configs/` → general (monitors + input), rules (window rules), colors (catppuccin), envs, execs, binds (orchestrator + 5 sub-modules)
- `custom/` → dispatcher (launch_or_focus, resize, layout), helper (by_layout), layout (tri-column), init (namespace)
- `dms/` → DMS-specific configs (binds, colors, cursor, layout, outputs)

The omarchy project at `/home/lucho/Projects/src/github.com/basecamp/omarchy` has a mature `default/hypr/` module library with richer window rules, clipboard workarounds, notification management, animation curves, and more comprehensive window/group/hardware binds. We want to adopt selective patterns from omarchy without migrating to omarchy as a framework.

## Goals / Non-Goals

**Goals:**
- Add clipboard universal copy/paste/cut bindings with XWayland `send_shortcut_once` workaround
- Add tag-based window rules for better per-app behavior (opacity, floating, tiling)
- Add enhanced workspace navigation (next/prev/former workspace, focus next/prev monitor, move workspace to adjacent monitor)
- Add monitor management (scaling cycle, internal display toggle with safety, lid switch handling, mirror toggle)
- Add enhanced group management (directional move, group window index)
- Add hardware controls (keyboard backlight, touchpad toggle, precise volume/brightness)
- Add notification controls (dismiss, silence, restore)
- Add utility binds (lock, color picker, OCR, zoom, window transparency/gaps toggles)
- Add animation curves, groupbar styling, and cursor config from omarchy
- Add comprehensive Wayland env vars for screen sharing and app compat

**Non-Goals:**
- NOT migrating to omarchy as a framework — we keep independent dotfiles
- NOT changing existing keybindings (all new binds use unused combos)
- NOT adding new external dependencies
- NOT restructuring the config layout (files stay in their current locations)

## Decisions

### Decision 1: Inline clipboard workaround vs external script
- **Chosen**: Inline Lua `send_shortcut_once` function in `window.lua`
- **Rationale**: The omarchy pattern uses a pure-Lua approach that dispatches key states directly via `hl.dsp.send_key_state()`. This requires no external scripts and works reliably with XWayland apps. The function is small enough to keep inline.
- **Alternative**: External shell script — adds a file and process overhead for no benefit.

### Decision 2: Tag-based window rules in `rules.lua`
- **Chosen**: Add omarchy-style `o.window()` helper pattern directly in `rules.lua` using tag system
- **Rationale**: Tag-based rules allow stacking behavior (e.g., tag `+terminal` first, then apply opacity to all tagged windows). This is more composable than class-name pattern matching.
- **Implementation**: Replicate the `o.window()` helper locally rather than requiring omarchy's module loader.

### Decision 3: Animation curves → new `configs/animations.lua`
- **Chosen**: Extract animations into a dedicated file `configs/animations.lua`
- **Rationale**: `general.lua` currently mixes monitor config, input config, and animation-related code. Animations are a distinct concern — splitting keeps files focused.
- **Alternative**: Keep all in `general.lua` — would make the file too long and mix concerns.

### Decision 4: New bind categories go into existing modules
- **Chosen**: Add new binds to existing `window.lua` and `workspace.lua` modules by category
- **Rationale**: The current 5-module structure (layout, workspace, window, monitor, apps) maps well to omarchy's categories. New clipboard binds → `window.lua`, new workspace binds → `workspace.lua`, new utility/system binds → `workspace.lua`.
- **Alternative**: Create new module files — adds files for marginal organizational gain.

### Decision 5: Notification controls use `dms ipc call` pattern
- **Chosen**: Route notification controls through DMS IPC (existing pattern)
- **Rationale**: We already use `dms ipc call` for notifications (`notifications toggle`, `notepad toggle`). Dismiss/silence/restore fit this same pattern. No need to introduce makoctl directly.

### Decision 6: Monitor scaling cycle → adapted bash script
- **Chosen**: Port `omarchy-hyprland-monitor-scaling-cycle` script to `bin/` as `monitor-scaling-cycle`
- **Rationale**: Monitor scaling requires reading current scale from `hyprctl monitors -j`, computing the next value in the cycle, and applying it. This is impractical to express purely in Lua — a small bash script is cleaner.
- **Alternative**: Pure Lua with `hl.dsp.exec_cmd` calling `hyprctl` inline — possible but harder to read and maintain.

### Decision 7: Internal display toggle → improve `monitor.lua`
- **Chosen**: Replace the current one-way `ALT + D` (disable only) with a proper toggle in `monitor.lua` that checks for external monitors before disabling
- **Rationale**: The omarchy pattern adds a safety guard against disabling the only active display. The lid switch handling mirrors the external-monitors check pattern.
- **Alternative**: Keep current script — but it can leave the user without a display if no external monitor is connected.

### Decision 8: Focus next/prev monitor → existing `window.lua` pattern
- **Chosen**: Add to `window.lua` since it's navigation/focus-related
- **Rationale**: `hl.dsp.focus({ monitor = "+1" })` and `hl.dsp.focus({ monitor = "-1" })` follow the same pattern as window focus binds already there

### Decision 9: Lock, zoom → direct Hyprland dispatchers
- **Chosen**: Lock → `dms ipc call lock lock`, Zoom → inline Lua closure modifying `cursor.zoom_factor`
- **Rationale**: Lock already has a DMS IPC endpoint. Zoom uses omarchy's pattern of reading/modifying cursor config via `hl.get_config`/`hl.config`.
- **Alternative**: External omarchy scripts — not available without omarchy installed.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| `send_shortcut_once` interferes with existing SUPER+C/V in terminals | Terminal apps handle Ctrl+C/V natively; SUPER+C/V only applies when the XWayland workaround is needed |
| Tag-based rules change window appearance (opacity) | Default opacity target is 0.97 — subtle. Can be disabled per-app via tag removal |
| New binds may conflict with future system updates | All new binds use currently unused combos. Super+N/X/Z already used in workspace.lua — careful assignment needed |
| Animation curve values may not match user preferences | Matches omarchy defaults which are well-tested. Easy to tweak later |
| Internal display toggle safety check could fail | Script checks `omarchy-hw-external-monitors` equivalent; if it fails, the display stays on — safe failure mode |
| Lid switch handling may conflict with other power managers | Only handles `switch:on:Lid Switch` / `switch:off:Lid Switch` — other managers can coexist |
| Monitor scaling script uses `jq` dependency | Already present in system for other config scripts |
