local M = {}

function M.toggleFullscreen()
  local win = hs.window.focusedWindow()
  if win then
    win:toggleFullScreen()
  end
end

function M.moveToNextScreen()
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local screens = hs.screen.allScreens()
  if #screens < 2 then
    return
  end

  local current = win:screen()
  local nextScreen = current:next()
  if not nextScreen then
    return
  end

  local wasFullscreen = win:isFullScreen()

  if wasFullscreen then
    win:setFullScreen(false)

    hs.timer.doAfter(0.6, function()
      if not win or not win:isStandard() then
        return
      end

      win:moveToScreen(nextScreen)
      win:centerOnScreen(nextScreen)

      hs.timer.doAfter(0.3, function()
        if win and win:isStandard() then
          win:setFullScreen(true)
        end
      end)
    end)
  else
    win:moveToScreen(nextScreen)
    win:centerOnScreen(nextScreen)
  end
end

return M
