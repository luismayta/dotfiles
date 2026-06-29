local M = {}

M.global = require("config.global")
M.workspace = require("config.workspace")
M.window = require("config.window")

M.features = {
  workspace = true,
  window = true,
}

return M
