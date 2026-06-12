---@class HL.Custom
---@field dsp HL.Custom.DspNamespace
---@field helper HL.Custom.HelperNamespace
---@field layout HL.Custom.LayoutNamespace
---@type HL.Custom
local M = {
  dsp = require("custom.dispatcher"),
  helper = require("custom.helper"),
  layout = require("custom.layout"),
}

return M
