local api = vim.api
local fn = vim.fn
local startswith = vim.startswith
local split = vim.split

local bufferline_groups_loaded, bufferline_groups = pcall(require, "bufferline.groups")
if not bufferline_groups_loaded then
  bufferline_groups = {
    builtin = {
      pinned = {
        name = "pinned",
        with = function(_) end,
      },
      ungroupued = { name = "ungrouped" },
    },
  }
end

local patterns = {
  test = { "_spec", "_test", "test_" },
  docs_exts = { md = true, txt = true, org = true, norg = true, wiki = true },
  config_files = {
    ["go.mod"] = true,
    ["go.sum"] = true,
    ["Cargo.toml"] = true,
    ["manage.py"] = true,
    ["Makefile"] = true,
  },
}

return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      close_command = function(n)
        Snacks.bufdelete(n)
      end,
      right_mouse_command = function(n)
        Snacks.bufdelete(n)
      end,
      diagnostics = false,
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = LazyVim.config.icons.diagnostics
        local parts = {}
        if diag.error then
          table.insert(parts, icons.Error .. diag.error .. " ")
        end
        if diag.warning then
          table.insert(parts, icons.Warn .. diag.warning)
        end
        return vim.trim(table.concat(parts))
      end,
      hover = { enabled = true, reveal = { "close" } },
      mode = "buffers",
      -- sort_by = "insert_after_current",
      custom_areas = {
        right = function()
          return {
            { text = "%@TbToggle_theme@" .. vim.g.toggle_theme_icon .. "%X" },
            { text = "%@Quit_vim@󰗼 %X", fg = "#f7768e" },
          }
        end,
      },
      groups = {
        options = {
          toggle_hidden_on_enter = true,
        },
        items = {
          bufferline_groups.builtin.pinned:with({ icon = "" }),
          bufferline_groups.builtin.ungrouped,
          {
            name = "Internals",
            highlight = { fg = "#ECBE7B" },
            matcher = function(buf)
              return startswith(buf.path, vim.env.VIMRUNTIME)
            end,
          },
          {
            highlight = { sp = "#51AFEF" },
            name = "Tests",
            icon = "",
            matcher = function(buf)
              local name = api.nvim_buf_get_name(buf.id)
              for _, pattern in ipairs(patterns.test) do
                if name:match(pattern) then
                  return true
                end
              end
              return false
            end,
          },
          {
            name = "Terraform",
            matcher = function(buf)
              return buf.name:match("%.tf") ~= nil
            end,
          },
          {
            name = "SQL",
            matcher = function(buf)
              local name = api.nvim_buf_get_name(buf.id)
              return name:match("%.sql$")
            end,
          },
          {
            name = "View models",
            highlight = { sp = "#03589C" },
            matcher = function(buf)
              local name = api.nvim_buf_get_name(buf.id)
              return name:match("view_model%.dart")
            end,
          },
          {
            name = "Screens",
            icon = "󰐯",
            matcher = function(buf)
              return buf.path:match("screen")
            end,
          },
          {
            highlight = { sp = "#C678DD" },
            name = "Docs",
            matcher = function(buf)
              local ext = fn.fnamemodify(buf.path, ":e")
              return patterns.docs_exts[ext] or false
            end,
          },
          {
            highlight = { sp = "#F6A878" },
            name = "Config",
            matcher = function(buf)
              local name = api.nvim_buf_get_name(buf.id)
              local filename_arr = split(name, "/", { plain = true })
              local filename = filename_arr[#filename_arr]
              if not filename then
                return false
              end
              return patterns.config_files[filename] or false
            end,
          },
          {
            name = "Terms",
            auto_close = true,
            matcher = function(buf)
              return buf.path:match("term://") ~= nil
            end,
          },
        },
      },
      separator_style = vim.env.KITTY_WINDOW_ID and "slant" or "thin",
      show_close_icon = false,
      indicator = {
        icon = "▎",
        style = "icon",
      },
      max_name_length = 18,
      max_prefix_length = 15,
      truncate_names = true,
      tab_size = 18,
      color_icons = true,
      show_buffer_close_icons = true,
      diagnostics_update_in_insert = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },
    },
  },
}
