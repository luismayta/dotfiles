-- luacheck: globals hs spoon
local hotkey = require('core.hotkey')
hs.loadSpoon("SpoonInstall")
local Install=spoon.SpoonInstall
-- vimmode everywhere
Install:andUse("VimMode", {
    repo = "vimmode"
})

local vim = hs.loadSpoon('VimMode')
vim
   -- :shouldDimScreenInNormalMode(false)
   :enterWithSequence('jk')
   :bindHotKeys({ enter = {hotkey.cmdHyper, ';'} })

-- If you want the screen to dim (a la Flux) when you enter normal mode
-- flip this to true.
-- vim:shouldDimScreenInNormalMode(false)