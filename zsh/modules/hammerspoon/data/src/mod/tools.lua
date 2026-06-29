-- luacheck: globals hs spoon
local fn = require("core.functions")

local function init(config)
  fn.installSpoons(config.spoons)
end

return init