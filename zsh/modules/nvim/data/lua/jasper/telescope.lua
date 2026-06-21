local M = {}

-- Layout presets
local presets = {
  horizontal = {
    layout_config = {
      prompt_position = "top",
      width = 0.8,
      height = 0.8,
    },
  },
  vertical = {
    layout_strategy = "vertical",
    layout_config = {
      width = 0.6,
      height = 0.9,
      prompt_position = "top",
    },
  },
  tiny = {
    layout_strategy = "cursor",
    layout_config = {
      width = 0.3,
      height = 0.3,
    },
  },
  full = {
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.95,
      height = 0.95,
      prompt_position = "top",
    },
  },
}

--- Open a Telescope picker with a preset layout
---@param name string Telescope builtin name (e.g. "find_files", "live_grep")
---@param opts table|nil Additional Telescope options (override preset)
function M.picker(name, opts)
  opts = opts or {}
  local preset_name = opts.preset or "horizontal"
  local preset = vim.tbl_deep_extend("force", presets[preset_name] or presets.horizontal, opts)

  -- Remove our custom keys before passing to telescope
  preset.preset = nil

  require("telescope.builtin")[name](preset)
end

-- Convenience wrappers
function M.ff()
  M.picker("find_files", { preset = "horizontal" })
end

function M.fg()
  M.picker("live_grep", { preset = "vertical" })
end

function M.fb()
  M.picker("buffers", { preset = "tiny" })
end

function M.fw()
  M.picker("live_grep", { preset = "horizontal" })
end

function M.fo()
  M.picker("oldfiles", { preset = "horizontal" })
end

function M.fr()
  M.picker("resume", { preset = "tiny" })
end

function M.fh()
  M.picker("help_tags", { preset = "vertical" })
end

return M
