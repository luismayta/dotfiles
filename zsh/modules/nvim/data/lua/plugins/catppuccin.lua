return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      integrations = {
        alpha = true,
        bufferline = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          scope_color = "sapphire",
          colored_indent_levels = false,
        },
        which_key = true,
        mini = {
          enabled = true,
          indentscope_color = "sapphire",
        },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        treesitter = true,
        markdown = true,
        mason = true,
        neotree = true,
      },
    }
    vim.cmd.colorscheme "catppuccin"
  end,
}
