local merge = require("core.config.utils.merge")
local moduleConfig = require("mod.work.config")
local fn = require("core.functions")
local keys = require("mod.work.keys")

return function(globalConfig)
  local config = merge.mergeWith(moduleConfig.build(globalConfig), globalConfig)

  fn.installSpoons(config.spoons)
  keys.registerHotkeys(config.profiles)

  require("mod.work.apps")(config)
  require("mod.work.screens")(config)
end