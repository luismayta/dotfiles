return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "black",
      "isort",
      "biome",
      "jq",
      "taplo",
      "xmlformat",
      "sqlfmt",
      "hadolint",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
  end,
}
