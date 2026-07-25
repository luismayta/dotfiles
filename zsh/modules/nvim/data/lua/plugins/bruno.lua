-- Filetype detection (must come before plugins)
vim.filetype.add({ extension = { bru = "bru" } })

return {
  -- LSP: completion, diagnostics, snippets
  {
    "DaviTostes/bruno-language-server",
    build = "bun install -g bruno-language-server",
    ft = "bru",
  },

  -- Execute requests from Neovim
  {
    "romek-codes/bruno.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    ft = "bru",
    config = function()
      require("bruno").setup({
        collection_paths = {
          { name = "Main", path = vim.fn.expand("~/Documents/Bruno") },
        },
        picker = "telescope",
        show_formatted_output = true,
      })
    end,
  },

  -- Syntax highlighting (minimal, no broken treesitter API)
  {
    "jesses-code-adventures/bruno.nvim",
    ft = "bru",
    config = function()
      -- Manual treesitter parser registration if available
      local parser_ok, parsers = pcall(require, "nvim-treesitter.parsers")
      if parser_ok and parsers.get_parser_configs then
        -- Old API - register parser
        pcall(function()
          parsers.get_parser_configs().bru = {
            install_info = {
              url = "https://github.com/Scalamando/tree-sitter-bruno",
              files = { "src/parser.c" },
              branch = "main",
            },
            filetype = "bru",
          }
        end)
      end
    end,
  },
}
