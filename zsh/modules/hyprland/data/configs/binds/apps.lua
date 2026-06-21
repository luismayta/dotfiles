-- Three-tier modifier convention:
--   Direct    = SUPER           (migrated from legacy config)
--   Hyper     = SUPER + ALT + CTRL  (development tools)
--   Secondary = CTRL + ALT         (system applications)

local dsp = require("custom.dispatcher")

local M = {}

function M.register(mainMod, C)
  -- Direct apps (SUPER + key, migrated from legacy config)
  local direct_binds = {
    { key = "E",         exec = dsp.launch_or_focus("dolphin") },
    -- Screenshots
    { key = "P",         exec = "dms screenshot" },
    { key = "SHIFT + P", exec = "dms screenshot window" },
    { key = "CTRL + P",  exec = "dms screenshot area" },
  }

  -- Hyper tier: development tools (SUPER + ALT + CTRL + key)
  local hyper_binds = {
    { key = "bracketleft",  exec = dsp.launch_or_focus("android-studio") },
    { key = "bracketright", exec = dsp.launch_or_focus("idea") },
    { key = "semicolon",    exec = dsp.launch_or_focus("dev.zed.Zed", "Zed") },
    { key = "B",            exec = dsp.launch_or_focus("Bitwarden") },
    { key = "D",            exec = dsp.launch_or_focus("draw.io") },
    { key = "T",            exec = dsp.launch_or_focus("com.mitchellh.ghostty", "ghostty") },
    { key = "I",            exec = dsp.launch_or_focus("insomnia") },
    { key = "S",            exec = dsp.launch_or_focus("datagrip") },
    { key = "K",            exec = dsp.launch_or_focus("keybase") },
    { key = "J",            exec = dsp.launch_or_focus("brave-codip.atlassian.net__-Default", "jira") },
    { key = "O",            exec = dsp.launch_or_focus("obsidian") },
  }

  -- Secondary tier: system applications (CTRL + ALT + key)
  local secondary_binds = {
    { key = "A", exec = dsp.launch_or_focus("brave-chat.openai.com__-Default", "chatgpt") },
    { key = "B", exec = dsp.launch_or_focus("brave-browser", "brave") },
    { key = "C", exec = dsp.launch_or_focus("zen", "zen-browser") },
    { key = "D", exec = dsp.launch_or_focus("discord") },
    { key = "F", exec = dsp.launch_or_focus("figma") },
    { key = "H", exec = dsp.launch_or_focus("brave-web.whatsapp.com__-Default", "WhatsApp") },
    { key = "T", exec = dsp.launch_or_focus("brave-tasks.google.com__-Default", "Google Tasks") },
    { key = "M", exec = dsp.launch_or_focus("spotify") },
    { key = "O", exec = dsp.launch_or_focus("dolphin") },
  }

  local function register_binds(tier_prefix, binds)
    for _, bind in ipairs(binds) do
      hl.bind(tier_prefix .. " + " .. bind.key, type(bind.exec) == "string" and hl.dsp.exec_cmd(bind.exec) or bind.exec)
    end
  end

  -- Register all tiers
  register_binds(C.DIRECT, direct_binds)
  register_binds(C.HYPER, hyper_binds)
  register_binds(C.SECONDARY, secondary_binds)
end

return M
