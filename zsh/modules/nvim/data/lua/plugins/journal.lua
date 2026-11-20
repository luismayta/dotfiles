return {
  "jakobkhansen/journal.nvim",
  cmd = "Journal",
  keys = {
    { "<leader>j", "<cmd>Journal day<cr>", desc = "Journal: today" },
    { "<leader>jl", "<cmd>Journal last<cr>", desc = "Journal: last entry" },
  },
  opts = {
    filetype = "md",
    root = "~/notes/daily",
    journal = {
      format = "%Y-%m-%d",
      template = "# %Y-%m-%d\n",
      frequency = { day = 1 },
      entries = {
        day = {
          format = "%Y-%m-%d",
          template = "# %Y-%m-%d\n",
          frequency = { day = 1 },
        },
        week = {
          format = "%Y-%W",
          template = "# Week %W, %Y\n",
          frequency = { day = 7 },
          date_modifier = "monday",
        },
        month = {
          format = "%Y-%m",
          template = "# %B %Y\n",
          frequency = { month = 1 },
        },
        year = {
          format = "%Y",
          template = "# %Y\n",
          frequency = { year = 1 },
        },
      },
    },
  },
}
