return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Keymaps on LSP attach
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = function(desc)
          return { buffer = ev.buf, desc = "LSP: " .. desc }
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts("Workspace symbol"))
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts("Line diagnostics"))
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts("Code action"))
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts("References"))
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts("Rename"))
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts("Signature help"))

        -- Inlay hints toggle
        vim.keymap.set("n", "<leader>uh", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, opts("Toggle inlay hints"))
      end,
    })

    -- Server configurations using vim.lsp.config (nvim 0.12 native)
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
            hint = { enable = true },
          },
        },
      },
      vtsls = {},
      gopls = {
        settings = {
          gopls = {
            analyses = { unusedparams = true, shadow = true },
            hints = { assignVariablesTypes = true, compositeLiteralFields = true, constantValues = true, functionTypeParameters = true, parameterNames = true, rangeVariableTypes = true },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
          },
        },
      },
      pyright = {},
      basedpyright = {},
      eslint = {},
    }

    -- Configure and enable each server
    for server, config in pairs(servers) do
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
