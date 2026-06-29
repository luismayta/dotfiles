local M = {}

function M.new(spoonInstall)
  local self = {
    spoonInstall = spoonInstall,
    loaded = {},
  }

  function self:use(name, settings)
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

  return self
end

return M
