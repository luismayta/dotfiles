local M = {}

-- Default capabilities (merge with nvchad defaults)
M.capabilities = vim.lsp.protocol.make_client_capabilities()



-- Feature: Diagnostic signs
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
-- Composable on_attach
---@param features table|nil Table with boolean flags: keymaps, diagnostics, formatting, hover
---@return function on_attach callback
function M.on_attach(features)
  features = features or { keymaps = true, diagnostics = true }

  -- Setup diagnostics once (idempotent)
  if features.diagnostics then
    setup_diagnostics()
  end

  return function(client, bufnr)
    -- Disable formatting for ts_ls (use conform instead)
    if client.name == "ts_ls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Feature: keymaps
    if features.keymaps then
      require("jasper.keymaps").lsp(bufnr)
    end
  end
end

-- Convenience server config builder
---@param name string LSP server name
---@param opts table|nil Server-specific options (settings, cmd, filetypes, etc.)
---@return table lspconfig-compatible config
function M.server(name, opts)
  opts = opts or {}
  local nvlsp = require("nvchad.configs.lspconfig")

  -- Merge capabilities
  local capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, opts.capabilities or {})

  -- Use jasper on_attach if not explicitly provided
  local features = opts.features or { keymaps = true, diagnostics = true }
  local on_attach = opts.on_attach or M.on_attach(features)

  local config = {
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = capabilities,
  }

  -- Merge server-specific options (cmd, settings, filetypes, root_dir, etc.)
  for k, v in pairs(opts) do
    if k ~= "features" and k ~= "capabilities" and k ~= "on_attach" then
      config[k] = v
    end
  end

  return config
end

return M
