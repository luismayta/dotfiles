local M = {}

---------------------------------------------
-- OS X isDoNotDisturbEnabled
---------------------------------------------
function M.isDoNotDisturbEnabled()
  local command = "defaults -currentHost read com.apple.notificationcenterui doNotDisturb"

  local mode, _, _, _ = hs.execute(command)

  return tonumber(mode) == 1
end

---------------------------------------------
-- OS X Toggle Status Notification
---------------------------------------------
function M.toggleDoNotDisturb()
  local _, status, type, rc = hs.execute("do-not-disturb toggle", true)

  if not (status == true and type == "exit" and rc == 0) then
    hs.alert("Whoops! Toggling 'Do Not Disturb' failed.")

    local alertDurationInSeconds = 4
    hs.alert(
      "Make sure you have sindresorhus/do-not-disturb-cli installed and try again.",
      hs.alert.defaultStyle,
      hs.screen.mainScreen(),
      alertDurationInSeconds
    )
  end
end

---------------------------------------------
-- OS X Notification SetStatusNotification
---------------------------------------------
function M.setStatusNotification(status)
  local script = "do-not-disturb off"
  if status == "enable" then
    script = "do-not-disturb on"
  end

  local _, _, _, code = hs.execute(script, true)
  return status
end

---------------------------------------------
-- OS X Notification Clear
---------------------------------------------
function M.clearNotifications()
  local script = [[
    my closeNotif()
    on closeNotif()
        tell application "System Events"
            tell process "Notification Center"
                set theWindows to every window
                repeat with i from 1 to number of items in theWindows
                    set this_item to item i of theWindows
                    try
                        click button 1 of this_item
                    on error
                        my closeNotif()
                    end try
                end repeat
            end tell
        end tell
    end closeNotif
  ]]

  local response, err = pcall(hs.applescript.applescript(script))
  if err == true then
    error(err)
  end
  return response
end

return M
