return {
  "folke/flash.nvim",
  opts = function(_, opts)
    opts = opts or {}
    opts.modes = {
      char = {
        enabled = true,
        keys = { "f", "F", "t", "T", "/" },
        char_actions = function(motion)
          return {
            [","] = "prev",
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
      },
    }
  end,
}
