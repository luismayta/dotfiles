return {
  {
    "echasnovski/mini.icons",
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("mini.icons").setup(opts)
    end,
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
  {
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.splitjoin").setup(opts)
    end,
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
}
