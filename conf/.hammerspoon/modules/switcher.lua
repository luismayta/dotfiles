local hotkey = require('core.hotkey')
local switcher = hs.window.switcher.new()

hotkey.bindWithAlt(
   'tab', '[窗口管理]切换活动窗口', function()
      switcher:next()
end)
