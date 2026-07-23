## Why

Our nvim config has solid plugin infrastructure but lacks UI polish. NvChad's UI provides superior visual consistency (statusline, bufferline, indent guides, git signs) with minimal performance overhead. We want to adopt NvChad's UI patterns while keeping our existing plugin architecture (lazy.nvim, not NvChad framework).

## What Changes

- **Enhanced statusline** (lualine): NvChad-style with mode colors, git branch, diagnostics, file info, and location
- **Bufferline**: Tab-like buffer navigation with close buttons and diagnostics
- **Indent guides**: Visual indent levels with scope highlighting
- **Improved git signs**: NvChad-style symbols and color integration
- **Telescope UI**: Enhanced layout with ascending sort, rounded borders, and better prompts
- **Which-key**: Key binding hints for discoverability
- **Dashboard**: Minimal startup screen (alpha.nvim)
- **Theme integration**: Catppuccin with proper highlight groups for all UI components

## Capabilities

### New Capabilities
- `statusline-ui`: Enhanced statusline with NvChad-style mode colors, git info, and diagnostics
- `bufferline-ui`: Tab-like buffer navigation with close buttons and diagnostics
- `indent-guides`: Visual indent level guides with scope highlighting
- `dashboard-ui`: Minimal startup dashboard

### Modified Capabilities
- `gitsigns-config`: Enhanced git signs with NvChad-style symbols
- `telescope-ui`: Improved layout and prompt styling
- `theme-integration`: Catppuccin highlight groups for all UI components

## Impact

- **Plugins modified**: lualine.lua, gitsigns.lua, telescope.lua, treesitter.lua
- **New plugins**: bufferline.nvim, indent-blankline.nvim, which-key.nvim, alpha-nvim
- **Dependencies**: nvim-web-devicons, catppuccin theme
- **Config**: All new UI plugins need proper lazy.nvim configuration
- **Source module**: Updates must be synced to `.dotfiles/zsh/modules/nvim/data/`
