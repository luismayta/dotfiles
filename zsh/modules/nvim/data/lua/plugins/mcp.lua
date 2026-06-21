return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  enabled = require("config.utils").is_mcp_present(),
  event = "BufReadPost",
  -- cmd = "MCPHub",
  build = "npm install -g mcp-hub@latest",
  config = function()
    require("mcphub").setup({
      port = 4000,
      config = vim.fn.expand("~/.mcpservers.json"),
      shutdown_delay = 0,
      log = {
        level = vim.log.levels.ERROR,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
      },
      extensions = {
        avante = {
          make_slash_commands = true,
        },
      },
    })
  end,
}
