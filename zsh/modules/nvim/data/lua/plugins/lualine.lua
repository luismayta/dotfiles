return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
    { "catppuccin/nvim", name = "catppuccin" },
  },
  event = "VeryLazy",
  opts = function()
    return {
      options = {
        theme = "catppuccin",
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
        lualine_c = { "diagnostics" },
        lualine_x = { "filetype" },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
    }
  end,
}
