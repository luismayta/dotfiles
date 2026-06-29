local hsLogger = require("hs.logger")
local inspect = require("hs.inspect")

local M = {}

local level = "info"

function M.setLevel(lvl)
  level = lvl
end

function M.get(name)
  local log = hsLogger.new(name)
  log.setLogLevel(level)

  local wrapper = {}

  -- info
  function wrapper.info(fmt, ...)
    local msg = fmt
    if select("#", ...) > 0 then
      msg = string.format(fmt, ...)
    end
    log.i(msg)
  end

  -- warn
  function wrapper.warn(fmt, ...)
    local msg = fmt
    if select("#", ...) > 0 then
      msg = string.format(fmt, ...)
    end
    log.w(msg)
  end

  -- error
  function wrapper.error(fmt, ...)
    local msg = fmt
    if select("#", ...) > 0 then
      msg = string.format(fmt, ...)
    end
    log.e(msg)
  end

  -- debug
  function wrapper.debug(fmt, ...)
    local msg = fmt
    if select("#", ...) > 0 then
      msg = string.format(fmt, ...)
    end
    log.d(msg)
  end

  -- inspect
  function wrapper.inspect(value)
    return inspect(value)
  end

  return wrapper
end

return M
