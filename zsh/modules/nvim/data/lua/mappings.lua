local M = {}
--
--
-- M.dap = {
--   plugin = true,
--   n = {
--     ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
--     ["<leader>dus"] = {
--       function ()
--         local widgets = require('dap.ui.widgets');
--         local sidebar = widgets.sidebar(widgets.scopes);
--         sidebar.open();
--       end,
--       "Open debugging sidebar"
--     }
--   }
-- }
--
-- M.dap_python = {
--   plugin = true,
--   n = {
--     ["<leader>dpr"] = {
--       function()
--         require('dap-python').test_method()
--       end
--     }
--   }
-- }
--
-- M.dap_go = {
--   plugin = true,
--   n = {
--     ["<leader>dgr"] = {
--       function()
--         require('dap-go').debug_test()
--       end,
--       "Debug go test"
--     },
--     ["<leader>dgl"] = {
--       function()
--         require('dap-go').debug_last()
--       end,
--       "Debug last go test"
--     }
--   }
-- }

-- return M

---
require "nvchad.mappings"

local map = vim.keymap.set
local opts = { silent = true }

map("n", ";", ":", { desc = "Enter CMD mode" })
map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy file content" })
map("n", "<C-z>", "<NOP>", { desc = "Unmap force closing with <C-z>" })
map("n", "<leader><F4>", "<cmd>stop<CR>", { desc = "Stop NVIM" })
map("n", "z-", "z^", { desc = "Remap z^ into z- to match z+" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlights" })
map("n", "<leader>cs", "<cmd><CR>", { desc = "Clear statusline" })
map("n", "<leader>cm", "<cmd>mes clear<CR>", { desc = "Clear messages" })

-- https://github.com/neovim/neovim/issues/2048
map("i", "<A-BS>", "<C-w>", { desc = "Remove word" })
map("v", "y", "ygv<Esc>", { desc = "Yank preventing cursor from jumping back to where selection started" })
map("n", "<leader>ol", function()
  vim.ui.open(vim.fn.expand "%:p:h")
end, { desc = "Open file location in file explorer" })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })

-- Buffer motions
map("i", "<C-b>", "<ESC>^i", { desc = "Go to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })
map("i", "<C-A-h>", "<Left>", { desc = "Go to left" })
map("i", "<C-A-l>", "<Right>", { desc = "Go to right" })
map("i", "<C-A-j>", "<Down>", { desc = "Go down" })
map("i", "<C-A-k>", "<Up>", { desc = "Go up" })
map("n", "<leader>gm", "<cmd>exe 'normal! ' . line('$')/2 . 'G'<CR>", { desc = "Go to middle of the file" })

-- Move lines up/down
map({ "i", "n" }, "<C-k>", "<Up>", { desc = "Move Up" })
map({ "i", "n" }, "<C-j>", "<Down>", { desc = "Move Down" })

-- Switch buffers
map("n", "<C-h>", "<C-w>h", { desc = "Buffer switch left" })
map("n", "<C-l>", "<C-w>l", { desc = "Buffer switch right" })
map("n", "<C-j>", "<C-w>j", { desc = "Buffer switch down" })
map("n", "<C-k>", "<C-w>k", { desc = "Buffer switch up" })

-- Quick resize pane
map("n", "<C-A-h>", "5<C-w>>", { desc = "Window increase width by 5" })
map("n", "<C-A-l>", "5<C-w><", { desc = "Window decrease width by 5" })
map("n", "<C-A-k>", "5<C-w>+", { desc = "Window increase height by 5" })
map("n", "<C-A-j>", "5<C-w>-", { desc = "Window decrease height by 5" })

-- Togglers
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "Toggle nvcheatsheet" })

-- TreeSitter
map("n", "<leader>ii", "<cmd>Inspect<CR>", { desc = "TreeSitter inspect under cursor" })

-- LSP
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- focus
map("n", "<leader>h", ":FocusSplitLeft<CR>", { desc = "move buffer left" })
map("n", "<leader>j", ":FocusSplitDown<CR>", { desc = "move buffer down" })
map("n", "<leader>j", ":FocusSplitUP<CR>", { desc = "move buffer up" })
map("n", "<leader>k", ":FocusSplitRight<CR>", { desc = "move buffer right" })
map("n", "<leader>l", ":FocusSplitLeft<CR>", { desc = "move buffer left" })

map("n", "<C-x>1", ":FocusMaximise<CR>", { desc = "FocusMaximise" })
map("n", "<C-x>2", ":FocusSplitDown<CR>", { desc = "FocusSplitDown" })
map("n", "<C-x>3", ":FocusSplitRight<CR>", { desc = "FocusSplitRight" })

--- Tabufline
map("n", "<Tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer go to next" })

map("n", "<S-Tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer go to prev" })

map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer new" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })

map("n", "<C-Up>", function()
  require("colorify.tools").lighten(2)
end)

map("n", "<C-Down>", function()
  require("colorify.tools").lighten(-2)
end)

-- Define mappings for Telescope
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", opts)
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", opts)
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", opts)
map("n", "<leader>fs", "<cmd>Telescope treesitter<CR>", opts)
map("n", "<leader>fl", "<cmd>Telescope<CR>", opts)
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)

-- Mappings for nvim-tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", opts)

-- Mappings for LSP config
map("n", "<leader>rn", function()
  require("nvchad.ui.renamer").open()
end, { desc = "   lsp rename" })

-- Mappings for Trouble
map("n", "<leader>dd", "<cmd>TroubleToggle<CR>", opts)
map("n", "<leader>dw", "<cmd>Trouble workspace_diagnostics<CR>", opts)
map("n", "<leader>df", "<cmd>Trouble document_diagnostics<CR>", opts)
map("n", "<leader>dl", "<cmd>Trouble loclist<CR>", opts)
map("n", "<leader>dq", "<cmd>Trouble quickfix<CR>", opts)
map("n", "<leader>dr", "<cmd>Trouble lsp_references<CR>", opts)

-- Gitsigns
map("n", "<leader>bl", "<cmd>Gitsigns blame_line<CR>", { desc = "Gitsigns blame line" })
map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", { desc = "Gitsigns toggle deleted" })

-- Disable mappings
local nomap = vim.keymap.del

return M
