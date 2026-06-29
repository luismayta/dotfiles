--[[
File:    core/functions.lua
Purpose: Shared utility functions used across Hammerspoon modules.
         Provides spoon installation, status notifications, window management,
         and volume control.
--]]

local module = {}

--- Installs a list of spoons.
-- Iterates a table of spoon definitions and loads each one via hs.loadSpoon,
-- storing the resulting object back on the definition table.
-- @param spoons table - Array of spoon objects with `name` field
function module.installSpoons(spoons)
  if not spoons then
    return
  end
  for _, spoon in ipairs(spoons) do
    if type(spoon) == "table" and spoon.name then
      local obj = hs.loadSpoon(spoon.name)
      if obj then
        spoon.object = obj
      end
    end
  end
end

--- Sets or updates a status bar notification.
-- Creates a persistent hs.menubar item on first call and updates its title.
-- @param state string - Status text to display in the menubar
function module.setStatusNotification(state)
  if not module._statusItem then
    module._statusItem = hs.menubar.new()
  end
  module._statusItem:setTitle(state)
  module._statusItem:show()
end

--- Moves the focused window to the right half of the screen.
function module.goRight()
  local win = hs.window.focusedWindow()
  if not win then
    return
  end
  local screen = win:screen()
  local frame = screen:frame()
  local newFrame = hs.geometry.rect(frame.x + frame.w / 2, frame.y, frame.w / 2, frame.h)
  win:setFrame(newFrame)
end

--- Moves the focused window to the left half of the screen.
function module.goLeft()
  local win = hs.window.focusedWindow()
  if not win then
    return
  end
  local screen = win:screen()
  local frame = screen:frame()
  local newFrame = hs.geometry.rect(frame.x, frame.y, frame.w / 2, frame.h)
  win:setFrame(newFrame)
end

--- Sets the system volume to a given level.
-- @param level number - Volume level 0–100
function module.reconfigVolume(level)
  local device = hs.audiodevice.defaultOutputDevice()
  if device then
    device:setOutputVolume(level)
  end
end

return module
