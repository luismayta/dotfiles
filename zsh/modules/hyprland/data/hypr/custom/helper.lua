---@alias HL.Custom.DispatcherLike HL.Custom.Dispatcher|HL.Dispatcher

---@class HL.Custom.LayoutDispatcherSpec
---@field layout string
---@field dispatcher HL.Custom.DispatcherLike

---@param dispatcher HL.Custom.DispatcherLike|nil
local function run_dispatcher(dispatcher)
  if dispatcher == nil then
    return
  end

  if type(dispatcher) == "function" then
    dispatcher()
  else
    ---@cast dispatcher HL.Dispatcher
    hl.dispatch(dispatcher)
  end
end

---@param specs HL.Custom.LayoutDispatcherSpec[]|nil
---@return HL.Custom.Dispatcher
local function by_layout(specs)
  return function()
    if specs == nil or #specs == 0 then
      return
    end

    local w = hl.get_active_workspace()

    if w ~= nil then
      for _, spec in ipairs(specs) do
        if spec.layout == w.tiled_layout then
          run_dispatcher(spec.dispatcher)

          return
        end
      end
    end

    run_dispatcher(specs[1].dispatcher)
  end
end

---@class HL.Custom.HelperNamespace
---@field by_layout fun(specs?: HL.Custom.LayoutDispatcherSpec[]): HL.Custom.Dispatcher
---@type HL.Custom.HelperNamespace
local M = {
  by_layout = by_layout,
}

return M
