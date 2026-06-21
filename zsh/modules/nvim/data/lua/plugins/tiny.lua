return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "classic",
        signs = {
          diag = "󰶴", -- "󰛮",
        },
        transparent_bg = true,
        transparent_cursorline = false,
        options = {
          use_icons_from_diagnostic = false,
          show_source = {
            enabled = false,
            if_many = true,
          },
          virt_texts = {
            priority = 2048,
          },
          override_open_float = true,
          add_messages = {
            display_count = true,
            show_multiple_glyphs = false,
          },
          multilines = {
            enabled = true,
          },
        },
      })
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup({
        telescope_opts = {
          layout_strategy = "vertical",
          layout_config = {
            width = 0.5,
            height = 0.5,
            preview_cutoff = 1,
            preview_height = function(_, _, max_lines)
              local h = math.floor(max_lines * 0.5)
              return math.max(h, 10)
            end,
          },
        },
      })
    end,
  },
}
