return {
  {
    "mfussenegger/nvim-dap",
  },
  { "nvim-neotest/neotest", lazy = false },
  { "nvim-neotest/neotest-python", lazy = false },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  {
    enabled = false,
    "AckslD/swenv.nvim",
    ft = "python",
    config = function()
      require("swenv").setup {
        post_set_env = function()
          vim.cmd "LspRestart"
        end,
      }

      local map = vim.keymap.set
      local api = require "swenv.api"

      map("n", "<leader>ps", function()
        api.pick_venv()
      end, { desc = "Choose Python venv" })
      map("n", "<leader>pe", function()
        api.get_current_venv()
      end, { desc = "Show current Python venv" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      { "mfussenegger/nvim-dap" },
      { "rcarriga/nvim-dap-ui" },
    },
    config = function()
      local dap_py = require "dap-python"
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"

      dap_py.setup(path)

      vim.keymap.set("n", "<leader>pdr", function()
        dap_py.test_method()
      end, { desc = "Run Python debug" })
    end,
  },
}
