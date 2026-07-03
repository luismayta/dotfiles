-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local del = vim.keymap.del

-- Better command mode
map("n", ";", ":", { desc = "Enter command mode" })

-- Save
map({ "n", "i", "v", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })

-- Stop highlight on Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Stop search highlight" })

-- Clear messages
map("n", "<leader>cm", "<cmd>clearjumps<Bar>echomsg 'Cleared'<CR>", { desc = "Clear messages" })

-- Yank preserves cursor position
map("n", "y", "ygv<Esc>", { desc = "Yank (keep cursor)" })

-- Wrapped line navigation
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (wrapped)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (wrapped)" })

-- Better indentation
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Window navigation (override LazyVim defaults)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resize
map("n", "<C-A-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-A-j>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-A-k>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-A-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines (visual mode)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Move lines (normal mode)
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

-- Tab navigation
map("n", "<Tab>", "<cmd>bn<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bp<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })

-- Go to middle of line
map("n", "<leader>gm", "<cmd>normal! zz<CR>", { desc = "Go to middle" })

-- Quickfix / location list
map("n", "<leader>ol", "<cmd>lopen<CR>", { desc = "Open location list" })

-- Treesitter inspector
map("n", "<leader>ii", "<cmd>TSHighlightCapturesUnderCursor<CR>", { desc = "Treesitter: inspect" })

-- Git
map("n", "<leader>bl", "<cmd>Gitsigns blame<CR>", { desc = "Git blame" })
map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", { desc = "Git toggle deleted" })

-- Toggle terminal
map("n", "<leader>h", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window splits (Ctrl-X prefix)
map("n", "<C-x>1", "<C-w>o", { desc = "Keep only current window" })
map("n", "<C-x>2", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<C-x>3", "<cmd>split<CR>", { desc = "Split window horizontally" })
