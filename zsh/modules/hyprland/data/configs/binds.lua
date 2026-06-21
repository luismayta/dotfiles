-- Keybindings orchestrator
-- Sub-modules are loaded in a specific order to ensure dependencies are met:
--   1. constants  → modifier tier definitions
--   2. layout     → togglesplit, layout cycle
--   3. workspace  → scratchpad, workspace focus/move, DMS IPC
--   4. window     → HJKL nav, window actions, multimedia keys
--   5. monitor    → window toggle/cycle between monitors, maximize
--   6. apps       → app launcher tiers (direct, hyper, secondary)

local mainMod = "SUPER"
local C = require("configs.binds.constants")
C.register(mainMod)

require("configs.binds.layout").register(mainMod, C)
require("configs.binds.workspace").register(mainMod, C)
require("configs.binds.window").register(mainMod, C)
require("configs.binds.monitor").register(mainMod, C)
require("configs.binds.apps").register(mainMod, C)
