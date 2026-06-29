local M = {}

local function safeCall(mod, method, ctx, log)
  if not mod[method] then
    return
  end

  local ok, err = pcall(mod[method], ctx)

  if not ok then
    log:e(string.format("Module '%s' failed during %s: %s", mod.name, method, err))
  end
end

function M.start(ctx, registry)
  local log = ctx.logger.get("Bootstrap")

  log:i("Starting system...")

  for _, mod in ipairs(registry) do
    if mod.enabled ~= false then
      log:i("Loading module: " .. mod.name)

      safeCall(mod, "init", ctx, log)
      safeCall(mod, "start", ctx, log)
    else
      log:d("Skipping module: " .. mod.name)
    end
  end

  log:i("System ready.")
end

return M
