return {
  "jakobkhansen/journal.nvim",
  cmd = "Journal",
  opts = {
    filetype = "md",
    root = "~/notes/daily",
    journal = {
      entries = {
        day = {
          format = "%Y-%m-%d",
        },
      },
    },
  },
}
