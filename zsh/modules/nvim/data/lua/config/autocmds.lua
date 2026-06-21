local aucmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_user_command("OverseerRestartLast", function()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify("No tasks found", vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], "restart")
  end
end, {})

-- Set relative line numbers in normal mode
aucmd({ "InsertEnter" }, {
  callback = function()
    local fname = vim.fn.bufname()
    if fname == "copilot-chat" or vim.bo.buftype == "nofile" then
      return
    end
    vim.opt_local.relativenumber = false
  end,
})

-- and absolute line numbers in insert mode
aucmd({ "InsertLeave" }, {
  callback = function()
    local fname = vim.fn.bufname()
    if fname == "copilot-chat" or vim.bo.buftype == "nofile" then
      return
    end
    vim.opt_local.relativenumber = true
  end,
})

-- Terminal
aucmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})

-- Codelens
aucmd({ "BufEnter", "InsertLeave" }, {
  pattern = { "*.rs", "*.go" },
  callback = function()
    vim.lsp.codelens.refresh({ bufnr = 0 })
  end,
})

aucmd({ "BufEnter" }, {
  pattern = { "*.csv" },
  callback = function()
    vim.cmd("set noarabicshape")
  end,
})

aucmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    require("config.utils").set_terminal_keymaps()
  end,
})

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

aucmd("filetype", {
  pattern = "neotest-output",
  callback = function()
    -- Open file under cursor in the widest window available.
    -- https://github.com/nvim-neotest/neotest/issues/387#issuecomment-2409133005
    vim.keymap.set("n", "gF", function()
      local current_word = vim.fn.expand("<cWORD>")
      local tokens = vim.split(current_word, ":", { trimempty = true })
      local win_ids = vim.api.nvim_list_wins()
      local widest_win_id = -1
      local widest_win_width = -1
      for _, win_id in ipairs(win_ids) do
        if vim.api.nvim_win_get_config(win_id).zindex then
          -- Skip floating windows.
          goto continue
        end
        local win_width = vim.api.nvim_win_get_width(win_id)
        if win_width > widest_win_width then
          widest_win_width = win_width
          widest_win_id = win_id
        end
        ::continue::
      end
      vim.api.nvim_set_current_win(widest_win_id)
      if #tokens == 1 then
        vim.cmd("e " .. tokens[1])
      else
        vim.cmd("e +" .. tokens[2] .. " " .. tokens[1])
      end
    end, { remap = true, buffer = true })
  end,
})

-- aucmd("WinEnter", {
--   callback = function()
--     vim.opt_local.number = true
--     vim.opt_local.relativenumber = true
--     vim.opt_local.cursorline = true
--   end,
-- })
-- aucmd("WinLeave", {
--   callback = function()
--     vim.opt_local.number = false
--     vim.opt_local.relativenumber = false
--     vim.opt_local.cursorline = false
--   end,
-- })

-- -- blink.cmp hide copilot suggestion
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpMenuOpen',
--   callback = function()
--     require("copilot.suggestion").dismiss()
--     vim.b.copilot_suggestion_hidden = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpMenuClose',
--   callback = function()
--     vim.b.copilot_suggestion_hidden = false
--   end,
-- })
