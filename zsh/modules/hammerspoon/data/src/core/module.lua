local M = {}

function M.define(name, spec)
  spec.name = name
  spec.enabled = spec.enabled ~= false

  return {
    name = spec.name,
    enabled = spec.enabled,
    init = spec.init,
    start = spec.start,
    stop = spec.stop,
  }
end

return M