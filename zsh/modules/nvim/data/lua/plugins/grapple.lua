return {
  {
    "cbochs/grapple.nvim",
    event = "BufRead",
    keys = function()
      local keys = {
        { "<leader>H", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle" },
        { "<leader>h", "<cmd>Grapple open_tags<cr>", desc = "Grapple list" },
      }
      for i = 1, 6 do
        table.insert(keys, {
          "<leader>" .. i,
          "<cmd>Grapple select index=" .. i .. "<cr>",
          desc = "Grapple select " .. i,
        })
      end
      return keys
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_c = { "grapple" },
        lualine_x = { "overseer" },
      },
    },
  },
}
