return {
  {
    "ray-x/cmp-treesitter",
    lazy = true,
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },
}
