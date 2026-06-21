return {

  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      preview = {
        treesitter = false,
      },
      layout_config = {
        width = 0.90,
        height = 0.85,
        preview_cutoff = 120,
        prompt_position = "bottom",
        horizontal = {
          preview_width = function(_, cols, _)
            return math.floor(cols * 0.6)
          end,
        },
        vertical = {
          width = 0.9,
          height = 0.95,
          preview_height = 0.5,
        },
        flex = {
          horizontal = {
            preview_width = 0.9,
          },
        },
      },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },
}
