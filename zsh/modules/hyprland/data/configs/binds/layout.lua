local custom = require("custom")

local M = {}

function M.register(mainMod, C)
  -- Toggle split orientation
  hl.bind(C.DIRECT .. " + R", hl.dsp.layout("togglesplit"))

  -- Cycle through layouts
  hl.bind(C.DIRECT .. " + Backslash", custom.dsp.next_layout())
  hl.bind(C.SUPER_SHIFT .. " + Backslash", custom.dsp.prev_layout())
end

return M
