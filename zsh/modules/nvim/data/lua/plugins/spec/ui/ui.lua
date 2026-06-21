local overrides = require "configs.overrides"
return {
  {
    enabled = false,
    "stevearc/dressing.nvim",
    event = "VimEnter",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      local map = vim.keymap.set

      map("n", "<leader>cc", function()
        local config = { scope = {} }
        config.scope.exclude = { language = {}, node_type = {} }
        config.scope.include = { node_type = {} }
        local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

        if node then
          local start_row, _, end_row, _ = node:range()
          if start_row ~= end_row then
            vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
            vim.api.nvim_feedkeys("_", "n", true)
          end
        end
      end, { desc = "Blankline Jump to current context" })
    end,
  },
  {
    "goolord/alpha-nvim",
    lazy = false,
  },
  {
    "dstein64/nvim-scrollview",
    lazy = true,
    config = function()
      require "configs.scrollview"
    end,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
      vim.keymap.set("n", "<leader>ut", "<cmd>UndotreeToggle<CR>", { desc = "UndoTree toggler" })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
    opts = {
      user_default_options = {
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        sass = { enable = true, parsers = { "css" } },
        mode = "virtualtext",
        virtualtext = "󱓻",
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-web-devicons",
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
      map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope search files" })
      map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope search recent files" })
      map(
        "n",
        "<leader>fc",
        "<cmd>Telescope current_buffer_fuzzy_find<CR>",
        { desc = "Telescope find in current file" }
      )
      map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope buffers" })
      map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Telescope terms" })
      map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Telescope NvChad themes" })
      map("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "Telescope LSP references" })
      map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
      map("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "Telescope find highlights" })
      map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope LSP diagnostics" })
      map("n", "<leader>ts", "<cmd>Telescope treesitter<CR>", { desc = "Telescope TreeSitter" })
      map("n", "<leader>fp", "<cmd>Telescope builtin<CR>", { desc = "Telescope pickers" })
      map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
      map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
      map("n", "<leader>f?", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help tags" })
    end,
    opts = {
      defaults = {
        selection_caret = " ",
        entry_prefix = " ",
        file_ignore_patterns = { "node_modules" },
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
