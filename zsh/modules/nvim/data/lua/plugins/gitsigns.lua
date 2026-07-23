return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "󰍵" },
      changedelete = { text = "󱕖" },
      untracked = { text = "┆" },
    },
    signs_staged = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "󰍵" },
      changedelete = { text = "󱕖" },
    },
    current_line_blame = true,
    preview_config = { border = "rounded" },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- Navigation
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")

      -- Actions
      map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
      map("v", "<leader>gr", function()
        gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
      end, "Reset Hunk")
      map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>gh", gs.stage_hunk, "Stage Hunk")
      map("v", "<leader>gh", function()
        gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
      end, "Stage Hunk")
      map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>gU", gs.reset_buffer_index, "Reset Buffer Index")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  },
}
