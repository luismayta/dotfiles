--- Markdown rendering plugin for cleaner editing experience
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  opts = {
    heading = {
      sign = false,
      position = "inline",
      width = "block",
    },
    link = {
      enabled = false,
    },
  },
}
