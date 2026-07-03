---@type table<string, string>
local palette = {
  rosewater = "f4dbd6",
  flamingo = "f0c6c6",
  pink = "f5bde6",
  mauve = "c6a0f6",
  red = "ed8796",
  maroon = "ee99a0",
  peach = "f5a97f",
  yellow = "eed49f",
  green = "a6da95",
  teal = "8bd5ca",
  sky = "91d7e3",
  sapphire = "7dc4e4",
  blue = "8aadf4",
  lavender = "b7bdf8",
  text = "cad3f5",
  subtext1 = "b8c0e0",
  subtext0 = "a5adcb",
  overlay2 = "939ab7",
  overlay1 = "7f849c",
  overlay0 = "6c7086",
  surface2 = "5b6078",
  surface1 = "494d64",
  surface0 = "363a4f",
  base = "24273a",
  mantle = "1e2030",
  crust = "181926",
}

---@alias HyprRgbaFn fun(alpha: string): string

---@class HyprColors
---@field rgba table<string, HyprRgbaFn>
---@field [string] string|table<string, HyprRgbaFn>

---@type table<string, HyprRgbaFn>
local rgba = {}

---@type HyprColors
local colors = {
  rgba = rgba,
}

local function normalize_alpha(alpha)
  assert(type(alpha) == "string", "alpha must be a 2-digit hex string")

  local normalized = alpha:lower()
  assert(normalized:match("^%x%x$") ~= nil, "alpha must be a 2-digit hex string")

  return normalized
end

for name, hex in pairs(palette) do
  colors[name] = ("rgb(%s)"):format(hex)

  rgba[name] = function(alpha)
    return ("rgba(%s%s)"):format(hex, normalize_alpha(alpha))
  end
end

return colors
