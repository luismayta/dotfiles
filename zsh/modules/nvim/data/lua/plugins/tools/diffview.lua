return {
  "sindrets/diffview.nvim",
  -- Dep of: tools/git.lua, tools/neogit.lua
  cmd = { "DiffviewOpen", "DiffviewClose" },
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
    map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Diffview close" })
  end,
  config = true,
}
