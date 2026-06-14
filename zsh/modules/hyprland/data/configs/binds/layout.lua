local custom = require("custom")

local M = {}

function M.register(mainMod)
  -- Toggle split orientation
  hl.bind(mainMod .. " + R", hl.dsp.layout("togglesplit"))

  -- Cycle through layouts
  hl.bind(mainMod .. " + Backslash", custom.dsp.next_layout())
  hl.bind(mainMod .. " + SHIFT + Backslash", custom.dsp.prev_layout())
end

return M
