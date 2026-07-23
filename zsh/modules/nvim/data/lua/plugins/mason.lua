return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "black",
      "isort",
      "prettier",
      "jq",
      "taplo",
      "xmlformat",
      "sqlfmt",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
  end,
}
