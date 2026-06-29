-- luacheck: globals hs spoon
local pomodor = require('mod.pomodoor')
local hotkey = require('core.hotkey')
local logger = require("hs.logger")
local fn = require("core.functions")
local caffeine = hs.loadSpoon("Caffeine")

local notification = {}

notification.icon = hs.image.imageFromPath('assets/notification-center.png'):setSize({ w = 20, h = 20 })

-- debugging
local log = logger.new("notification", "debug")

notification.vars = {
  afterTime= 2,
  messageEnabled = {
      title        = 'Start Working with Not Disturb',
      subTitle     = 'Enabled',
      contentImage = notification.icon,
  },
  messageDisabled = {
      title        = 'Do Not Disturb',
      subTitle     = 'Disabled',
      contentImage = notification.icon,
  }
}

function notification.isEnabled()
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

  local isEnabled = string.match(res[1], 'Do Not Disturb')
  return isEnabled
end

function notification.disable()
  fn.setStatusNotification("disable")
end

function notification.enable()
  fn.setStatusNotification("enable")
end

function notification.startWorking()
  pomodor.enable()
  caffeine:start()
  notification.enable()
end

function notification.stopWorking()
  pomodor.disable()
  caffeine:stop()
  notification.disable()
end


function notification.toggleDoNotDisturb()
  -- check if enabled
  local isEnabled = notification.isEnabled()
  local isPomododorEnabled = pomodor.isEnabled()

  if isPomododorEnabled == true then
    log:d("disabled working!")
    hs.notify.new(notification.vars.messageDisabled):send()
    notification.stopWorking()
  else
    log:d("active working!")
    hs.notify.new(notification.vars.messageEnabled):send()
    notification.startWorking()
  end
end

function notification.init()
  hotkey.bindWithCtrlAlt(
      "w", "Toggle Work", notification.toggleDoNotDisturb
  )
end

notification.init()

return notification
