-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local del = vim.keymap.del

-- Better command mode
map("n", ";", ":", { desc = "Enter command mode" })

-- Save
map({ "n", "i", "v", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })

-- Stop highlight on Esc (and stop snippets)
map({ "i", "n", "s" }, "<Esc>", function()
  vim.cmd "noh"
  vim.snippet.stop()
  return "<Esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })

-- Clear messages
map("n", "<leader>cm", "<cmd>clearjumps<Bar>echomsg 'Cleared'<CR>", { desc = "Clear messages" })

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

-- Ctrl-X prefix window management (like tmux)
map("n", "<C-x>h", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-x>j", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-x>k", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-x>l", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-x>v", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<C-x>s", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<C-x>o", "<C-w>o", { desc = "Keep only current window" })
map("n", "<C-x>c", "<C-w>c", { desc = "Close window" })
map("n", "<C-x>1", "<C-w>o", { desc = "Keep only current window" })
map("n", "<C-x>2", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<C-x>3", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<C-x>q", "<C-w>q", { desc = "Quit window" })

-- Move lines (visual mode)
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = "Move line up" })

-- Move lines (normal mode)
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = "Move line up" })

-- Buffer navigation
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

-- LSP inlay hints toggle
map("n", "<leader>uh", function()
  vim.lsp.inlayhints.enable(not vim.lsp.inlayhints.is_enabled())
end, { desc = "Toggle inlay hints" })
