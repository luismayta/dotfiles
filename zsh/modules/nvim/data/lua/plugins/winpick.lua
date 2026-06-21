return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  -- event = "VeryLazy",
  version = "2.*",
  config = function()
    require("window-picker").setup({
      hint = "floating-big-letter",
      show_prompt = false,
    })
  end,
  keys = {
    {
      ",w",
      function()
        local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(picked_window_id)
      end,
      mode = "n",
      desc = "Pick a window",
    },
    {
      ",s",
      function()
        local window = require("window-picker").pick_window()
        local target_buffer = vim.fn.winbufnr(window)
        vim.api.nvim_win_set_buf(window, 0)
        vim.api.nvim_win_set_buf(0, target_buffer)
      end,
      mode = "n",
      desc = "Pick a window",
    },
  },
}
