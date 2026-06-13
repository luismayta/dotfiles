-- Three-tier modifier convention:
--   Direct    = SUPER           (migrated from legacy config)
--   Hyper     = SUPER + ALT + CTRL  (development tools)
--   Secondary = CTRL + ALT         (system applications)

local dsp = require("custom.dispatcher")

local M = {}

function M.register(mainMod)
  local hyper = mainMod .. " + ALT + CTRL"
  local secondary = "CTRL + ALT"

  -- Direct apps (SUPER + key, migrated from legacy config)
  local direct_binds = {
    { key = "E", exec = dsp.launch_or_focus("dolphin") },
    -- Screenshots
    { key = "P", exec = "dms screenshot" },
    { key = "SHIFT + P", exec = "dms screenshot window" },
    { key = "CTRL + P", exec = "dms screenshot area" },
  }

  -- Hyper tier: development tools (SUPER + ALT + CTRL + key)
  local hyper_binds = {
    { key = "bracketleft", exec = dsp.launch_or_focus("android-studio") },
    { key = "bracketright", exec = dsp.launch_or_focus("idea") },
    { key = "semicolon", exec = dsp.launch_or_focus("dev.zed.Zed", "zed") },
    { key = "B", exec = dsp.launch_or_focus("Bitwarden", "bitwarden-desktop") },
    { key = "D", exec = dsp.launch_or_focus("draw.io") },
    { key = "T", exec = dsp.launch_or_focus("com.mitchellh.ghostty", "ghostty") },
    { key = "I", exec = dsp.launch_or_focus("insomnia") },
    { key = "S", exec = dsp.launch_or_focus("datagrip") },
    { key = "K", exec = dsp.launch_or_focus("keybase") },
    { key = "J", exec = dsp.launch_or_focus("jira") },
    { key = "O", exec = dsp.launch_or_focus("obsidian") },
  }

  -- Secondary tier: system applications (CTRL + ALT + key)
  local secondary_binds = {
    { key = "B", exec = dsp.launch_or_focus("zen", "zen-browser") },
    { key = "D", exec = dsp.launch_or_focus("discord") },
    { key = "F", exec = dsp.launch_or_focus("figma") },
    { key = "H", exec = dsp.launch_or_focus("whatsapp") },
    { key = "T", exec = dsp.launch_or_focus("telegram-desktop") },
    { key = "M", exec = dsp.launch_or_focus("spotify") },
    { key = "O", exec = dsp.launch_or_focus("dolphin") },
  }

  -- Register all tiers
  for _, bind in ipairs(direct_binds) do
    hl.bind(mainMod .. " + " .. bind.key, type(bind.exec) == "string" and hl.dsp.exec_cmd(bind.exec) or bind.exec)
  end

  for _, bind in ipairs(hyper_binds) do
    hl.bind(hyper .. " + " .. bind.key, type(bind.exec) == "string" and hl.dsp.exec_cmd(bind.exec) or bind.exec)
  end

  for _, bind in ipairs(secondary_binds) do
    hl.bind(secondary .. " + " .. bind.key, type(bind.exec) == "string" and hl.dsp.exec_cmd(bind.exec) or bind.exec)
  end
end

return M
