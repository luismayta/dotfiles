local merge = require("core.config.utils.merge")
local keys = require(".keys")
local fn = require("core.functions")
local moduleConfig = require(".config")

return function(globalConfig)
  local config = merge.mergeWith(moduleConfig, globalConfig)

  fn.installSpoons(config.spoons)
  keys.registerHotkeys(config.profiles)
end