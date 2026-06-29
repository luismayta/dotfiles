--[[
File:    core/config/init.lua
Purpose: Loads and merges user custom.lua overrides with defaults, then validates
         the merged configuration via schema. Config builder entry point.
Author:  Hammerspoon Config Team
--]]

local defaults = require("core.config.defaults").values
local loader = require("core.config.loader")
local tableUtil = require("core.utils.table")
local schema = require("core.config.schema")
local logger = require("core.logger").get("config")

local M = {}

function M.build()
  local loaded = loader.load()

  local config = tableUtil.merge(defaults, loaded.global)
  config = tableUtil.merge(config, loaded.localConfig)
  config = tableUtil.merge(config, loaded.custom)

  local ok, err = pcall(function()
    schema.validate(config)
  end)

  if not ok then
    logger:warn("Config validation failed (using defaults): %s", tostring(err))
  end

  return config
end

return M
