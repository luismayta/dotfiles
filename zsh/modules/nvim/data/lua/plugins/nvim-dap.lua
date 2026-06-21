return {
  "mfussenegger/nvim-dap-python",
  -- stylua: ignore
  keys = {
    { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
    { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
  },
  config = function()
    require("dap-python").setup("debugpy-adapter")
  end,
  build = false, -- Disable build process - this is a pure Lua plugin
  rocks = { enabled = false }, -- Explicitly disable luarocks for this plugin
  -- enabled = false,
}
