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
                  hs.fnutils.partial(reconfigVolume, 80)
                  hs.execute("networksetup -setdnsservers Wi-Fi empty")
                  hs.execute("networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1")
               end
            },
            {
               from = "ulwifiT",
               fn = function(_, _, prev_ssid, new_ssid)
                  hs.fnutils.partial(reconfigVolume, 25)
                  hs.execute("networksetup -setdnsservers Wi-Fi empty")
                  hs.execute("networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1")
               end
            },
            {
               from = "ulwifi",
               fn = function(_, _, prev_ssid, new_ssid)
                  hs.fnutils.partial(reconfigVolume, 25)
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
               to = "ulwifi",
               fn = function(_, _, prev_ssid, new_ssid)
                  hs.execute("networksetup -setdnsservers Wi-Fi empty")
               end
            },
            {
               to = "Wayra 5G",
               fn = { hs.fnutils.partial(reconfigVolume, 25) }
            },
            {
               to = "VIPAC-INVITADOS",
               fn = function(_, _, prev_ssid, new_ssid)
                  hs.fnutils.partial(reconfigVolume, 50)
                  hs.execute("networksetup -setdnsservers Wi-Fi empty")
               end
            },
            {
               from = "VIPAC-INVITADOS",
               fn = function(_, _, prev_ssid, new_ssid)
                  hs.fnutils.partial(reconfigVolume, 25)
                  hs.execute("networksetup -setdnsservers Wi-Fi empty")
                  hs.execute("networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1")
               end
            },
         }
      },
      start = true,
   }
)
