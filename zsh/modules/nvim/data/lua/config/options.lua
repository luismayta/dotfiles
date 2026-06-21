local opt = vim.opt
local global = vim.g
local cmd = vim.cmd

global.mapleader = ","
global.maplocalleader = ","
global.markdown_folding = 1

-- Fix markdown indentation settings
global.markdown_recommended_style = 0

-- Enable auto format
global.autoformat = true

local function link(group, other)
  cmd("highlight! link " .. group .. " " .. other)
end

-- add highlighting to weird files
vim.filetype.add({
  extension = {
    fnl = "fennel",
    wiki = "markdown",
  },
  filename = {
    [".env"] = "config",
    [".envrc"] = "sh",
    [".envrc.local"] = "sh",
    [".zshrc"] = "sh",
    ["go.mod"] = "gomod",
    ["go.sum"] = "gosum",
    ["requirements-dev.txt"] = "config",
    ["requirements-test.txt"] = "config",
    ["requirements.txt"] = "config",
  },
  pattern = {
    ["%.env.*"] = "config",
    ["*.tml"] = "gohtmltmpl",
    [".*/%.github/dependabot.yaml"] = "dependabot",
    [".*/%.github/dependabot.yml"] = "dependabot",
    [".*/%.github/workflows/[%w/]+.*%.yaml"] = "gha",
    [".*/%.github/workflows[%w/]+.*%.yml"] = "gha",
    ["gitconf.*"] = "gitconfig",
  },
})
vim.treesitter.language.register("yaml", "gha")
vim.treesitter.language.register("yaml", "dependabot")

-- don't show tab indicators
opt.listchars = { tab = "  " }
-- opt.listchars = "tab:▸ ,trail:·,nbsp:␣,extends:❯,precedes:❮" -- show symbols for whitespace

-- default options
opt.ttyfast = true
opt.termguicolors = true
opt.updatetime = 100
opt.timeoutlen = 250
opt.redrawtime = 1500
opt.ttimeoutlen = 10
opt.wrapscan = true -- Searches wrap around the end of the file
opt.secure = true -- Disable autocmd etc for project local vimrc files.
opt.exrc = false -- Allow project local vimrc files example .nvimrc see :h exrc
opt.confirm = true -- make vim prompt me to save before doing destructive things
opt.autowriteall = true -- automatically :write before running commands and changing files
global.editorconfig = true
global.lazyvim_blink_main = true
opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim"
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Case sensitive when uppercase
opt.undofile = true -- Enable undo file
opt.swapfile = false -- Disable swap file
opt.showmode = false
opt.iskeyword:append("-") -- Treat words separated by - as one word
opt.clipboard:append("unnamedplus") -- Enable copying to system clipboard
opt.fillchars = {
  fold = " ",
  eob = " ", -- suppress ~ at EndOfBuffer
  diff = "░", -- ╱ ⣿ ░ ─
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
  horiz = " ",
  horizup = " ",
  horizdown = " ",
  vert = " ",
  vertleft = " ",
  vertright = " ",
  verthoriz = " ",
}
opt.wildignore = {
  "*.aux,*.out,*.toc",
  "*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
  -- media
  "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
  "*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
  "*.eot,*.otf,*.ttf,*.woff",
  "*.doc,*.pdf",
  -- archives
  "*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
  -- temp/system
  "*.*~,*~ ",
  "*.swp,.lock,.DS_Store,._*,tags.lock",
  -- version control
  ".git,.svn",
  --rust
  "Cargo.lock,Cargo.Bazel.lock",
}

-- make windows opaque
opt.pumblend = 0 -- for cmp menu
opt.winblend = 0 -- for documentation popup

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

-- Lines
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.cursorline = true

-- Appearance
opt.scrolloff = 10
opt.sidescrolloff = 10

-- disable autoformat
global.autoformat = false

-- custom
if vim.env.USER == "abz" then
  global.lazyvim_python_lsp = "pylance"
else
  global.lazyvim_python_lsp = "basedpyright"
end
global.lazyvim_python_ruff = "ruff"

-- highlights
link("MarkviewHeading1", "rainbow1")
link("MarkviewHeading1Sign", "rainbow1")
link("MarkviewHeading2", "rainbow2")
link("MarkviewHeading2Sign", "rainbow2")
link("MarkviewHeading3", "rainbow3")
link("MarkviewHeading4", "rainbow4")
link("MarkviewHeading5", "rainbow5")
link("MarkviewHeading6", "rainbow6")

-- fold
opt.foldtext = "v:lua.require'config.utils'.foldtext()"

-- quickfix
opt.qftf = "{info -> v:lua.require'config.utils'.qftf(info)}"

--bufferline
global.toggle_theme_icon = "   "
cmd("function! TbToggle_theme(a,b,c,d) \n lua require('config.utils').toggle_theme() \n endfunction")
cmd("function! Quit_vim(a,b,c,d) \n qa \n endfunction")
