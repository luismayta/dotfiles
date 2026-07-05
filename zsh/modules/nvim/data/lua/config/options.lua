-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

-- General
opt.backup = false
opt.swapfile = false
opt.clipboard = "unnamedplus"
opt.emoji = false
opt.mousemoveevent = true
opt.updatetime = 100
opt.scrolloff = 10
opt.backspace = "indent,eol,start"

-- Fold settings (treesitter-based)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldcolumn = "0"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Line wrapping
opt.wrap = true
opt.linebreak = true
opt.textwidth = 0
opt.wrapmargin = 0

-- Keywords and paths
opt.iskeyword:append { "_", "@", ".", "-" }
opt.path:append { "**", "lua", "src" }
