return {
  "Wansmer/symbol-usage.nvim",
  -- event = "BufReadPre",
  lazy = true,
  keys = {
    { "<leader>y", "<cmd>lua require('symbol-usage').toggle()<cr>", desc = "Toggle Symbols" },
  },
  config = function()
    local api = vim.api
    local function get_highlights()
      local cursorline_bg = api.nvim_get_hl(0, { name = "CursorLine" }).bg
      local comment_fg = api.nvim_get_hl(0, { name = "Comment" }).fg
      local function_fg = api.nvim_get_hl(0, { name = "Function" }).fg
      local type_fg = api.nvim_get_hl(0, { name = "Type" }).fg
      local keyword_fg = api.nvim_get_hl(0, { name = "@keyword" }).fg
      return {
        cursorline_bg = cursorline_bg,
        comment_fg = comment_fg,
        function_fg = function_fg,
        type_fg = type_fg,
        keyword_fg = keyword_fg,
      }
    end
    local hl = get_highlights()
    local highlights = {
      { name = "SymbolUsageRounding", attrs = { fg = hl.cursorline_bg, italic = true } },
      { name = "SymbolUsageContent", attrs = { bg = hl.cursorline_bg, fg = hl.comment_fg, italic = true } },
      { name = "SymbolUsageRef", attrs = { fg = hl.function_fg, bg = hl.cursorline_bg, italic = true } },
      { name = "SymbolUsageDef", attrs = { fg = hl.type_fg, bg = hl.cursorline_bg, italic = true } },
      { name = "SymbolUsageImpl", attrs = { fg = hl.keyword_fg, bg = hl.cursorline_bg, italic = true } },
    }
    for _, highlight in ipairs(highlights) do
      api.nvim_set_hl(0, highlight.name, highlight.attrs)
    end

    local static_elements = {
      round_start = { "", "SymbolUsageRounding" },
      round_end = { "", "SymbolUsageRounding" },
      spacer = { " ", "NonText" },
      ref_icon = { "󰌹 ", "SymbolUsageRef" },
      def_icon = { "󰳽 ", "SymbolUsageDef" },
      impl_icon = { "󰡱 ", "SymbolUsageImpl" },
      stack_icon = { " ", "SymbolUsageImpl" },
    }

    local format_strings = {
      usage_single = "%s usage",
      usage_multiple = "%s usages",
      usage_none = "no usages",
      def = "%s defs",
      impl = "%s impls",
    }

    local function text_format(symbol)
      local res = {}
      local idx = 1

      if symbol.references then
        local usage_text
        if symbol.references == 0 then
          usage_text = format_strings.usage_none
        elseif symbol.references == 1 then
          usage_text = format_strings.usage_single:format(symbol.references)
        else
          usage_text = format_strings.usage_multiple:format(symbol.references)
        end
        res[idx] = static_elements.round_start
        idx = idx + 1
        res[idx] = static_elements.ref_icon
        idx = idx + 1
        res[idx] = { usage_text, "SymbolUsageContent" }
        idx = idx + 1
        res[idx] = static_elements.round_end
        idx = idx + 1
      end

      if symbol.definition then
        if idx > 1 then
          res[idx] = static_elements.spacer
          idx = idx + 1
        end
        res[idx] = static_elements.round_start
        idx = idx + 1
        res[idx] = static_elements.def_icon
        idx = idx + 1
        res[idx] = { format_strings.def:format(symbol.definition), "SymbolUsageContent" }
        idx = idx + 1
        res[idx] = static_elements.round_end
        idx = idx + 1
      end

      if symbol.implementation then
        if idx > 1 then
          res[idx] = static_elements.spacer
          idx = idx + 1
        end
        res[idx] = static_elements.round_start
        idx = idx + 1
        res[idx] = static_elements.impl_icon
        idx = idx + 1
        res[idx] = { format_strings.impl:format(symbol.implementation), "SymbolUsageContent" }
        idx = idx + 1
        res[idx] = static_elements.round_end
        idx = idx + 1
      end

      if symbol.stacked_count > 0 then
        if idx > 1 then
          res[idx] = static_elements.spacer
          idx = idx + 1
        end
        res[idx] = static_elements.round_start
        idx = idx + 1
        res[idx] = static_elements.stack_icon
        idx = idx + 1
        res[idx] = { "+" .. symbol.stacked_count, "SymbolUsageContent" }
        idx = idx + 1
        res[idx] = static_elements.round_end
      end

      return res
    end

    require("symbol-usage").setup({
      text_format = text_format,
      references = { enabled = true, include_declaration = false },
      definition = { enabled = true },
      implementation = { enabled = true },
    })
  end,
}
