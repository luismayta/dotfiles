return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute { toggle = true, dir = LazyVim.root() }
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute { toggle = true, dir = vim.uv.cwd() }
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>e",
      function()
        local dir = vim.fn.expand "%:p:h"
        if dir == "" then
          dir = LazyVim.root()
        end
        require("neo-tree.command").execute { toggle = true, dir = dir }
      end,
      desc = "Explorer NeoTree (File Dir)",
    },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
  },
}
