-- App launcher keybindings
-- Three-tier modifier convention:
--   Direct    = SUPER           (migrated from legacy config)
--   Hyper     = SUPER + ALT + CTRL  (development tools)
--   Secondary = SUPER + ALT         (system applications)

local M = {}

function M.register(mainMod)
  local hyper = mainMod .. " + ALT + CTRL"
  local secondary = mainMod .. " + ALT"

  -- Direct apps (SUPER + key, migrated from legacy config)
  local direct_binds = {
    -- Terminal
    { key = "RETURN", exec = "ghostty" },
    { key = "SHIFT + RETURN", exec = "ghostty --class ghostty-float" },
    -- Browser
    { key = "B", exec = "zen-browser" },
    -- File manager
    { key = "E", exec = "dolphin" },
    -- Screenshots
    { key = "P", exec = "dms screenshot" },
    { key = "SHIFT + P", exec = "dms screenshot window" },
    { key = "CTRL + P", exec = "dms screenshot full" },
    -- Clipboard
    { key = "V", exec = "dms ipc call clipboard toggle" },
  }

  -- Hyper tier: development tools (SUPER + ALT + CTRL + key)
  -- Mnemonic groupings:
  --   Editors:  [ = Android Studio, ] = IntelliJ, ; = Zed
  --   Data:     S = DataGrip, I = Insomnia, D = draw.io
  --   Comm:     J = Jira, O = Obsidian, Z = Zoom, K = Keybase
  --   Security: B = Bitwarden
  --   Terminal: T = Ghostty
  local hyper_binds = {
    { key = "[", exec = "android-studio" },
    { key = "]", exec = "idea" },
    { key = ";", exec = "zed" },
    { key = "B", exec = "bitwarden-desktop" },
    { key = "D", exec = "draw.io" },
    { key = "T", exec = "ghostty" },
    { key = "I", exec = "insomnia" },
    { key = "S", exec = "datagrip" },
    { key = "K", exec = "keybase" },
    { key = "J", exec = "jira" },
    { key = "O", exec = "obsidian" },
    { key = "Z", exec = "zoom" },
  }

  -- Secondary tier: system applications (SUPER + ALT + key)
  -- Mnemonic: A = Zen, C = Comet, D = Discord, F = Figma,
  --           H = WhatsApp, T = Telegram, M = Music, O = Dolphin
  local secondary_binds = {
    { key = "A", exec = "zen-browser" },
    { key = "C", exec = "comet" },
    { key = "D", exec = "discord" },
    { key = "F", exec = "figma" },
    { key = "H", exec = "whatsapp" },
    { key = "T", exec = "telegram-desktop" },
    { key = "M", exec = "spotify" },
    { key = "O", exec = "dolphin" },
  }

  -- Register all tiers
  for _, bind in ipairs(direct_binds) do
    hl.bind(mainMod .. " + " .. bind.key, hl.dsp.exec_cmd(bind.exec))
  end

  for _, bind in ipairs(hyper_binds) do
    hl.bind(hyper .. " + " .. bind.key, hl.dsp.exec_cmd(bind.exec))
  end

  for _, bind in ipairs(secondary_binds) do
    hl.bind(secondary .. " + " .. bind.key, hl.dsp.exec_cmd(bind.exec))
  end
end

return M
