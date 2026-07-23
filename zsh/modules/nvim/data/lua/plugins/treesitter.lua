return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "vim", "lua", "html", "css", "javascript", "typescript",
      "tsx", "c", "markdown", "markdown_inline", "json", "yaml",
      "toml", "go", "rust", "python", "gleam",
    },
    indent = { enable = true },
    highlight = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.config").setup(opts)
  end,
}
