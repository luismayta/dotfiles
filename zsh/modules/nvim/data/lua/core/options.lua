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

-- Search
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- UI
opt.scrolloff = 8
opt.updatetime = 50
opt.mouse = "a"

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Backup / Swap / Undo
opt.swapfile = false
opt.backup = false
vim.fn.system({ "mkdir", "-p", vim.fn.stdpath("data") .. "/undo" })
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true

-- Folding
opt.foldmethod = "manual"
opt.foldlevel = 99
opt.foldcolumn = "0"

-- Misc
vim.opt.guicursor = ""
opt.clipboard = "unnamedplus"

-- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
