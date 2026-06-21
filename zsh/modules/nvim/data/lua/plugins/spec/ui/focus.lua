return {
  "nvim-focus/focus.nvim",
  lazy = false,
  version = '*',
  config = function()
    require("focus").setup({
      ui = {
        cursorline = true,
        cursorcolumn = true,
        colorcolumn = { enable = true, list = '+1,+2' },
      },
    })
  end,
}