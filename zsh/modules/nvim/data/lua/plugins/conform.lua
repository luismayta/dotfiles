return {
  "stevearc/conform.nvim",
  event = "BufReadPre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format { timeout_ms = 500, lsp_fallback = true }
      end,
      mode = { "n", "v" },
      desc = "Format",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        if vim.g.autoformat ~= false then
          require("conform").format { bufnr = args.buf, timeout_ms = 500, lsp_fallback = true }
        end
      end,
    })
  end,
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      toml = { "taplo" },
      xml = { "xmlformat" },
      graphql = { "prettier" },
      json = { "jq" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      markdown = { "prettier" },
      yaml = { "prettier" },
      go = { "gofmt", "goimports" },
      python = { "isort", "black" },
      sql = { "sqlfmt" },
      gleam = { "gleam" },
      rust = { "rustfmt" },
    },
    formatters = {
      sqlfmt = { command = "sqlfmt", args = { "-" } },
    },
    format_on_save = function(bufnr)
      if vim.g.autoformat ~= false then
        return { timeout_ms = 500, lsp_fallback = true }
      end
    end,
  },
}
