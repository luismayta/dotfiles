-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Display
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = false
opt.wrap = false
opt.linebreak = true
opt.textwidth = 80
opt.wrapmargin = 0

-- Search
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- UI
opt.scrolloff = 8
opt.timeoutlen = 300
opt.updatetime = 50
opt.mouse = "a"
opt.mousemoveevent = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Backup / Swap / Undo
opt.swapfile = false
opt.backup = false
vim.fn.system { "mkdir", "-p", vim.fn.stdpath "data" .. "/undo" }
opt.undodir = vim.fn.stdpath "data" .. "/undo"
opt.undofile = true

-- Folding
opt.foldmethod = "manual"
opt.foldlevel = 99
opt.foldcolumn = "0"

-- Misc
opt.emoji = false
opt.backspace = "indent,eol,start"
vim.opt.guicursor = ""
opt.clipboard = "unnamedplus"

-- Keywords and paths
opt.iskeyword:append { "_", "@", ".", "-" }
opt.path:append { "**", "lua", "src" }

-- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Enable native UI (cmdline + messages) — nvim 0.12
vim.o.cmdheight = 0
require("vim._core.ui2").enable {
  msg = {
    targets = "cmd",
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    pager = { height = 0.999 },
  },
}
