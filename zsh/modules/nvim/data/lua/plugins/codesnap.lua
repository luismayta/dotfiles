return {
  "mistricky/codesnap.nvim",
  build = "make build",
  cmd = { "CodeSnap", "CodeSnapSave" },
  opts = {
    bg_theme = "grape",
    has_breadcrumbs = true,
    show_line_number = true,
  },
}
