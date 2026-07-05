return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- enabled modules (Fase 1 — low risk, replacing standalone plugins)
    indent = { enabled = true },
    dashboard = { enabled = true },
    input = { enabled = true },
    statuscolumn = { enabled = true },
  },
}
