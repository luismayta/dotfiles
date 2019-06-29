local hotkey = require('core.hotkey')
local switcher = hs.window.switcher.new()

hotkey.bindWithAlt(
   'tab', 'Loading switcher',
   function()
      switcher:next()
   end
)
