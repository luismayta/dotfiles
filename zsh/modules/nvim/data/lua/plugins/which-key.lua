return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- v3 config (no plugins.spelling option)
  },
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)
    -- v3 syntax: use wk.add() instead of wk.register()
    wk.add {
      { "<leader>b", group = "+buffer" },
      { "<leader>c", group = "+code" },
      { "<leader>f", group = "+file/find" },
      { "<leader>g", group = "+git" },
      { "<leader>q", group = "+quit/session" },
      { "<leader>s", group = "+search" },
      { "<leader>u", group = "+ui" },
      { "<leader>w", group = "+windows" },
      { "<leader>x", group = "+buffer/close" },
      { "g", group = "+goto" },
      { "gs", group = "+surround" },
      { "]", group = "+next" },
      { "[", group = "+prev" },
    }
  end,
}
