--- Catppuccin Macchiato colorscheme (dotfiles standard)
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "macchiato",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        mini = false,
        -- LazyVim integrations
        which_key = true,
        native_lsp = {
          enabled = true,
          virtual_text = true,
          underlines = false,
          inlay_hints = true,
        },
      },
    },
  },
}
