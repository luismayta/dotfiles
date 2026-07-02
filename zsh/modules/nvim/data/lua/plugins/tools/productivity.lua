return {

  { "tpope/vim-surround", lazy = true, event = "BufReadPost" },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    config = function()
      require("todo-comments").setup {
        keywords = {
          GROUP = { icon = " ", color = "hint" },
          HERE = { icon = " ", color = "here" },
        },
        colors = { here = "#fdf5a4" },
        highlight = { multiline = true },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    init = function()
      local map = vim.keymap.set

      map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "WhichKey show all keymaps" })

      map("n", "<leader>wk", function()
        vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
      end, { desc = "WhichKey query lookup" })
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = {
      "astro",
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "glimmer",
      "handlebars",
      "hbs",
    },
    config = function()
      require("ts_context_commentstring").setup {
        enable_autocmd = false,
      }
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
  },
  {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },
    cmd = "ZenMode",
  },
}
