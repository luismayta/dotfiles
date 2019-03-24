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

require("application_window_states")

---------------------------------------------------------
-- Shared Globals
---------------------------------------------------------

-- used to save states for windows
appStates = ApplicationWindowStates:new()

---------------------------------------------------------
-- Debugging
---------------------------------------------------------

dbg = function(...)
  print(hs.inspect(...))
end

dbgf = function (...)
  return dbg(string.format(...))
end

function tap (a)
  dbg(a)
  return a
end

---------------------------------------------------------
-- Extension of native objects and modules
---------------------------------------------------------

-- Create a unique string for a window
-- @returns string
function hs.window:key()
  local applicationName = compose(
    getProperty("application"),
    getProperty("title")
  )(self)

  return string.format("%s:%s", applicationName, self:id())
end


function hs.window:isMaximized()
  local screen = self:screen()
  local screenFrame = screen:frame()

  return compareShallow(self:frame(), screenFrame)
end


function hs.mouse.centerOnRect(rect)
  hs.mouse.setAbsolutePosition(geometry.rectMidPoint(rect))
end


---------------------------------------------------------
-- MODAL HOTKEY UTILS
---------------------------------------------------------

mode = {}

mode.hide = nil

mode.enter = function(modalName, subName)
  if subName then modalName = string.format('%s::%s', modalName, subName) end
  modeLabel = string.format("Mode: %s", modalName)

  local pos = {x = 0, y = 10, w = 300, h = 30}
  modeIndicator = hs.drawing.rectangle(pos)
  modeIndicator:setRoundedRectRadii(10, 10)

  pos.x, pos.y = pos.x + 15, pos.y + 18
  modeText = hs.drawing.text(pos, modeLabel)
  modeText:setTextSize(16)

  modeIndicator:show()
  modeText:show()

  mode.hide = function()
    modeText:hide()
    modeIndicator:hide()
  end
end

mode.exit = function()
  mode.hide()
end

---------------------------------------------------------
-- COORDINATES, POINTS, RECTS, FRAMES, TABLES
---------------------------------------------------------

-- Fetch next index but cycle back when at the end
--
-- > getNextIndex({1,2,3}, 3)
-- 1
-- > getNextIndex({1}, 1)
-- 1
-- @return int
local function getNextIndex(table, currentIndex)
  nextIndex = currentIndex + 1
  if nextIndex > #table then
    nextIndex = 1
  end

  return nextIndex
end

---------------------------------------------------------
-- SCREEN
---------------------------------------------------------

-- NOTE, Screens use relative coordinates, all the screens
-- make up a big screen, so you have do adjust accordingly
function manipulateScreen(func)
  return function()
    local window = hs.window.focusedWindow()
    local windowFrame = window:frame()
    local screen = window:screen()
    local screenFrame = screen:frame()

    func(window, windowFrame, screen, screenFrame)
  end
end


fullScreenCurrent = function()
  window = hs.window.focusedWindow()
  if not window then return end

  -- no prev state
    -- fullscreen
    -- no fullscreen
      -- toggle fullscreen

  -- prev state
    -- fullscreen
      -- revert to prev state if prev state
    -- no fullscreen
      -- toggle fullscreen

  if window:isMaximized() then
    dbg('NOT MAXIMIZED')
    if appStates:lookup(window) then
      dbg('FOUND STATE')
      -- if we restore the entire state though, the state
      -- that could have been altered since the last state save
      -- (probably triggered by some window manipulation hotkey)
      -- is lost

      -- perhaps distinguish between a full state reset and a partial one?
      -- so we could just reset the window position
      appStates:restore(window)
      -- else would be to just make it smaller?
      -- i.e. we're already a huge window, then make it smaller and save the state
    end
  else
    dbg('MAXIMIZING')
    appStates:save()
    manipulateScreen(function(window, windowFrame, screen, screenFrame)
      window:setFrame(screenFrame)
    end)()
  end
end


screenToRight = manipulateScreen(function(window, windowFrame, screen, screenFrame)
  windowFrame.w = screenFrame.w / 2
  windowFrame.x = (screenFrame.w / 2) + screenFrame.x
  windowFrame.h = screenFrame.h + 10

  window:setFrame(windowFrame)
end)

screenToLeft = manipulateScreen(function(window, windowFrame, screen, screenFrame)
  screenFrame.w = screenFrame.w / 2
  window:setFrame(screenFrame)
end)

---------------------------------------------------------
-- MOUSE
---------------------------------------------------------

local function centerMouseOnRect(frame)
  hs.mouse.setAbsolutePosition(geometry.rectMidPoint(frame))
end

local mouseCircle = nil
local mouseCircleTimer = nil

function mouseHighlight()
  -- Delete an existing highlight if it exists
  result(mouseCircle, "delete")
  result(mouseCircleTimer, "stop")

  -- Get the current co-ordinates of the mouse pointer
  mousepoint = hs.mouse.get()

  -- Prepare a big circle around the mouse pointer
  mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 85, 85))
  mouseCircle:setFillColor({["red"]=0,["blue"]=1,["green"]=0,["alpha"]=0.5})
  mouseCircle:setStrokeWidth(5)
  mouseCircle:show()

  -- Set a timer to delete the circle after 3 seconds
  mouseCircleTimer = hs.timer.doAfter(0.2, function()
    mouseCircle:delete()
  end)
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
                    table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

