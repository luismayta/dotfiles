local M = {}

--- Wrapper around vim.keymap.set with silent default and desc support.
---@param mode string|table  Mode or list of modes
---@param lhs string         Left-hand side mapping
---@param rhs string|function Right-hand side action
---@param desc string        Description for the mapping
---@param extra_opts table|nil Additional options (merged over defaults)
---@return table|nil Result of vim.keymap.set
function M.map(mode, lhs, rhs, desc, extra_opts)
  local opts = { silent = true }
  if desc then
    opts.desc = desc
  end
  if extra_opts then
    for k, v in pairs(extra_opts) do
      opts[k] = v
    end
  end
  return vim.keymap.set(mode, lhs, rhs, opts)
end

--- Normal-mode mapping shorthand.
function M.nnoremap(lhs, rhs, desc, opts)
  return M.map("n", lhs, rhs, desc, opts)
end

--- Insert-mode mapping shorthand.
function M.inoremap(lhs, rhs, desc, opts)
  return M.map("i", lhs, rhs, desc, opts)
end

--- Visual-mode mapping shorthand.
function M.vnoremap(lhs, rhs, desc, opts)
  return M.map("v", lhs, rhs, desc, opts)
end

--- Visual + select-mode mapping shorthand.
function M.xnoremap(lhs, rhs, desc, opts)
  return M.map("x", lhs, rhs, desc, opts)
end

--- Combine two lists without duplicates.
---@param list1 any[]
---@param list2 any[]
---@return any[]
function M.combine_lists(list1, list2)
  local seen = {}
  local result = {}

  for _, item in ipairs(list1) do
    if not seen[item] then
      seen[item] = true
      table.insert(result, item)
    end
  end

  for _, item in ipairs(list2) do
    if not seen[item] then
      seen[item] = true
      table.insert(result, item)
    end
  end

  return result
end

--- Creates a debounced version of `fn` that only executes after
--- `ms` milliseconds of inactivity.
---@param fn function
---@param ms number
---@return function
function M.debounce(fn, ms)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer then
      timer:close()
    end
    timer = vim.defer_fn(function()
      timer = nil
      fn(unpack(args))
    end, ms)
  end
end

--- Returns the word count of the current buffer.
---@return integer
function M.word_count()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local count = 0
  for _, line in ipairs(lines) do
    for _ in string.gmatch(line, "%S+") do
      count = count + 1
    end
  end
  return count
end

return M
