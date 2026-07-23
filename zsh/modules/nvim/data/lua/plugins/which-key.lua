return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>wK", "<cmd>WhichKey <CR>", desc = "WhichKey show all keymaps" },
    { "<leader>wk", function() vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ") end, desc = "WhichKey query lookup" },
  },
}
