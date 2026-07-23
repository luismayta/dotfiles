return {
  {
    enabled = false,
    "stevearc/dressing.nvim",
    event = "VimEnter",
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
    lazy = false,
  },
  {
    "dstein64/nvim-scrollview",
    lazy = true,
    config = function()
      local ok, scrollview = pcall(require, "scrollview")
      if ok then
        scrollview.setup {}
      end
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = true,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- Dep of: ai/ai.lua, lang/go.lua, text/regexplainer.lua, text/ts-autotag.lua
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "markdown",
        "markdown_inline",
      },
      indent = {
        enable = true,
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    -- Dep of: ai/ai.lua
    opts = {
      override = {
        md = { icon = "󰽛", color = "#ffffff", name = "Markdown" },
        mdx = { icon = "󰽛", color = "#ffffff", name = "Mdx" },
      },
      override_by_extension = {
        astro = { icon = "", color = "#fe5d02", name = "astro" },
        javascript = { icon = "" },
        typescript = { icon = "󰛦" },
        lockb = { icon = "", color = "#fbf0df", name = "bun-lock" },
      },
      override_by_filename = {
        [".stylua.toml"] = { icon = "", color = "#6d8086", name = "stylua" },
        [".gitignore"] = { icon = "", color = "#6d8086", name = "gitignore" },
        ["license"] = { icon = "󰿃", name = "License" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    -- Dep of: tools/neogit.lua, ai/ai.lua
    init = function()
      local map = vim.keymap.set
      local builtin = require "telescope.builtin"

      map("n", "<leader>fa", function()
        builtin.find_files {
          follow = true,
          no_ignore = true,
          hidden = true,
          prompt_prefix = " 󱡴  ",
          prompt_title = "All Files",
        }
      end, { desc = "Telescope search all files" })

      map(
        "n",
        "<leader>fc",
        "<cmd>Telescope current_buffer_fuzzy_find<CR>",
        { desc = "Telescope find in current file" }
      )

      map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Telescope terms" })
      map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Telescope themes" })

      map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
      map("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "Telescope find highlights" })
      map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope LSP diagnostics" })
      map("n", "<leader>ts", "<cmd>Telescope treesitter<CR>", { desc = "Telescope TreeSitter" })
      map("n", "<leader>fp", "<cmd>Telescope builtin<CR>", { desc = "Telescope pickers" })
      map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
      map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
      map("n", "<leader>f?", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help tags" })
      map("n", "<leader>/", function()
        builtin.live_grep { prompt_title = "Live Grep" }
      end, { desc = "Telescope live grep" })
    end,
    opts = {
      defaults = {
        hidden = true,
        no_ignore = true,
        selection_caret = " ",
        entry_prefix = " ",
        file_ignore_patterns = { "node_modules" },
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
      pickers = {
        oldfiles = {
          prompt_title = "Recent Files",
        },
        find_files = {
          prompt_title = "Files",
        },
        builtin = {
          prompt_title = "Builtin Pickers",
        },
      },
    },
  },
}
