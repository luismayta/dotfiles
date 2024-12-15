-- app environment keybindings. Bundle `id` is preferred, but application `name` will be ok using cmd + ctrl + alt.
local config = {}
config.devs = {
	{ key = "b", name = "Bitwarden" },
	{ key = "d", name = "draw.io" },
	{ key = "[", name = "Android Studio" },
	{ key = "]", name = "IntelliJ IDEA CE" },
	{ key = ";", name = "Zed" },
	{ key = "t", name = "Alacritty" },
	{ key = "x", name = "XCode" },
	{ key = "i", name = "Insomnia" },
	{ key = "k", name = "Keybase" },
	{ key = "j", name = "Jira" },
	{ key = "m", name = "Miro" },
	{ key = "o", name = "Obsidian" },
	{ key = "z", name = "Zoom.us" },
}

-- app environment keybindings. Bundle `id` is preferred, but application `name` will be ok using ctrl + alt.
config.apps = {
	{ key = ",", name = "System Preferences" },
	{ key = "3", name = "Launchpad" },
	{ key = "d", name = "Discord" },
	{ key = "f", name = "Figma" },
	{ key = "e", name = "Spark" },
	{ key = "a", name = "Airtable" },
	{ key = "b", name = "Brave Browser" },
	{ key = "c", name = "Calendar" },
	{ key = "h", name = "WhatsApp" },
	{ key = "t", name = "Telegram" },
	{ key = "m", name = "Spotify" },
	{ key = "r", name = "Reminders" },
	{ key = "s", name = "Stocks" },
	{ key = "o", name = "Finder" },
}

-- misc environment keybindings. Bundle `id` is preferred, but application `name` will be ok using shift + cmd.
config.misc = {
	{ key = "b", name = "Binance" },
}

return config
