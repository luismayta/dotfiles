require("nvchad.configs.lspconfig").defaults()

-- Jasper diagnostic signs
require("jasper.lsp").setup_diagnostics()

-- LspAttach handler: jasper keymaps + ts_ls formatting disable
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    -- Disable formatting for ts_ls (use conform instead)
    if client.name == "ts_ls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Jasper LSP keymaps
    require("jasper.keymaps").lsp(ev.buf)
  end,
})

-- Simple servers (no extra config needed)
vim.lsp.enable({ "html", "cssls", "clangd", "pyright", "yamlls", "dockerls", "clojure_lsp", "cmake", "vimls" })

-- Go
vim.lsp.config("gopls", {
  cmd_env = { GOFLAGS = "-tags=test,e2e_test,integration_test,acceptance_test" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      staticcheck = true,
      analyses = { unusedparams = true },
      codelenses = { generate = true, tidy = true },
    },
  },
})
vim.lsp.enable("gopls")

-- Terraform
vim.lsp.config("terraformls", {
  cmd = { "terraform-ls", "serve" },
  root_markers = { ".terraform", ".git" },
})
vim.lsp.enable("terraformls")

-- TypeScript (formatting disabled in LspAttach handler)
vim.lsp.enable("ts_ls")
