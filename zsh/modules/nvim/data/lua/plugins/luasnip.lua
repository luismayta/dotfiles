return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  opts = {},
  event = "InsertEnter",
  config = function()
    local luasnip = require "luasnip"

    vim.api.nvim_create_autocmd("InsertLeave", {
      callback = function()
        if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
          luasnip.unlink_current()
        end
      end,
    })
  end,
}