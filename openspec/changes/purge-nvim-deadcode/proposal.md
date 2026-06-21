## Why

The nvim module has accumulated significant dead code and deprecated patterns after the recent refactor to composable jasper modules. Multiple config files are orphaned, Lspsaga commands reference an uninstalled plugin, a mason-lspconfig require is broken, and duplicate mappings cause subtle conflicts. Cleaning this up reduces maintenance burden, eliminates startup scan overhead, and prevents runtime errors.

## What Changes

- Delete 7 orphaned `configs/*.lua` files that are no longer required by any plugin spec (`scrollview.lua` is kept — still referenced in `spec/ui/ui.lua`)
- Delete `plugins/dankcolors.lua` (completely orphaned 92-line custom colorscheme)
- Consolidate LSP keymaps into `jasper/keymaps.lua` as single source of truth — remove duplicate `setup_keymaps` from `jasper/lsp.lua` and delegate to `keymaps.lua` instead
- Remove dead Lspsaga commands from `chadrc.lua` and fix legacy `nvchad_ui` reference
- Fix broken `require("configs.mason-lspconfig")` in `spec/lsp/mason.lua` — fall back to `configs.mason`
- Remove duplicate telescope mappings from `spec/ui/ui.lua` (superseded by jasper.telescope wrappers)
- Fix `NVIM_FILE_SETTINGS` path in `config/base.zsh` to point to correct `lua/options.lua`
- Remove `NVIM_ROOT_PATH` duplicate variable from `config/base.zsh`
- Remove `colorify` mapping from `mappings.lua` (plugin not installed)
- Resolve duplicate BufWritePre format-on-save between `jasper/lsp.lua` and `jasper/autocmds.lua`

## Capabilities

### New Capabilities
- `orphaned-config-cleanup`: Delete config files that exist on disk but are no longer required by any plugin spec
- `chadrc-dead-code-purge`: Remove Lspsaga mappings and fix legacy references in chadrc.lua
- `broken-mason-setup`: Fix the missing mason-lspconfig require that breaks LSP auto-install
- `keymap-duplication-resolution`: Eliminate duplicate/conflicting keymaps across chadrc, mappings.lua, and spec files
- `format-on-save-consolidation`: Remove duplicate BufWritePre format autocmd
- `jasper-keymaps-consolidation`: Make `jasper/keymaps.lua` the single source of truth for LSP keymaps — remove the duplicate `setup_keymaps` from `jasper/lsp.lua` and delegate to `keymaps.lua`
- `nvim-zsh-config-fixes`: Fix broken `NVIM_FILE_SETTINGS` path and remove duplicate `NVIM_ROOT_PATH`

### Modified Capabilities
- *(none — this change removes dead code without altering existing requirements)*

## Impact

- **12+ files deleted** from the repository
- `chadrc.lua` loses Lspsaga mappings (already non-functional)
- `spec/lsp/mason.lua` changes its config source
- `spec/ui/ui.lua` loses duplicate telescope mappings
- `jasper/lsp.lua` or `jasper/autocmds.lua` loses one format-on-save autocmd
- `config/base.zsh` path fix for NVIM_FILE_SETTINGS
- Faster startup due to fewer lazy.nvim imports scanned
