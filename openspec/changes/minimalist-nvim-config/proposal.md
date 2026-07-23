# Minimalist nvim Config

## Why

Our LazyVim v8 config has grown to 42+ plugins with redundant imports, duplicate format-on-save implementations (6+ variants), and conflicting keymaps. Despite cleaning up 7 disabled plugins, the framework remains heavy and hard to reason about.

**Key problems:**
- **Bloat**: LazyVim's "everything included" philosophy means we load things we don't use
- **Confusion**: Multiple plugins doing the same thing (e.g., conform.nvim vs efm vs format-on-save.nvim)
- **Opacity**: Hard to understand what LazyVim layers on top of raw nvim

**Opportunity**: Nvim 0.12 ships with built-in features that replace several plugins (inlay hints, snippets, ui2). The reference config (Sin-cy/dotfiles) demonstrates a clean, minimal approach with ~27 focused plugins.

## What Changes

- **BREAKING**: Remove LazyVim framework dependency entirely
- **BREAKING**: Replace LazyVim's option/keymap layer with hand-rolled `core/options.lua` and `core/keymaps.lua`
- **BREAKING**: Restructure plugin directory from `plugins/{enabled,disabled,lsp,editor,ui}/` to flat `plugins/` (one file per plugin)
- **New**: Unified format-on-save system (single implementation via conform.nvim)
- **New**: Clean LSP setup using `lsp/` subdirectory with mason-lspconfig
- **Remove**: 15+ redundant plugins (see Design section)
- **Keep**: catppuccin, telescope, treesitter, gitsigns, which-key, mini.nvim, mason

## Capabilities

### New Capabilities
- `plugin-structure`: Flat plugin organization with clear ownership
- `formatting`: Single format-on-save implementation
- `lsp-setup`: Clean LSP configuration with mason-lspconfig
- `keymap-system`: Organized keymaps without LazyVim's leader-key prefix logic

### Modified Capabilities
- (none — this is a rewrite, not incremental changes)

## Impact

- **Affected code**: Entire `zsh/modules/nvim/data/lua/` directory
- **Dependencies**: LazyVim removed; lazy.nvim kept as plugin manager
- **Plugins removed**: dressing.nvim, telescope-ui-select, bufferline.nvim, lualine, noice.nvim, mason-lspconfig (consolidated), none-ls, format-on-save.nvim, efm, project.nvim, and 6+ more
- **Plugins kept**: catppuccin, telescope, treesitter, gitsigns, which-key, mini.nvim, mason, conform.nvim, nvim-lspconfig, blink.cmp, luasnip
- **Risk**: Medium — requires manual keymap re-binding and LSP configuration
