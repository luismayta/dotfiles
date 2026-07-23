return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = {
      "lua_ls",
      "vtsls",
      "gopls",
      "rust_analyzer",
      "pyright",
      "basedpyright",
      "eslint",
    },
    automatic_installation = true,
  },
}
