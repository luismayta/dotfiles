return {
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local lspconfig = require "lspconfig"

      lspconfig.tsserver.setup {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          on_attach(client, bufnr)
        end,

        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,

        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
        end,
        flags = {
          debounce_text_changes = 150,
        },
      }

      require("typescript").setup {
        disable_commands = false,
        debug = false,
        go_to_source_definition = {
          fallback = true,
        },
      }

      require("nvim-treesitter.configs").setup {
        ensure_installed = { "typescript", "tsx", "javascript", "jsx" },
        highlight = { enable = true },
        autotag = { enable = true },
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
