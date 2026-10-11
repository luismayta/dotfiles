local wezterm = require "wezterm"
local Config = require "config"

local backdrops = require "utils.backdrops"
backdrops:set_images()
backdrops:random()

require("events.left-status").setup()
require("events.right-status").setup { date_format = "%a %H:%M:%S" }
require("events.tab-title").setup { hide_active_tab_unseen = false, unseen_icon = "numbered_box" }
require("events.new-tab-button").setup()
require("events.gui-startup").setup()

-- HERDR_WORKSPACE identifies the terminal emulator for herdr workspace routing.
-- IMPORTANT: Terminal detection in zsh/zshrc uses TERM_PROGRAM, NOT this var,
-- because HERDR_WORKSPACE leaks to child processes (e.g., alacritty launched from WezTerm).
wezterm.set_environment_variables = {
  HERDR_WORKSPACE = "wezterm",
}

return Config:init()
  :append(require "config.appearance")
  :append(require "config.bindings")
  :append(require "config.domains")
  :append(require "config.color")
  :append(require "config.fonts")
  :append(require "config.general")
  :append(require "config.launch").options
