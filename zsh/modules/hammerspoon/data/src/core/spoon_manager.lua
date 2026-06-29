local M = {}

function M.new(spoonInstall)
  local instance = {
    spoonInstall = spoonInstall,
    loaded = {},
  }

  function instance:use(name, settings)
    if self.loaded[name] then
      return spoon[name]
    end

    if settings then
      self.spoonInstall:andUse(name, settings)
    else
      self.spoonInstall:andUse(name)
    end

    self.loaded[name] = true
    return spoon[name]
  end

  return instance
end

return M