---------------------------------------------------------
-- APPLICATION / WINDOW
---------------------------------------------------------

-- Returns the next successive window given a collection of windows
-- and a current selected window
--
-- @param  windows  list of hs.window or applicationName
-- @param  window   instance of hs.window
-- @return hs.window
local function getNextWindow(windows, window)
  if type(windows) == "string" then
    windows = hs.appfinder.appFromName(windows):allWindows()
  end

  -- windows = filter(windows, hs.window.isStandard)
  -- windows = filter(windows, hs.window.isVisible)

  -- need to sort by ID, since the default order of the window
  -- isn't usable when we change the mainWindow
  -- since mainWindow is always the first of the windows
  -- hence we would always get the window succeeding mainWindow
  table.sort(windows, function(w1, w2)
    return w1:id() > w2:id()
  end)

  lastIndex = indexOf(windows, window)

  dbgf('windows: ' .. table.tostring(windows))
  dbgf('current window: ' .. tostring(window))
  dbgf('lastIndex: ' .. tostring(lastIndex))
  dbgf('nextIndex: ' .. tostring(getNextIndex(windows, lastIndex)))

  return windows[getNextIndex(windows, lastIndex)]
end

function getApplicationWindow(applicationName)
  local apps = hs.application.runningApplications()
  local app = hs.fnutils.filter(apps, function(app)
    return result(app, 'title') == applicationName
  end)

  if app and #app then
    windows = app[1]:allWindows()
    window = windows[1]
    return window
  else
    return nil
  end
end

-- Needed to enable cycling of application windows
lastToggledApplication = ''

function launchOrCycleFocus(applicationName, applicationTitle)
  return function()
    local nextWindow = nil
    local targetWindow = nil
    local focusedWindow          = hs.window.focusedWindow()
    local lastToggledApplication = focusedWindow and focusedWindow:application():title()

    -- Note, applicationTitle is optional, and only useful in those
    -- cases where the name and title are not the same (i.e. Visual Studio Code).
    if applicationTitle == nil then
        applicationTitle = applicationName
    end

    if not focusedWindow then return nil end

    -- save the state of currently focused app
    appStates:save()

    dbgf('last: %s, current: %s', lastToggledApplication, applicationTitle)

    if lastToggledApplication == applicationTitle then
      hs.eventtap.keyStroke({"cmd"}, "`")
      nextWindow = hs.window.focusedWindow()
    else
      hs.application.launchOrFocus(applicationName)
    end

    -- this blindly assumed that previous steps have been successful..
    if nextWindow then -- won't be available when appState empty
      targetWindow = nextWindow
    else
      targetWindow = hs.window.focusedWindow()
    end

    if not targetWindow then
      dbgf('failed finding a window for application: %s', applicationName)
      return nil
    end

    if appStates:lookup(targetWindow) then
      dbgf('restoring state of: %s', targetWindow:application():title())
      appStates:restore(targetWindow)
    else
      local windowFrame = targetWindow:frame()
      hs.mouse.centerOnRect(windowFrame)
    end

    mouseHighlight()
  end
end




---------------------------------------------------------
-- KEYBOARD / MOUSE
---------------------------------------------------------

-- Returns what key was pressed on an eventtap object
-- @param   event   the parameter for eventtap callbacks
-- @return  string
local eventToCharacter = compose(
  getProperty('getKeyCode'),
  partial(result, hs.keycodes.map),
  partial(flip(invoke), 'lower')
)

-- Capture a number of keystrokes and sends it to a function
--
-- Example:
--
-- captureKeys(1, function(firstKey)
--   print(firstKey)
-- end)
--
-- captureKeys(2, function(firstKey, secondKey) print(secondKey) end, function(key)
--   return hs.fnutils.contains({"a", "b", "c"}, key)
-- end)
--
-- @param {int} numberOfKeystrokes
-- @param {Function} callback gets each of the keystrokes as a parameter
-- @param {Function} Optional validator for each of the keypresses
-- @return nil
function captureKeys(numberOfKeystrokes, callback, keyValidator)
  local events = {
    hs.eventtap.event.types.keydown
  }
  local capturedKeys = {}
  local currentWatcher = nil

  function captureKeystroke()
    local watcher = hs.eventtap.new(events, keystrokeHandler)
    watcher:start()
    currentWatcher = watcher
    return watcher
  end

  function keystrokeHandler(event, foo, bar)
    currentWatcher:stop()

    local char = eventToCharacter(event)

    if isFunction(keyValidator) and not keyValidator(char) then
      dbgf('received invalid char: %s', char)
      captureKeystroke()
      return true
    end

    dbgf('received char: %s', char)
    table.insert(capturedKeys, char)

    if #capturedKeys < numberOfKeystrokes then
      captureKeystroke()
    else
      callback(table.unpack(capturedKeys))
    end

    -- delete the event handler
    return true
  end

  captureKeystroke()
end
