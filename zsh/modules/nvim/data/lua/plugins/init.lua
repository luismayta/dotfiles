return {

  -- Core UI and Themes
  { "NvChad/nvterm", enabled = false }, -- Disabled plugin

  -- LSP / Language
  { import = "plugins.spec.lang.python" },
  { import = "plugins.spec.lang.rust" },
  { import = "plugins.spec.lang.go" },
  { import = "plugins.spec.lang.graphql" },
  { import = "plugins.spec.lang.gleam" },
  { import = "plugins.spec.lang.typescript" },
  { import = "plugins.spec.lang.sre" },

  -- UI / Visual Enhancements
  { import = "plugins.spec.ui.theme" },
  { import = "plugins.spec.ui.ccc" },
  { import = "plugins.spec.ui.notify" },
  { import = "plugins.spec.ui.ui" },
  { import = "plugins.spec.ui.outline" },
  { import = "plugins.spec.ui.focus" },
  { import = "plugins.spec.ui.dropbar" },
  { import = "plugins.spec.ui.edgy" },
  { import = "plugins.spec.ui.screenkey" },
  { import = "plugins.spec.ui.tabby-ml" },
  { import = "plugins.spec.ui.md-preview" },

  -- AI / Coding Assistance
  { import = "plugins.spec.ai.ai" },
  { import = "plugins.spec.ai.codesnap" },

  -- Debugging / DAP
  { import = "plugins.spec.dap.dap-ui" },
  { import = "plugins.spec.dap.dap-virtual-text" },

  -- Tools
  { import = "plugins.spec.tools.asynctasks" },
  { import = "plugins.spec.tools.b64" },
  { import = "plugins.spec.tools.better-escape" },
  { import = "plugins.spec.tools.comment" },
  { import = "plugins.spec.tools.diffview" },
  { import = "plugins.spec.tools.fine-cmdline" },
  { import = "plugins.spec.tools.git" },
  { import = "plugins.spec.tools.neogit" },
  { import = "plugins.spec.tools.project" },
  { import = "plugins.spec.tools.productivity" },
  { import = "plugins.spec.tools.autosession" },
  { import = "plugins.spec.tools.searchbox" },

  -- Navigation
  { import = "plugins.spec.navigation.hop" },
  { import = "plugins.spec.navigation.goto-preview" },
  { import = "plugins.spec.navigation.grug-far" },
  { import = "plugins.spec.navigation.hover" },
  { import = "plugins.spec.navigation.harpoon" },
  { import = "plugins.spec.navigation.neocomposer" },
  { import = "plugins.spec.navigation.lsp-signature" },

  -- Text Manipulation / Motion
  { import = "plugins.spec.text.matchup" },
  { import = "plugins.spec.text.regexplainer" },
  { import = "plugins.spec.text.treesitter-textobjects" },
  { import = "plugins.spec.text.ts-autotag" },
  { import = "plugins.spec.text.scrolleof" },

  -- LSP Config
  { import = "plugins.spec.lsp.mason" },

  -- Completion
  { import = "plugins.spec.completion" },

  -- Overrides
  { import = "plugins.override.conform" },
}
