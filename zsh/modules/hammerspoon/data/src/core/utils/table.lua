local M = {}

-- Deep merge override over base (mutates base)
local function deepMerge(base, override)
  for k, v in pairs(override or {}) do
    if type(v) == "table" and type(base[k]) == "table" then
      deepMerge(base[k], v)
    else
      base[k] = v
    end
  end
  return base
end

-- Immutable-style merge
function M.merge(base, override)
  local result = {}

  -- copy base
  for k, v in pairs(base or {}) do
    if type(v) == "table" then
      result[k] = deepMerge({}, v)
    else
      result[k] = v
    end
  end

  return deepMerge(result, override or {})
end

return M
