-- luacheck: globals hs
local M = {}

function M.notifyUsb(deviceName)
  hs.notify.new({ title = deviceName }):send()
  hs.notify.new({ title = "Hammerspoon Reloaded" }):send()
end

function M.notifyBluetooth(deviceName)
  hs.notify.new({ title = deviceName }):send()
  hs.notify.new({ title = "Bluetooth Device Connected" }):send()
end

return M