require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local util = require("lspconfig/util")
local nvlsp = require "nvchad.configs.lspconfig"

-- Safe null-ls require
local ok, null_ls = pcall(require, "null-ls")
if not ok then return end

-- Safe formatter
local function format()
  if vim.lsp.buf.format then
    vim.lsp.buf.format({ async = true })
  else
    vim.lsp.buf.formatting()
  end
end

local function on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua format()<CR>", { noremap = true, silent = true })
end

-- LSP servers
local servers = {
  "html", "cssls", "tsserver", "clangd",
  "pyright", "yamlls", "dockerls",
  "clojure_lsp", "cmake", "vimls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Go
lspconfig.gopls.setup {
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "gopls" },
  cmd_env = {
    GOFLAGS = "-tags=test,e2e_test,integration_test,acceptance_test",
  },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      staticcheck = true,
      analyses = {
        unusedparams = true,
      },
      codelenses = {
        generate = true,
        tidy = true,
      },
    },
  },
}

-- Terraform
lspconfig.terraformls.setup {
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "terraform-ls", "serve" },
  root_dir = util.root_pattern(".terraform", ".git"),
}

-- TS
lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

-- null-ls setup
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.ruff,
    -- null_ls.builtins.formatting.black,
  },
  on_attach = on_attach,
})
