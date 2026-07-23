## 1. New Plugins Setup

- [ ] 1.1 Create `bufferline.lua` plugin file with lazy loading and NvChad-style config
- [ ] 1.2 Create `indent-blankline.lua` plugin file with scope highlighting
- [ ] 1.3 Create `which-key.lua` plugin file for key binding hints
- [ ] 1.4 Create `alpha.lua` dashboard plugin file

## 2. Existing Plugin Enhancement

- [ ] 2.1 Update `lualine.lua` with NvChad-style mode colors and better sections
- [ ] 2.2 Update `gitsigns.lua` with NvChad-style symbols and catppuccin integration
- [ ] 2.3 Update `telescope.lua` with NvChad layout (ascending sort, top prompt, rounded borders)

## 3. Theme Integration

- [ ] 3.1 Verify catppuccin provides highlight groups for all new plugins
- [ ] 3.2 Add `nvim-web-devicons` dependency if needed
- [ ] 3.3 Test all UI components render with correct catppuccin colors

## 4. Source Module Sync

- [ ] 4.1 Copy all new/modified plugin files to `.dotfiles/zsh/modules/nvim/data/lua/plugins/`
- [ ] 4.2 Verify runtime config matches source module

## 5. Verification

- [ ] 5.1 Restart nvim and verify all plugins load without errors
- [ ] 5.2 Test bufferline tab navigation and close buttons
- [ ] 5.3 Test indent guides appear correctly
- [ ] 5.4 Test which-key shows hints on key bindings
- [ ] 5.5 Test alpha dashboard appears on startup
- [ ] 5.6 Test lualine shows mode colors and git info
- [ ] 5.7 Test gitsigns show correct symbols
- [ ] 5.8 Test telescope layout and styling
- [ ] 5.9 Run `:checkhealth` to verify no plugin errors
