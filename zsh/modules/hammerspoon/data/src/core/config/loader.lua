--[[
File:    core/config/loader.lua
Purpose: Loads custom.lua from the data directory, returning the user's overrides
         (or nil). Supports global, local, and custom config layers.
Author:  Hammerspoon Config Team
--]]

local M = {}

local function safeRequire(path)
  local ok, result = pcall(require, path)
  if ok then
    return result
  end
  return {}
end

function M.load()
  return {
    global = safeRequire("config.global"),
    localConfig = safeRequire("local"),
    custom = safeRequire("custom"),
  }
end

return M
