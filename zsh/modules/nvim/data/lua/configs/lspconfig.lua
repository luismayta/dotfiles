require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local util = require("lspconfig/util")
local jasper = require("jasper.lsp")

-- Simple servers (no extra config needed)
local servers = {
  "html", "cssls", "clangd",
  "pyright", "yamlls", "dockerls",
  "clojure_lsp", "cmake", "vimls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup(jasper.server(lsp))
end

-- Go
lspconfig.gopls.setup(jasper.server("gopls", {
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
}))

-- Terraform
lspconfig.terraformls.setup(jasper.server("terraformls", {
  cmd = { "terraform-ls", "serve" },
  root_dir = util.root_pattern(".terraform", ".git"),
}))

-- TypeScript (disable formatting - handled by conform)
lspconfig.ts_ls.setup(jasper.server("ts_ls", {
  features = { keymaps = true, diagnostics = true, formatting = false },
}))


