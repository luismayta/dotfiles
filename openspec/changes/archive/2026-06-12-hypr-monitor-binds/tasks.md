## 1. Create monitor.lua sub-module

- [x] 1.1 Create `configs/binds/monitor.lua` with ALT and SUPER constants at module top
- [x] 1.2 Add ALT+O bind using `hl.dsp.window.move({ monitor = "+1" })` (toggle/cycle between monitors)
- [x] 1.3 Add ALT+M bind using `hl.dsp.window.fullscreen({ mode = "maximize" })`

## 2. Register in orchestrator

- [x] 2.1 Add `require("configs.binds.monitor").register(mainMod)` to `configs/binds.lua`

## 3. Verify

- [x] 3.1 Run `task validate` for pre-commit hooks
- [x] 3.2 Verify Lua syntax with `luac -p` or `stylua --check`
