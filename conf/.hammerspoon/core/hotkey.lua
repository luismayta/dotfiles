local strkit = require('core.strkit')

hotkey = {
   registeredHotkey = {},
   hyper = {"ctrl", "alt"},
   cmdHyper = {"cmd", "ctrl", "alt"},
   shift_hyper = {"shift", "cmd"},
}


function hotkey.bind(mods, key, desc, fn)
   hs.hotkey.bind(mods, key, nil, fn)

   local info = ''
   for _, k in pairs(mods) do
      info = info .. (info ~= '' and '+' or '') .. strkit.firstUp(k)
   end
   info = (info .. '+' .. strkit.firstUp(key))

   table.insert(hotkey.registeredHotkey, {
                   key = info,
                   desc = desc
   })
   hs.printf('[Info] %s -> %s', info, desc)
end

function hotkey.bindWithCtrl(key, desc, fn)
   hotkey.bind({'CTRL'}, key, desc, fn)
end

function hotkey.bindWithCmd(key, desc, fn)
   hotkey.bind({'CMD'}, key, desc, fn)
end

function hotkey.bindWithShift(key, desc, fn)
   hotkey.bind({'Shift'}, key, desc, fn)
end

function hotkey.bindWithAlt(key, desc, fn)
   hotkey.bind({'Alt'}, key, desc, fn)
end

function hotkey.bindWithCmdAlt(key, desc, fn)
   hotkey.bind({'CMD', 'ALT' }, key, desc, fn)
end

function hotkey.bindWithCtrlCmd(key, desc, fn)
   hotkey.bind({'CTRL', 'CMD' }, key, desc, fn)
end

function hotkey.bindWithCtrlCmdAlt(key, desc, fn)
   hotkey.bind({'CTRL', 'CMD', 'ALT' }, key, desc, fn)
end

function hotkey.bindWithCtrlAlt(key, desc, fn)
   hotkey.bind(hotkey.hyper, key, desc, fn)
end

function hotkey.bindWithCtrlShift(key, desc, fn)
   hotkey.bind({'CTRL', 'SHIFT' }, key, desc, fn)
end

function hotkey.bindWithCtrlShiftCmd(key, desc, fn)
   hotkey.bind({'CTRL', 'SHIFT', 'CMD' }, key, desc, fn)
end

function hotkey.bindWithCtrlShiftAlt(key, desc, fn)
   hotkey.bind({ 'CTRL', 'SHIFT', 'ALT' }, key, desc, fn)
end

function hotkey.bindWithShiftAlt(key, desc, fn)
   hotkey.bind({ 'SHIFT', 'ALT' }, key, desc, fn)
end

function hotkey.bindWithShiftCmd(key, desc, fn)
   hotkey.bind({ 'SHIFT', 'CMD' }, key, desc, fn)
end

function hotkey.bindWithShiftCmdAlt(key, desc, fn)
   hotkey.bind({ 'SHIFT', 'CMD', 'ALT' }, key, desc, fn)
end

hotkey.bindWithCtrlCmdAlt(
   'K', 'Show HotKeys',
   function()
      allHotKey = ""
      for _, v in pairs(hotkey.registeredHotkey) do
         allHotKey = allHotKey .. '▶︎ (' .. v.key .. ') ☞' .. v.desc .. '\n'
      end
      hs.dialog.blockAlert("Show Keys", allHotKey, "Close")
   end
)

return hotkey
