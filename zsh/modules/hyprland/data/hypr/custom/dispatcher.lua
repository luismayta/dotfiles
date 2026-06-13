---@alias HL.Custom.Dispatcher fun(): nil
---@alias HL.Custom.Layout "dwindle"|"scrolling"|"lua:tri-column"

---@param x_ratio number
---@param y_ratio number
---@return HL.Custom.Dispatcher
local function resize_window(x_ratio, y_ratio)
  return function()
    local m = hl.get_active_monitor()
    if m == nil then
      return
    end

    local x = (m.width / 100) * x_ratio
    local y = (m.height / 100) * y_ratio

    hl.dispatch(hl.dsp.window.resize({ x = x, y = y, relative = true }))
  end
end

---@type HL.Custom.Layout[]
local layouts = { "dwindle", "scrolling", "lua:tri-column" }

---@param step integer
---@return HL.Custom.Dispatcher
local function switch_layout(step)
  return function()
    local w = hl.get_active_workspace()
    if w == nil then
      return
    end

    local layout_count = #layouts
    if layout_count == 0 then
      return
    end

    ---@type integer?
    local current_index

    for i, layout in ipairs(layouts) do
      if w.tiled_layout == layout then
        current_index = i
        break
      end
    end

    local next_index = 1
    if current_index ~= nil then
      next_index = ((current_index - 1 + step) % layout_count) + 1
    end

    local next_layout = layouts[next_index]
    if next_layout == nil then
      return
    end

    hl.workspace_rule({ workspace = w.name, layout = next_layout })
  end
end

---@param class string Window class to find
---@param cmd string? Launch command (defaults to class)
---@return HL.Custom.Dispatcher
local function launch_or_focus(class, cmd)
  return function()
    -- 1. Try native focus by class (pure Lua API — no shell)
    hl.dispatch(hl.dsp.focus({ window = "class:^(" .. class .. ")$" }))

    -- 2. Check if focus landed on our target (dispatch is synchronous in keybind context)
    local active = hl.get_active_window()

    if active ~= nil and active.class == class then
      return -- focus succeeded, we're done
    end

    -- 3. Window not found — launch it
    local active_class = "nil"
    if active ~= nil then active_class = active.class end
    hl.dispatch(hl.dsp.exec_cmd("notify-send 'launch_or_focus' 'not found, active=" .. active_class .. ", launching " .. (cmd or class) .. "'"))

    hl.dispatch(hl.dsp.exec_cmd(cmd or class))
  end
end

---@return HL.Custom.Dispatcher
local function next_layout()
  return switch_layout(1)
end

---@return HL.Custom.Dispatcher
local function prev_layout()
  return switch_layout(-1)
end

---@class HL.Custom.DspNamespace
---@field resize_window fun(x_ratio: number, y_ratio: number): HL.Custom.Dispatcher
---@field next_layout fun(): HL.Custom.Dispatcher
---@field prev_layout fun(): HL.Custom.Dispatcher
---@type HL.Custom.DspNamespace
local M = {
  resize_window = resize_window,
  next_layout = next_layout,
  prev_layout = prev_layout,
  launch_or_focus = launch_or_focus,
}

return M
