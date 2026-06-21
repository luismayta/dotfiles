return {

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "MasonInstallAll", "Mason" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local overrides = require "configs.mason-lspconfig"

      mason_lspconfig.setup({
        ensure_installed = overrides.ensure_installed,
        automatic_installation = true,
      })

      -- Register ensure_installed servers via Neovim 0.12+ vim.lsp.enable
      -- This populates vim.lsp._enabled_configs (read by MasonInstallAll)
      -- and auto-starts servers on matching filetype.
      -- vim.lsp.enable is idempotent for servers already set up explicitly
      -- in configs/lspconfig.lua.
      local lspconfig_available, lspconfig_configs = pcall(require, "lspconfig.configs")
      local available_servers = lspconfig_available and vim.tbl_keys(lspconfig_configs) or {}

      for _, server in ipairs(overrides.ensure_installed) do
        if vim.tbl_contains(available_servers, server) then
          vim.lsp.enable(server)
        else
          vim.notify("[mason-lspconfig] Unknown LSP server: " .. server, vim.log.levels.WARN)
        end
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
  },
}
