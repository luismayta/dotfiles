local defaults = require("core.config.defaults").values
local loader = require("core.config.loader")
local tableUtil = require("core.utils.table")
local schema = require("core.config.schema")

local M = {}

function M.build()
  local loaded = loader.load()

  local config = tableUtil.merge(defaults, loaded.global)
  config = tableUtil.merge(config, loaded.localConfig)
  config = tableUtil.merge(config, loaded.custom)

  schema.validate(config)

  return config
end

return M
