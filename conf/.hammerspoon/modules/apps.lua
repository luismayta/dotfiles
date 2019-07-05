require("core.extensions")
local hotkey = require('core.hotkey')
hotkey.bindWithCtrlAlt("e", "Load Emacs", launchOrCycleFocus("Emacs"))
hotkey.bindWithCtrlAlt("c", "Load Calendar", launchOrCycleFocus("Calendar"))
hotkey.bindWithCtrlAlt("t", "Load Alacritty", launchOrCycleFocus("Alacritty"))
hotkey.bindWithCtrlAlt("m", "Load Spotify", launchOrCycleFocus("Spotify"))
hotkey.bindWithCtrlAlt("x", "Load Xcode", launchOrCycleFocus("XCode"))
hotkey.bindWithCtrlAlt("a", "Load Android Studio", launchOrCycleFocus("Android Studio"))
hotkey.bindWithCtrlAlt("i", "Load Insomnia", launchOrCycleFocus("Insomnia"))
hotkey.bindWithCtrlAlt("o", "Load Finder", launchOrCycleFocus("Finder"))
hotkey.bindWithCtrlAlt("b", "Load Brave Browser", launchOrCycleFocus("Brave Browser"))
hotkey.bindWithCtrlAlt("r", "Load Reminders", launchOrCycleFocus("Reminders"))
hotkey.bindWithCtrlAlt("s", "Load Slack", launchOrCycleFocus("Slack"))
hotkey.bindWithCtrlAlt("`", "Load Open", function() os.execute( "open ~" ) end )
