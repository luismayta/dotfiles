-- luacheck: globals hs spoon
local hotkey = require('core.hotkey')
hotkey.bindWithCtrlAlt(
  '0', 'Reloaded',
  function()
    hs.reload()
    hs.notify.new({title='Hammerspoon Reloaded'}):send()
  end
)