return {
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "windwp/nvim-ts-autotag",
    },
    opts = function()
      local nvlsp = require "nvchad.configs.lspconfig"

      return {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        capabilities = nvlsp.capabilities,
      }
    end,
  },
  {
    "wuelnerdotexe/vim-astro",
    ft = "astro",
    config = function()
      vim.g.astro_typescript = "enable"
    end,
  },
}
