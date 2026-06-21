require "nvchad.options"

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local g = {
  dap_virtual_text = true,
  bookmark_sign = "",
  skip_ts_context_commentstring_module = true,
}

local tabSize = 2
local opt = {
  encoding = "utf-8",
  fileencoding = "utf-8",
  clipboard = "unnamedplus",
  -- Folds
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldcolumn = "0",
  foldtext = "",
  foldlevel = 99,
  foldlevelstart = 1,
  foldnestmax = 1,
  -- Prevent issues with some language servers
  backup = false,
  swapfile = false,
  -- Always show minimum n lines after current line
  scrolloff = 10,
  -- Making sure backspace works as intended
  backspace = "indent,eol,start",
  -- True color support
  termguicolors = true,
  emoji = false,
  relativenumber = true,
  -- Line break/wrap behaviours
  wrap = true,
  linebreak = true,
  textwidth = 0,
  wrapmargin = 0,
  -- Indentation values
  tabstop = tabSize,
  shiftwidth = tabSize,
  expandtab = true,
  autoindent = true,
  cursorline = true,
  cursorlineopt = "both",
  inccommand = "split",
  ignorecase = true,
  updatetime = 100,
  lazyredraw = false,
  iskeyword = vim.opt.iskeyword:append { "_", "@", ".", "-" },
  path = vim.opt.path:append { "**", "lua", "src" },
}

for k, v in pairs(g) do
  vim.g[k] = v
end

vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.clipboard = "unnamedplus"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldcolumn = "0"
vim.o.foldtext = ""
vim.o.foldlevel = 99
vim.o.foldlevelstart = 1
vim.o.foldnestmax = 1
vim.o.backup = false
vim.o.swapfile = false
vim.o.scrolloff = 10
vim.o.backspace = "indent,eol,start"
vim.o.termguicolors = true
vim.o.emoji = false
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.tabstop = tabSize
vim.o.shiftwidth = tabSize
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.cursorline = true
vim.o.cursorlineopt = "both"
vim.o.inccommand = "split"
vim.o.ignorecase = true
vim.o.updatetime = 100
vim.o.lazyredraw = false
