local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Visual movement: move lines with J/K in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next match and center" })
map("n", "N", "Nzzzv", { desc = "Prev match and center" })

-- Visual indent (reselect after indent)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Paste without losing yank (x - delete to blackhole, leader d - paste over)
map("n", "x", '"_x', { desc = "Delete without yanking" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Clear search highlight
map("n", "<C-c>", "<cmd>nohlsearch<CR><C-c>", { desc = "Clear search highlight" })

-- Format buffer
map("n", "<leader>f", function()
  require("conform").format { timeout_ms = 500, lsp_fallback = true }
end, { desc = "Format buffer" })

-- Global replace (replace word under cursor)
map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Global replace word" })

-- Window splits
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Copy file path
map("n", "<leader>fp", function()
  vim.fn.setreg("+", vim.fn.expand "%:p")
end, { desc = "Copy file path" })

-- Restart (reload config)
map("n", "<leader>re", "<cmd>source $MYVIMRC<CR>", { desc = "Reload config" })

-- LSP restart
map("n", "<leader>lr", function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    vim.lsp.stop_client(client.id)
  end
  vim.cmd "edit"
end, { desc = "Restart LSP" })
