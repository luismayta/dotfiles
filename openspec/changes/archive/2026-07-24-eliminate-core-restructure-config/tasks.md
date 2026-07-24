## 1. Merge Options

- [x] 1.1 Merge `core/options.lua` into `config/options.lua` (keep core values: updatetime=50, scrolloff=8, wrap=false, foldmethod=manual)
- [x] 1.2 Remove duplicate `vim.g.mapleader` from `config/options.lua` (already in init.lua)

## 2. Restore Keymaps

- [x] 2.1 Copy merged `core/keymaps.lua` content to `config/keymaps.lua` (122 lines)
- [x] 2.2 Remove deprecation comment from `config/keymaps.lua`

## 3. Update Entry Point

- [x] 3.1 Update `init.lua`: replace `require "core"` with `require "config.options"` and `require "config.keymaps"`

## 4. Delete core/

- [x] 4.1 Delete `~/.config/nvim/lua/core/` directory (init.lua, options.lua, keymaps.lua)
- [x] 4.2 Delete `/home/lucho/.dotfiles/zsh/modules/nvim/data/lua/core/` directory

## 5. Sync Dotfiles

- [x] 5.1 Update `/home/lucho/.dotfiles/zsh/modules/nvim/data/lua/config/options.lua` with merged content
- [x] 5.2 Update `/home/lucho/.dotfiles/zsh/modules/nvim/data/lua/config/keymaps.lua` with merged keymaps
- [x] 5.3 Update `/home/lucho/.dotfiles/zsh/modules/nvim/data/init.lua` with new entry point

## 6. Verify

- [x] 6.1 Open Neovim and verify all options are applied (check `:set updatetime?`, `:set scrolloff?`, `:set wrap?`)
- [x] 6.2 Test `<C-x>` keybindings work (e.g., `<C-x>v` for vertical split)
- [x] 6.3 Test leader keybindings work (e.g., `,f` for format, `,sv` for split)