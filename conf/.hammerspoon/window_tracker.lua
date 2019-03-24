require "fntools"
local fnutils = require "hs.fnutils"
each   = fnutils.each
filter = fnutils.filter
map    = fnutils.map

uielement = require "hs.uielement"

isApplication = uielement.isApplication
isWindow      = uielement.isWindow

local events = hs.uielement.watcher

appEvents = {
  events.mainWindowChanged,
  events.focusedWindowChanged,
  events.windowCreated,
  events.applicationActivated,
  events.applicationDeactivated
}

windowEvents = {
  events.windowCreated,
  events.focusedWindowChanged,
  events.windowMoved
}

function elementType(element)
  if isApplication(element) then
    return "application"
  elseif isWindow(element) then
    return "window"
  else
    return "unknown"
  end
end

function describeApplicationState()
  dbgf('application: %s', hs.window.focusedWindow():application():title())
  dbgf('window id: %s', hs.window.focusedWindow():id())
end

function delinate()
  dbgf('----------------------------------------')
end

function eventHandler (element, eventName, watcher, includedData)
  dbgf('%s event: %s', elementType(element), eventName)
  describeApplicationState()
  delinate()
end

function globalEventHandler(applicationName, eventType, application)
  dbgf('%s event: %s, app: %s', eventType, eventName, application:title())
  delinate()
end

watchers = {}


-- Note:

-- This stuff barely works,
-- sends totally different notifications depending on the applications.

-- apps send multiple events when activating/deactivating

-- seemingly no way of consistently getting notified when windows receive
-- focus

function startWatchingEvents()
  local apps = hs.application.runningApplications()

  -- WATCH FOR GLOBAL EVENTS

  globWatcher = hs.application.watcher.new(globalEventHandler)
  globWatcher:start()

  -- WATCH FOR APP EVENTS

  apps = filter(apps, function(app)
    return app:title() ~= "Hammerspoon"
  end)
  appWatchers = map(apps, function(app)
    return app:newWatcher(eventHandler)
  end)
  appWatchers = filter(appWatchers, function(watcher)
    return watcher._element.pid -- ???? what is _element.pid?
  end)
  each(appWatchers, function(watcher)
    watcher:start(appEvents)
  end)

  -- WATCH FOR WINDOW EVENTS

  appWindows = map(apps, function(app)
    return app:allWindows()
  end)
  appWindows = flatten(appWindows)
  appWindows = filter(appWindows, hs.window.isStandard)

  appWindowWatchers = map(appWindows, function(window)
    return window:newWatcher(eventHandler)
  end)
  each(appWindowWatchers, function(watcher)
    watcher:start(windowEvents)
  end)

end

-- startWatchingEvents()



-- from https://gist.github.com/cmsj/591624ef07124ad80a1c
function init()

  -- Handle opening new apps / closing apps
  appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)
  appsWatcher:start()

  -- Watch any apps that already exist
  local apps = hs.application.runningApplications()

  apps = filter(apps, function(app)
    return app:title() ~= "Hammerspoon"
  end)

  each(apps, function(app)
    watchApp(app, true)
  end)
end

function handleGlobalAppEvent(name, event, app)
  if     event == hs.application.watcher.launched then
    watchApp(app)
  elseif event == hs.application.watcher.terminated then
    -- Clean up
    local appWatcher = watchers[app:pid()]
    if appWatcher then
      appWatcher.watcher:stop()
      for id, watcher in pairs(appWatcher.windows) do
        watcher:stop()
      end
      watchers[app:pid()] = nil
    end
  end
end

function watchApp(app, initializing)
  if watchers[app:pid()] then return end

  local watcher = app:newWatcher(handleAppEvent)


  if not watcher._element.pid then
    dbg('No PID for app '..app:title())
    return
  end

  watchers[app:pid()] = {
    watcher = watcher,
    windows = {}
  }

  watcher:start({
    events.mainWindowChanged,
    events.focusedWindowChanged,
    events.windowCreated,
    events.applicationActivated,
    events.applicationDeactivated
  })

  -- Watch any windows that already exist
  for i, window in pairs(app:allWindows()) do
    watchWindow(window, initializing)
  end
end

function handleAppEvent(element, event, watcher, info)
  if event == events.windowCreated then
    hs.alert.show('app event '..event..' on '..element:id())
    watchWindow(element)
  elseif event == events.focusedWindowChanged then
    hs.alert.show('app event '..event..' on '..element:id())
    print('ASIDJOIASJDOI')
  end
end

function watchWindow(win, initializing)
  local appWindows = watchers[win:application():pid()].windows

  if win:isStandard() and not appWindows[win:id()] then
    local watcher = win:newWatcher(handleWindowEvent, {
      pid = win:pid(),
      id = win:id()
    })
    appWindows[win:id()] = watcher

    watcher:start({
      events.elementDestroyed,
      events.windowResized,
      events.windowMoved
    })

    if not initializing then
      hs.alert.show('window created: '..win:id()..' with title: '..win:title())
    end
  end
end

function handleWindowEvent(win, event, watcher, info)
  if event == events.elementDestroyed then
    watcher:stop()
    watchers[info.pid].windows[info.id] = nil
  else
    hs.alert.show('window event '..event..' on '..info.id)
    -- Handle other events...
  end
  hs.alert.show('window event '..event..' on '..info.id)
end

-- init()