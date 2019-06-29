local hotkey = require('core.hotkey')
local module = {}

function module.toggleDoNotDisturb()
   -- check if enabled
   local _, res = hs.applescript.applescript([[
    tell application "System Events"
      tell application process "SystemUIServer"
        tell (every menu bar whose title of menu bar item 1 contains "Notification")
          return title of (1st menu bar item whose title contains "Notification")
        end tell
      end tell
    end tell
  ]])

   local isEnabled = string.match(res[1], 'Do Not Disturb')
   local afterTime = isEnabled and 0.0 or 2.0

   -- is not enabled, will be enabled
   if not isEnabled then
      hs.notify.new({
            title        = 'Do Not Disturb',
            subTitle     = 'Enabled',
      }):send()
   end

   -- toggle, wait a bit if we've send notification
   hs.timer.doAfter(
      afterTime,
      function()
         hs.applescript.applescript([[
      tell application "System Events"
        option key down
        tell application process "SystemUIServer"
          tell (every menu bar whose title of menu bar item 1 contains "Notification")
            click (1st menu bar item whose title contains "Notification")
          end tell
        end tell
        option key up
      end tell
    ]])

        -- is enabled, was disabled
        if isEnabled then
           hs.notify.new({
                 title        = 'Do Not Disturb',
              subTitle     = 'Disabled',
        }):send()
        end
      end
   )
end


function module.init()
   hotkey.bindWithCtrlAlt(
      "w", "Toggle Work", module.toggleDoNotDisturb
   )
end

return module
