--[[
File:    mod/system/notification.lua
Purpose: System notification module — consolidated notification center integration
         with Do Not Disturb toggling, pomodoro working mode, and Caffeine control.
Author:  Hammerspoon Config Team
--]]

-- luacheck: globals hs spoon
local mod = {}
mod.namespace = "notification"
local pomodoro = require("mod.pomodoro")
local logger = require("hs.logger")
local fn = require("core.functions")
local hotkey = require("core.hotkey")
local caffeine = hs.loadSpoon("Caffeine")

mod.icon = hs.image.imageFromPath("assets/notification/success.png"):setSize({ w = 20, h = 20 })

-- debugging
local log = logger.new("notification", "debug")

mod.vars = {
  afterTime = 2,
  messageEnabled = {
    title = "Start Working with Not Disturb",
    subTitle = "Enabled",
    contentImage = mod.icon,
  },
  messageDisabled = {
    title = "Do Not Disturb",
    subTitle = "Disabled",
    contentImage = mod.icon,
  },
}

function mod.isEnabled()
  log:d("load is_enabled notification!")
  -- check if enabled
  local _, res = hs.applescript.applescript([[
    tell application "System Events"
      tell application process "SystemUIServer"
        tell (every menu bar whose title of menu bar item 1 contains "Notification")
          return title of (1st menu bar item whose title contains "Notification")
        end tell
      end tell
    end tell
  ]])

  local isEnabled = string.match(res[1], "Do Not Disturb")
  return isEnabled
end

function mod.disable()
  fn.setStatusNotification("disable")
end

function mod.enable()
  fn.setStatusNotification("enable")
end

function mod.startWorking()
  pomodoro.enable()
  caffeine:start()
  mod.enable()
end

function mod.stopWorking()
  pomodoro.disable()
  caffeine:stop()
  mod.disable()
end

function mod.toggleDoNotDisturb()
  -- check if enabled
  local _ = mod.isEnabled()
  local isPomodoroEnabled = pomodoro.isEnabled()

  if isPomodoroEnabled == true then
    log:d("disabled working!")
    hs.notify.new(mod.vars.messageDisabled):send()
    mod.stopWorking()
  else
    log:d("active working!")
    hs.notify.new(mod.vars.messageEnabled):send()
    mod.startWorking()
  end
end

function mod.init()
  mod.toggleDoNotDisturb()
  hotkey.bindWithCtrlAlt("w", "Toggle Work", mod.toggleDoNotDisturb)
end

function mod.unload() end

return mod
