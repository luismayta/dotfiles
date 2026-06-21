local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local M = {}

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()
  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      return vim.iter({args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }}):flatten():totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Multi Grep",
    layout_config = {
        width = 0.95,
        height = 0.95,
    },
    previewer = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty(),
    finder = finder,
  }):find()
end

M.multigrep = function()
  live_multigrep()
end

return M
