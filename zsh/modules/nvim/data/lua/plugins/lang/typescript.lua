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
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      return {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        capabilities = capabilities,
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
