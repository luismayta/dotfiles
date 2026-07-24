-- [[ Bootstrap lazy.nvim ]]

vim.g.mapleader = ","
vim.g.maplocalleader = ","

require "config.options"
require "config.keymaps"
require "config.lazy"

-- Defer LSP config until a file is opened (nvim 0.12 native)
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("UserLSPConfigLoad", { clear = true }),
  once = true,
  callback = function()
    require "config.lsp"
  end,
})
