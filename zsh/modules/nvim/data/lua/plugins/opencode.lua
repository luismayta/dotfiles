return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  cmd = { "OpenCode" },
  keys = {
    {
      "<C-a>",
      function()
        require("opencode").ask "@this: "
      end,
      mode = { "n", "x" },
      desc = "OpenCode: Ask",
    },
    {
      "<C-z>",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "OpenCode: Select",
    },
    {
      "go",
      function()
        return require("opencode").operator "@this "
      end,
      mode = { "n", "x" },
      desc = "OpenCode: Append range",
      expr = true,
    },
    {
      "goo",
      function()
        return require("opencode").operator "@this " .. "_"
      end,
      mode = "n",
      desc = "OpenCode: Append line",
      expr = true,
    },
    {
      "<S-C-u>",
      function()
        require("opencode").command "session.half.page.up"
      end,
      mode = "n",
      desc = "OpenCode: Scroll up",
    },
    {
      "<S-C-d>",
      function()
        require("opencode").command "session.half.page.down"
      end,
      mode = "n",
      desc = "OpenCode: Scroll down",
    },
  },
  ---@type opencode.Opts
  opts = {
    server = {
      username = "opencode",
    },
    ask = {
      prompt = "OpenCode: ",
    },
    select = {
      prompt = "OpenCode: ",
    },
  },
}
