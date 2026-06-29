-- luacheck: globals hs spoon

local function init(_)

  local hotkey = require("core.hotkey")
  local fntools = require("core.functions")

  hotkey.bindWithAlt(
    'm', 'Toggle Full Screen', function ()
      hs.window.focusedWindow():toggleFullScreen()
    end
  )

  -- move screen
  hotkey.bindWithAlt(
    'l', 'Move to right', function ()
     fntools.goRight()
    end
  )
  hotkey.bindWithAlt(
    'h', 'Move to left', function ()
     fntools.goLeft()
    end
  )

  -- hs.hotkey.bind(hyper, "D", screenToRight)
  -- hs.hotkey.bind(hyper, "A", screenToLeft)
end

return init