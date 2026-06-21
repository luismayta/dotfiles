return {
  "stevearc/conform.nvim",
  opts = function()
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        css = { "prettierd" },
        dependabot = { "yamlfmt" },
        gha = { "yamlfmt" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        shell = { "shfmt" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        yaml = { "yamlfmt" },
      },
      formatters = {
        black = {
          prepend_args = { "--fast" },
        },
        injected = { options = { ignore_errors = true } },
        isort = {
          prepend_args = { "--profile", "black" },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        yamlfmt = {
          prepend_args = {
            "-formatter",
            "retain_line_breaks_single=true",
          },
        },
      },
    }
    return opts
  end,
}
