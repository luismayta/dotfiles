local overrides = require "configs.overrides"

return {
  { "tpope/vim-fugitive", lazy = false },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = "sindrets/diffview.nvim",
    opts = overrides.gitsigns,
  },
}