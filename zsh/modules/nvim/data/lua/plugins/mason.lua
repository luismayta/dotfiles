return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = " 󰚌",
          },
        },
      })
    end,
  },
}
