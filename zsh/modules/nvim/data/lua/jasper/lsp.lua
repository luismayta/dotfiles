local M = {}

-- Default capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Diagnostic signs (idempotent, llamar una vez al startup)
local function setup_diagnostics()
  local signs = { Error = " ", Warn = " ", Info = " ", Hint = "󰠠 " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = { prefix = "●" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded" },
  })
end

M.setup_diagnostics = setup_diagnostics

return M
