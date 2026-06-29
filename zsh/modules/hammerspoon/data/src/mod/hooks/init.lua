local merge = require("core.config.utils.merge")
local moduleConfig = require("mod.hooks.config")
local handlers = require("mod.hooks.handlers")
local fn = require("core.functions")
local keys = require("mod.hooks.keys")

return function(globalConfig)
  local config = merge.mergeWith(moduleConfig.build(globalConfig, handlers), globalConfig)

  fn.installSpoons(config.spoons)
end