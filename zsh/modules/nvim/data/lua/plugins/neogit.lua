return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  keys = {
    { "<leader>go", "<cmd>Neogit<CR>", desc = "Neogit" },
    { "<leader>gC", "<cmd>Neogit commit<CR>", desc = "Neogit commit" },
    { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Neogit pull" },
    { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Neogit push" },
    { "<leader>gr", "<cmd>Neogit rebase<CR>", desc = "Neogit rebase" },
    { "<leader>gl", "<cmd>Neogit log<CR>", desc = "Neogit log" },
  },
  config = true,
}
