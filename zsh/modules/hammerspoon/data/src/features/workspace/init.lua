local service = require("domain.workspace.service")
local logger = require("core.logger").get("workspace.feature")

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

local function registerApps(context)
  if not config or not config.apps then
    logger.warn("No workspace apps configured")
    return
  end

  for _, entry in ipairs(config.apps) do
    if not entry.mods or not entry.key or not entry.app then
      logger.warn("Invalid app config: %s", logger.inspect(entry))
    else
      context.hotkey:bind(entry.mods, entry.key, entry.app, function()
        service.launchOrFocus(context, entry.app)
      end)
    end
  end
end

function M.setup(context)
  config = context.config.workspace

  if not config then
    logger.warn("Workspace config missing")
    return
  end

  registerApps(context)

  if not config.hotkeys then
    logger.warn("Workspace hotkeys config missing")
    return
  end

  register(context, config.hotkeys.switchProfile, function()
    service.switchProfile(context, "developer")
  end)
end

return M
