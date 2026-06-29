local M = {}

local function getHotkeys()
  return {}
end

local function getApps()
  return {}
end

local function getSpoons(hotkey, handlers)
  return {
    {
      name = "USBDeviceActions",
 {
        config = {
            devices = {
                MrRobot = { fn = handlers.notifyUsb },
            },
        },
        start = true,
    }
    },
    {
      name = "BluetoothDeviceActions",
 {
        config = {
            devices = {
                AirPods = { fn = handlers.notifyBluetooth },
            },
        },
        start = true,
    }

    },
  }
end

function M.build(globalConfig, handlers)
  local hotkey = globalConfig and globalConfig.hotkey or {}

  return {
    hotkeys = getHotkeys(),
    apps = getApps(),
    spoons = getSpoons(hotkey, handlers),
  }
end

return M