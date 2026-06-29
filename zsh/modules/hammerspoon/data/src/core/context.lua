local Logger = require("core.logger")

-- Infraestructura hs
local Application = require("core.hs.application")
local Window = require("core.hs.window")
local Notification = require("core.hs.notification")
local Audio = require("core.hs.audio")

local TableUtils = require("core.utils.table")

local M = {}

function M.create(config)
  Logger.setLevel(config.logLevel or "info")

  local ctx = {}

  ctx.config = config
  ctx.logger = Logger

  ctx.utils = {
    table = TableUtils,
  }

  ctx.hs = {
    application = Application,
    window = Window,
    notification = Notification,
    audio = Audio,
    hotkey = hs.hotkey,
    alert = hs.alert,
  }

  return ctx
end

return M
