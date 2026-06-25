local wezterm = require 'wezterm'
local Config = require('config')

local backdrops = require('utils.backdrops')
backdrops:set_images()
backdrops:random()

require('events.left-status').setup()
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })
require('events.tab-title').setup({ hide_active_tab_unseen = false, unseen_icon = 'numbered_box' })
require('events.new-tab-button').setup()
require('events.gui-startup').setup()

wezterm.set_environment_variables = {
  TMUX_SOCKET = "wezterm",
}

return Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.color'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
