-- Keybindings orchestrator
-- Sub-modules are loaded in a specific order to ensure dependencies are met:
--   1. layout    → togglesplit, layout cycle
--   2. workspace → scratchpad, workspace focus/move, DMS IPC
--   3. window    → HJKL nav, window actions, multimedia keys
--   4. monitor   → window toggle/cycle between monitors, maximize
--   5. apps      → app launcher tiers (direct, hyper, secondary)

local mainMod = "SUPER"

require("configs.binds.layout").register(mainMod)
require("configs.binds.workspace").register(mainMod)
require("configs.binds.window").register(mainMod)
require("configs.binds.monitor").register(mainMod)
require("configs.binds.apps").register(mainMod)
