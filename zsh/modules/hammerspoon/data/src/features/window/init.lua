local service = require("domain.window.service")
local logger = require("core.logger").get("window.feature")

local M = {}

local config = {}

local function register(context, hk, action)
  if not hk then
    logger.warn("Hotkey config missing")
    return
  end

  if not hk.mods or not hk.key then
    logger.warn("Invalid hotkey config: mods=%s key=%s", logger.inspect(hk.mods), tostring(hk.key))
    return
  end

  context.hotkey:bind(hk.mods, hk.key, hk.desc, action)
end

local function installSpoons(context)
  if not config or not config.spoons then
    return
  end

  local spoonInstall = context.spoon_manager
  if not spoonInstall then
    context.log.ef("SpoonInstall not available in context")
    return
  end

  for _, sp in ipairs(config.spoons) do
    context.log.df("Installing spoon: %s", sp.name)

    if sp.settings then
      spoonInstall:use(sp.name, sp.settings)
    else
      spoonInstall:use(sp.name)
    end
  end
end

function M.setup(context)
  config = context.config.window
  if not config then
    logger.warn(" config missing")
    return
  end

  installSpoons(context)

  if not config or not config.hotkeys then
    logger.warn("Window hotkey config missing")
    return
  end

  register(context, config.hotkeys.toggleFullscreen, function()
    service.toggleFullscreen(context)
  end)
  register(context, config.hotkeys.moveToNextScreen, function()
    service.moveToNextScreen(context)
  end)
end

return M
