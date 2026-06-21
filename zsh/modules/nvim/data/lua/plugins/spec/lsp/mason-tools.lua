return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    ensure_installed = {
      "goimports",
      "gofumpt",

      -- LSP servers (installed via Mason, configured in lspconfig.lua)
      "ansiblels",
      "tflint",
      "bashls",
      "ruff",
      "texlab",
      "marksman",
      "solidity",
      "taplo",
      "sqls",
      "sqlls",
      "intelephense",
      "html",
      "cssls",
      "clangd",
      "pyright",
      "yamlls",
      "dockerls",
      "clojure_lsp",
      "cmake",
      "vimls",
      "gopls",
      "terraformls",
      "ts_ls",
    },
  },
}
