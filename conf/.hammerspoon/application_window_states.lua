require "fntools"

partial = hs.fnutils.partial
sequence = hs.fnutils.sequence

local fnutils = require "hs.fnutils"
local map = fnutils.map
local each = fnutils.each
local partial = fnutils.partial
local indexOf = fnutils.indexOf
local filter = fnutils.filter
local concat = fnutils.concat
local contains = fnutils.contains

local window = require "hs.window"
local alert = require "hs.alert"
local grid = require "hs.grid"
local geometry = require "hs.geometry"

-- Captured snapshots of an application windows state
-- used to save and restore snapshots when moving
-- between applications

ApplicationWindowStates = {}

function ApplicationWindowStates:new()
  self.__index = self
  return setmetatable({}, self)
end

function ApplicationWindowStates:key(window)
  if not window then
    return ''
  end

  return window:key()
end

function ApplicationWindowStates:save()
  local window = hs.window.focusedWindow()
  local applicationStateKey = self:key(window)

  self[applicationStateKey] = {
    ["screen"] = hs.mouse.getCurrentScreen(),
    ["mouse"]  = hs.mouse.getAbsolutePosition(), -- mouse or nil
    ["windowFrame"] = window:frame()
  }
end

function ApplicationWindowStates:lookup(window)
  local key = self:key(window)
  return self[key]
end

function ApplicationWindowStates:restore(window, restoreFn)
  local restoreState = result(self, self:key(window))

  local restoreMousePosition = compose(
    maybe(getProperty('mouse')),
    -- even if the mouse goes outside the window, and that app is saved
    -- make sure it appears within the window
    maybe(function(mouseCoordinates)
      local windowFrame = window:frame()

      if geometry.isPointInRect(mouseCoordinates, windowFrame) then
        hs.mouse.setAbsolutePosition(mouseCoordinates)
      else
        hs.mouse.centerOnRect(windowFrame)
      end
    end)
  )

  local restoreScreenFrame = compose(
    maybe(getProperty("windowFrame")),
    maybe(function(savedFrame)
      window:setFrame(savedFrame)
    end)
  )

  if restoreState then
    restoreMousePosition(restoreState)
    restoreScreenFrame(restoreState)
  end
end

function ApplicationWindowStates:delete(window)
  local state = self:lookup(window)

  if not state then return end

  local stateIndex = indexof(self, state)

  table.remove(self, stateIndex)
end