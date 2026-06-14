---@type table<string, string>
local palette = {
  rosewater = "f5e0dc",
  flamingo = "f2cdcd",
  pink = "f5c2e7",
  mauve = "cba6f7",
  red = "f38ba8",
  maroon = "eba0ac",
  peach = "fab387",
  yellow = "f9e2af",
  green = "a6e3a1",
  teal = "94e2d5",
  sky = "89dceb",
  sapphire = "74c7ec",
  blue = "89b4fa",
  lavender = "b4befe",
  text = "cdd6f4",
  subtext1 = "bac2de",
  subtext0 = "a6adc8",
  overlay2 = "9399b2",
  overlay1 = "7f849c",
  overlay0 = "6c7086",
  surface2 = "585b70",
  surface1 = "45475a",
  surface0 = "313244",
  base = "1e1e2e",
  mantle = "181825",
  crust = "11111b",
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
