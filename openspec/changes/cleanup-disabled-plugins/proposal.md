## Why

During the nvim 0.12 migration, we identified 7 plugins that are already disabled (`enabled = false`) in the config. These plugins are dead code that adds maintenance burden and potential confusion. Removing them simplifies the codebase and reduces cognitive load when navigating the plugin configuration.

Additionally, nvim 0.12 introduces built-in alternatives for some of these plugins, making them redundant even if they were enabled.

## What Changes

- **Remove** 7 disabled plugin files entirely:
  - `navigation/lsp-signature.lua` (lsp_signature.nvim)
  - `navigation/hover.lua` (hover.nvim)
  - `tools/searchbox.lua` (searchbox.nvim)
  - `tools/fine-cmdline.lua` (fine-cmdline.nvim)
  - `ui/dropbar.lua` (dropbar.nvim)
  - `ui/screenkey.lua` (screenkey.nvim)
  - Remove `indent-blankline.nvim` block from `ui/ui.lua`

- **Verify** nvim 0.12 built-in alternatives work correctly:
  - `vim.lsp.buf.signature_help()` replaces lsp_signature.nvim
  - `vim.lsp.buf.hover()` replaces hover.nvim
  - Built-in `/` search replaces searchbox.nvim
  - Built-in `:` command line replaces fine-cmdline.nvim

## Capabilities

### New Capabilities

- `plugin-cleanup`: Removal of disabled plugin files and configuration blocks

### Modified Capabilities

<!-- No existing capabilities are being modified -->

## Impact

- **Files removed**: 6 plugin files deleted, 1 plugin block removed from ui.lua
- **Dependencies**: No dependency changes (plugins were already disabled)
- **LSP behavior**: No change (built-in alternatives already available in nvim 0.12)
- **Keymaps**: No change (disabled plugins had no active keymaps)
- **Risk**: Low - removing dead code only