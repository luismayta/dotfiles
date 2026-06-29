local M = {}

local function safeRequire(path)
  local ok, result = pcall(require, path)
  if ok then
    return result
  end
  return {}
end

function M.load()
  return {
    global = safeRequire("config.global"),
    localConfig = safeRequire("local"),
    custom = safeRequire("custom"),
  }
end

return M
