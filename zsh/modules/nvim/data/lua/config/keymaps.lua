local map = vim.keymap.set

-- === Mode & Save ===
map("n", ";", ":", { desc = "Enter command mode" })
map({ "n", "i", "v", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })

-- === Escape handler (clear hlsearch + stop snippets) ===
map({ "i", "n", "s" }, "<Esc>", function()
  vim.cmd "noh"
  vim.snippet.stop()
  return "<Esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })

-- === Clear search highlight ===
map("n", "<C-c>", "<cmd>nohlsearch<CR><C-c>", { desc = "Clear search highlight" })

-- === Clear messages ===
map("n", "<leader>cm", "<cmd>clearjumps<Bar>echomsg 'Cleared'<CR>", { desc = "Clear messages" })

-- === Wrapped line navigation ===
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (wrapped)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (wrapped)" })

-- === Centered scrolling ===
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next match and center" })
map("n", "N", "Nzzzv", { desc = "Prev match and center" })

-- === Visual indent ===
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- === Visual movement (lines) ===
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- === Move lines (Alt-J/K, visual + normal) ===
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = "Move line up" })
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = "Move line up" })

-- === Paste without losing yank ===
map("n", "x", '"_x', { desc = "Delete without yanking" })
map({ "n", "v" }, "<leader>dd", '"_d', { desc = "Delete without yanking" })

-- === Window navigation (C-h/j/k/l) ===
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- === Ctrl-X prefix window management ===
map("n", "<C-x>h", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-x>j", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-x>k", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-x>l", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-x>v", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<C-x>s", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<C-x>o", "<C-w>o", { desc = "Keep only current window" })
map("n", "<C-x>c", "<C-w>c", { desc = "Close window" })
map("n", "<C-x>q", "<C-w>q", { desc = "Quit window" })

-- === Window splits (leader-based) ===
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- === Buffer navigation ===
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })

-- === Go to middle of line ===
map("n", "<leader>gm", "<cmd>normal! zz<CR>", { desc = "Go to middle" })

-- === Global replace ===
map("n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Global replace word" })

-- === Copy file path ===
map("n", "<leader>fy", function()
  vim.fn.setreg("+", vim.fn.expand "%:p")
end, { desc = "Copy file path" })

-- === Quickfix / location list ===
map("n", "<leader>ol", "<cmd>lopen<CR>", { desc = "Open location list" })

-- === Treesitter inspector ===
map("n", "<leader>ii", "<cmd>TSHighlightCapturesUnderCursor<CR>", { desc = "Treesitter: inspect" })

-- === Git ===
map("n", "<leader>bl", "<cmd>Gitsigns blame<CR>", { desc = "Git blame" })
map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", { desc = "Git toggle deleted" })

-- === Toggle terminal ===
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- === Restart (reload config) ===
map("n", "<leader>re", "<cmd>source $MYVIMRC<CR>", { desc = "Reload config" })

-- === LSP restart ===
map("n", "<leader>lr", function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    vim.lsp.stop_client(client.id)
  end
  vim.cmd "edit"
end, { desc = "Restart LSP" })
