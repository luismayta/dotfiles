local application = require("core.hs.application")

local M = {}

-- Toggle app by logical key (defined in config)
function M.toggle(context, key)
  if not context or not context.config then
    error("ApplicationService: missing context or config")
  end

  local apps = context.config.applications or {}

  local bundleId = apps[key]
  if not bundleId then
    error("ApplicationService: unknown application key -> " .. tostring(key))
  end

  application.toggle(bundleId)
end

return M