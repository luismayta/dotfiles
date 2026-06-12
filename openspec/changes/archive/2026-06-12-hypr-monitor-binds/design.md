## Context

Hyprland bindings are organized in `configs/binds/` as modular sub-modules (`window.lua`, `layout.lua`, `apps.lua`, `workspace.lua`), loaded by `configs/binds.lua` orchestrator. The codebase follows a `register(mainMod)` pattern where `mainMod = "SUPER"` is passed to each module.

No existing module covers monitor-level operations. The user needs two plain-ALT bindings (no SUPER prefix) for moving windows between monitors and maximizing.

## Goals / Non-Goals

**Goals:**
- Add `configs/binds/monitor.lua` with two keybindings as module-level constant definitions
- Load via existing orchestrator with one `require()` line
- Follow existing sub-module conventions (return `M` table with `register()` function)
- Keep binding logic minimal — YAGNI

**Non-Goals:**
- No changes to Hyprland `.conf` files, monitor configuration, or DMS IPC
- No multi-monitor workspace management (focus/move workspace to monitor)
- No profile system or conditional monitor detection

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Modifier keys as constants** | Define `MOD_ALT` constant at module top, use it in bind definitions | User requirement: "key configs as constants, no inline strings"; matches pattern of `mainMod` elsewhere |
| **Plain ALT (no SUPER)** | `hl.bind("ALT + O", ...)` without `mainMod` prefix | User explicitly wants ALT+O and ALT+M; multimedia keys already use this no-prefix pattern in `window.lua` |
| **Monitor move dispatch** | `hl.dsp.window.move({ monitor = "+1" })` | Hyprland `monitor = "+1"` moves to the next monitor in the list, cycling forward (1→2→3→1). For 2 monitors this behaves as a toggle; for 3+ it cycles through all connected monitors |
| **Maximize dispatch** | `hl.dsp.window.fullscreen({ mode = "maximize" })` | Fills workspace area while keeping bar visible (`maximized` hides decorations) |
| **Sub-module location** | `configs/binds/monitor.lua` | Consistent with existing modular split; loaded after `window` in orchestrator |
| **No custom dispatcher** | Use `hl.dsp.*` directly | The Hyprland Lua API already provides these; no need for custom helper functions (YAGNI) |

## Risks / Trade-offs

- **[Key collision]** ALT+O/M might conflict with application-level shortcuts → Low risk since Hyprland captures at compositor level before apps see the event
- **[Single monitor systems]** `monitor = "+1"` on single-monitor is a no-op (no crash, no error) → Graceful no-op by design
- **[Maximize mode mismatch]** If `fullscreen({ mode = "maximize" })` doesn't behave as expected, fallback is `fullscreen({ mode = "maximized" })` → Easy tweak, single constant change at module top
