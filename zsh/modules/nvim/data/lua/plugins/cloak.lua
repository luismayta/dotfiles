return {
  {
    "laytan/cloak.nvim",
    enabled = false,
    opts = {
      highlight_group = "Comment",
      patterns = {
        {
          file_pattern = ".env*",
          cloak_pattern = "=.+",
          replace = nil,
        },
        {
          file_pattern = "auth.json",
          cloak_pattern = ":.+",
          replace = nil,
        },
      },
    },
  },
}
