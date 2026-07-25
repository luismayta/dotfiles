return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    automatic_installation = true,
    ensure_installed = {
      "lua_ls",
      "vtsls",
      "pyright",
      "gopls",
      "rust_analyzer",
      "yamlls",
      "dockerls",
      "terraformls",
    },
  },
  config = function(_, opts)
    require("mason-lspconfig").setup(opts)
  end,
}
