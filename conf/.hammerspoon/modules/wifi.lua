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
               fn = { hs.fnutils.partial(reconfigVolume, 100) }
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
