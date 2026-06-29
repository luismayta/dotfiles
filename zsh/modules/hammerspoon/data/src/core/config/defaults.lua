local M = {}

M.values = {
  browsers = {
    brave = "com.brave.Browser",
    chrome = "com.google.Chrome",
    safari = "com.apple.Safari",
    firefox = "org.mozilla.firefox",
    firefoxDev = "org.mozilla.firefoxdeveloperedition",
    canary = "com.google.Chrome.canary",
  },
  display = {
    laptop = "Color LCD",
    external = "ASUS PB238",
  },
  dns = {
    empty = "networksetup -setdnsservers Wi-Fi empty",
    cloudflare = "networksetup -setdnsservers Wi-Fi 127.0.0.1 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4",
  },
}

return M
