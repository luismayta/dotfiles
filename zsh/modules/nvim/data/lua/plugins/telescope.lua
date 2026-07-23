return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files {
          follow = true,
          no_ignore = true,
          hidden = true,
          prompt_prefix = " 󱡴  ",
          prompt_title = "All Files",
        }
      end,
      desc = "Find All Files",
    },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
    { "<leader>ts", "<cmd>Telescope treesitter<CR>", desc = "Treesitter" },
    { "<leader>fp", "<cmd>Telescope builtin<CR>", desc = "Telescope Pickers" },
    { "<leader>ma", "<cmd>Telescope marks<CR>", desc = "Marks" },
    { "<leader>ft", "<cmd>Telescope terms<CR>", desc = "Terms" },
    { "<leader>th", "<cmd>Telescope themes<CR>", desc = "Themes" },
    { "<leader>f?", "<cmd>Telescope help_tags<CR>", desc = "Help" },
    { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Find in Current File" },
  },
  opts = {
    defaults = {
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
      },
      mappings = {
        n = {
          ["q"] = function()
            require("telescope.actions").close()
          end,
        },
      },
      hidden = true,
      no_ignore = true,
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
      oldfiles = { prompt_title = "Recent Files" },
      find_files = { prompt_title = "Files" },
      builtin = { prompt_title = "Builtin Pickers" },
    },
    extensions_list = { "themes", "terms" },
  },
}
