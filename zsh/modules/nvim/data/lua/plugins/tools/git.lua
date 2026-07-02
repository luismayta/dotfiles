return {
  { "tpope/vim-fugitive", lazy = false },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = "sindrets/diffview.nvim",
    opts = {
      current_line_blame = true,
      preview_config = {
        border = "rounded",
      },
    },
  },
}
