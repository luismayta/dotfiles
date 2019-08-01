require("core.fntools")
local hotkey = require('core.hotkey')
hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall

Install:andUse(
   "WiFiTransitions",
   {
      config = {
         actions = {
            -- { -- Test action just to see the SSID transitions
            --    fn = function(_, _, prev_ssid, new_ssid)
            --       hs.notify.show("SSID change", string.format("From '%s' to '%s'", prev_ssid, new_ssid), "")
            --    end
            -- },
            {
               to = "Evilcorp",
               fn = function(_, _, prev_ssid, new_ssid)
                  hs.execute("networksetup -setdnsservers Wi-Fi empty")
                  hs.execute("networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1")
               end
            },
            {
               to = "ulwifiT",
               fn = function(_, _, prev_ssid, new_ssid)
                  hs.execute("networksetup -setdnsservers Wi-Fi empty")
               end
            },
            {
               from = "Wayra 5G",
               fn = { hs.fnutils.partial(reconfigVolume, 25) }
            },
            {
               from = "VIPAC-INVITADOS",
               fn = { hs.fnutils.partial(reconfigVolume, 25) }
            },
         }
      },
      start = true,
   }
)
