local map = require("jasper.utils").nnoremap

local M = {}

-- LSP Keymaps (to be set per-buffer via on_attach)
function M.lsp(bufnr)
  local opts = { buffer = bufnr }
  map("gd", vim.lsp.buf.definition, "Go to definition", opts)
  map("gD", vim.lsp.buf.declaration, "Go to declaration", opts)
  map("gr", vim.lsp.buf.references, "Find references", opts)
  map("gi", vim.lsp.buf.implementation, "Go to implementation", opts)
  map("K", vim.lsp.buf.hover, "Hover documentation", opts)
  map("gK", vim.lsp.buf.signature_help, "Signature help", opts)
  map("<leader>rn", function() require("nvchad.ui.renamer").open() end, "LSP rename", opts)
  map("<leader>ca", vim.lsp.buf.code_action, "Code action", opts)
  map("<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "Format buffer", opts)
end

return M
