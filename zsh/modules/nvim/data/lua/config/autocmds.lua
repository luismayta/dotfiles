-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

-- JSON has no native comment syntax — set commentstring for gc/gcc
vim.api.nvim_create_autocmd("FileType", {
  desc = "Set commentstring for JSON",
  group = augroup,
  pattern = { "json", "jsonc" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})
