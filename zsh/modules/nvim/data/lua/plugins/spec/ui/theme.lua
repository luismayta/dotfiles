return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          treesitter = true,
          telescope = true,
          notify = true,
          indent_blankline = {
            enabled = true,
          },
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "NvChad/base46",
    branch = "v3.0",
    build = function()
      require("base46").load_all_highlights()
    end,
    lazy = true,
  },
  {
    "NvChad/ui",
    branch = "v3.0",
    lazy = true,
    config = function()
      require "nvchad"
    end,
  },
}
