-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

local custom = require("custom")

-- Register custom layout before other configs to ensure it's available for rules and binds
custom.layout.register()

require("configs.envs")
require("configs.execs")

require("configs.general")
require("configs.animations")
require("configs.rules")

require("configs.binds")
