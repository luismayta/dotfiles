local fn = require("core.functions")
local config = {}

config.hotkeys = {}

config.spoons = {
  {
{
      name = "WifiNotifier",
      settings = {
        start = true,
      },
    },
  name = "WiFiTransitions", {
    config = {
      actions = {
        -- { -- Test action just to see the SSID transitions
        --    fn = function(_, _, prev_ssid, new_ssid)
        --       hs.notify.show("SSID change", string.format("From '%s' to '%s'", prev_ssid, new_ssid), "")
        --    end
        -- },
        {
          to = "EvilHome",
          fn = function(_, _, _, _)
            hs.fnutils.partial(fn.reconfigVolume, 80)
            hs.execute(settings.DnsEmpty)
            hs.execute(settings.DnsCloudflare)
          end,
        },
        {
          to = "Evilcorp",
          fn = function(_, _, _, _)
            hs.fnutils.partial(fn.reconfigVolume, 80)
            hs.execute(settings.DnsEmpty)
            hs.execute(settings.DnsCloudflare)
          end,
        },
        {
          from = "ulwifiT",
          fn = function(_, _, _, _)
            hs.fnutils.partial(fn.reconfigVolume, 25)
            hs.execute(settings.DnsEmpty)
            hs.execute(settings.DnsCloudflare)
          end,
        },
        {
          from = "ulwifi",
          fn = function(_, _, _, _)
            hs.fnutils.partial(fn.reconfigVolume, 25)
            hs.execute(settings.DnsEmpty)
            hs.execute(settings.DnsCloudflare)
          end,
        },
        {
          to = "ulwifiT",
          fn = function(_, _, _, _)
            hs.execute(settings.DnsEmpty)
          end,
        },
        {
          to = "ulwifi",
          fn = function(_, _, _, _)
            hs.execute(settings.DnsEmpty)
          end,
        },
        {
          to = "Wayra 5G",
          fn = function(_, _, _, _)
            hs.fnutils.partial(fn.reconfigVolume, 50)
            hs.execute(settings.DnsEmpty)
          end,
        },
        {
          to = "VIPAC-INVITADOS",
          fn = function(_, _, _, _)
            hs.fnutils.partial(fn.reconfigVolume, 50)
            hs.execute(settings.DnsEmpty)
          end,
        },
        {
          from = "VIPAC-INVITADOS",
          fn = function(_, _, _, _)
            hs.fnutils.partial(fn.reconfigVolume, 25)
            hs.execute(settings.DnsEmpty)
            hs.execute(settings.DnsCloudflare)
          end,
        },
      },
    },
    start = true,
  }
  }
}

return config