local is_online = require("config.utils").is_online

return {
  "saghen/blink.cmp",
  dependencies = {
    {
      "giuxtaposition/blink-cmp-copilot",
      enabled = is_online,
    },
  },
  opts = function(_, opts)
    opts.enabled = function()
      local filetype = vim.bo[0].filetype
      local excluded_filetypes = {
        "TelescopePrompt",
        "minifiles",
        "snacks_picker_input",
        "neo-tree",
        "neo-tree-popup",
      }

      for _, ft in ipairs(excluded_filetypes) do
        if filetype == ft then
          return false
        end
      end
      return true
    end
    opts.fuzzy = vim.tbl_deep_extend("force", opts.fuzzy or {}, {
      use_frecency = true,
      use_proximity = true,
    })
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = function(_)
        local success, node = pcall(vim.treesitter.get_node)
        if vim.bo.filetype == "lua" then
          local src = { "lazydev", "lsp", "path" }
          if is_online() then
            table.insert(src, "copilot")
          end
          return src
        elseif success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
          return { "buffer" }
        else
          local src = { "lsp", "path", "snippets", "buffer" }
          if is_online() then
            table.insert(src, "copilot")
          end
          return src
        end
      end,
      providers = {
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          kind = "LSP",
          min_keyword_length = 2,
          score_offset = 90,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 92,
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 25,
          fallbacks = { "snippets", "buffer" },
          min_keyword_length = 3,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = "Buffer",
          enabled = true,
          max_items = 3,
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 4,
          score_offset = 15,
        },
        copilot = {
          name = "copilot",
          enabled = is_online(),
          module = "blink-cmp-copilot",
          kind = "Copilot",
          min_keyword_length = 5,
          score_offset = 10,
          async = true,
        },
      },
    })

    opts.cmdline = {
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        if type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
      keymap = {
        ["<Tab>"] = { "show", "accept" },
      },
      completion = { menu = { auto_show = true }, ghost_text = { enabled = false } },
    }

    opts.completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = false,
      },
    }
    opts.signature = { enabled = true }
    local icons = require("config.utils").kind_icons
    opts.appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "normal",
      kind_icons = icons,
    }
  end,
}
