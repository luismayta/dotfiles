return {
  "folke/trouble.nvim",
  commands = { "Trouble", "TroubleToggle" },
  config = function()
    require("trouble").setup()
  end,
}