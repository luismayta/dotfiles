return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
    "folke/tokyonight.nvim",
  },
  event = "VeryLazy",
  opts = function()
    return {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
          { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
        },
        lualine_x = {
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
          },
          "encoding",
          "fileformat",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
