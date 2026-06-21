local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("JasperAutocmds", { clear = true })

  -- Format on save (only for LSP-enabled buffers)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*",
    callback = function(args)
      local clients = vim.lsp.get_clients({ bufnr = args.buf })
      for _, client in ipairs(clients) do
        if client.server_capabilities.documentFormattingProvider then
          vim.lsp.buf.format({ bufnr = args.buf })
          break
        end
      end
    end,
  })

  -- Highlight on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    pattern = "*",
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
  })

  -- Resize splits on window resize
  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    pattern = "*",
    command = "tabdo wincmd =",
  })
end

return M
