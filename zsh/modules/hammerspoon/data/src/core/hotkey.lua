-- luacheck: globals hs
local stringUtil = require("core.utils.string")
local logger = require("core.logger").get("hotkey")

local Hotkey = {}
Hotkey.__index = Hotkey

-- =========================
-- Presets de modificadores
-- =========================
local presets = {
  ctrl = { "ctrl" },
  cmd = { "cmd" },
  shift = { "shift" },
  alt = { "alt" },

  hyper = { "ctrl", "alt" },
  cmdHyper = { "cmd", "ctrl", "alt" },
  shiftHyper = { "shift", "cmd" },
}

-- =========================
-- Constructor
-- =========================
function Hotkey.new(deps)
  local self = setmetatable({}, Hotkey)

  self.registered = {}
  self.functions = deps and deps.functions or {}

  logger.info("[Hotkey] Initialized")

  return self
end

-- =========================
-- Private helpers
-- =========================
function Hotkey:_format(mods, key)
  local parts = {}

  for _, k in ipairs(mods or {}) do
    table.insert(parts, stringUtil.firstUp(k))
  end

  table.insert(parts, stringUtil.firstUp(key))

  return table.concat(parts, "+")
end

-- =========================
-- Core bind
-- =========================
function Hotkey:bind(mods, key, desc, fn)
  logger.info("========== HOTKEY BIND DEBUG ==========")

  logger.info("mods value: %s", logger.inspect(mods))
  logger.info("mods type: %s", type(mods))

  if type(mods) == "table" then
    for i, v in ipairs(mods) do
      logger.info("mods[%d] = %s (%s)", i, tostring(v), type(v))
    end
  end

  logger.info("key value: %s", tostring(key))
  logger.info("key type: %s", type(key))

  logger.info("desc value: %s", tostring(desc))
  logger.info("fn type: %s", type(fn))

  if type(mods) ~= "table" then
    logger.error("mods is not a table")
    return
  end

  if type(key) ~= "string" and type(key) ~= "number" then
    logger.error("Invalid key type")
    return
  end

  if type(fn) ~= "function" then
    logger.error("fn is not a function")
    return
  end

  -- Validación extra: modifiers valids
  local validMods = {
    ctrl = true,
    cmd = true,
    alt = true,
    shift = true,
    fn = true,
  }

  for _, m in ipairs(mods) do
    if not validMods[m] then
      logger.error("Invalid modifier detected: %s", tostring(m))
    end
  end

  logger.info("Calling hs.hotkey.bind...")

  local ok, err = pcall(function()
    hs.hotkey.bind(mods, key, nil, fn)
  end)

  if not ok then
    logger.error("hs.hotkey.bind crashed: %s", tostring(err))
    logger.error(debug.traceback())
    return
  end

  logger.info("hs.hotkey.bind succeeded")

  local info = self:_format(mods, key)

  table.insert(self.registered, {
    key = info,
    desc = desc or "",
  })

  logger.info("Registered: %s -> %s", info, desc or "")
  logger.info("========================================")
end

-- =========================
-- Preset binding
-- =========================
function Hotkey:bindPreset(preset, key, desc, fn)
  local mods = presets[preset]

  if not mods then
    logger.error("[Hotkey] Preset '%s' not found", tostring(preset))
    return
  end

  self:bind(mods, key, desc, fn)
end

-- =========================
-- Convenience helpers
-- =========================
function Hotkey:bindWithCtrl(key, desc, fn)
  self:bindPreset("ctrl", key, desc, fn)
end

function Hotkey:bindWithCmd(key, desc, fn)
  self:bindPreset("cmd", key, desc, fn)
end

function Hotkey:bindWithShift(key, desc, fn)
  self:bindPreset("shift", key, desc, fn)
end

function Hotkey:bindWithAlt(key, desc, fn)
  self:bindPreset("alt", key, desc, fn)
end

function Hotkey:bindWithCtrlAlt(key, desc, fn)
  self:bindPreset("hyper", key, desc, fn)
end

function Hotkey:bindWithCtrlCmdAlt(key, desc, fn)
  self:bindPreset("cmdHyper", key, desc, fn)
end

function Hotkey:bindWithShiftCmd(key, desc, fn)
  self:bindPreset("shiftHyper", key, desc, fn)
end

-- =========================
-- Utilities
-- =========================
function Hotkey:showRegistered()
  if #self.registered == 0 then
    logger.warn("[Hotkey] No registered hotkeys")
    return
  end

  local buffer = {}

  for _, v in ipairs(self.registered) do
    table.insert(buffer, "▶︎ (" .. v.key .. ") ☞ " .. v.desc)
  end

  hs.dialog.blockAlert("Show Keys", table.concat(buffer, "\n"), "Close")
end

-- =========================
-- Domain integrations
-- =========================
function Hotkey:setApps(apps)
  for _, value in ipairs(apps or {}) do
    if value.name and value.key then
      self:bindPreset("hyper", value.key, "Load " .. value.name, function()
        if type(self.functions.toggle) == "function" then
          self.functions.toggle(value.name)
        else
          logger.error("[Hotkey] toggleApplication missing")
        end
      end)
    else
      logger.warn("[Hotkey] Invalid app entry")
    end
  end
end

return Hotkey
