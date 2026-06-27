## 1. Setup — Create directory structure

- [x] 1.1 Create `data/lua/jasper/` directory structure
- [x] 1.2 Create `data/scripts/` directory for auto-import script

## 2. Utils layer — Core helpers

- [x] 2.1 Implement `data/lua/jasper/init.lua` as entry point requiring all submodules
- [x] 2.2 Implement `data/lua/jasper/utils.lua` with `map()`, mode-specific wrappers (`nnoremap`, `inoremap`, `vnoremap`, `xnoremap`), `combine_lists()`, and `debounce()`
- [x] 2.3 Implement `data/lua/jasper/keymaps.lua` organizing keymaps by category (navigation, LSP, telescope, git)
- [x] 2.4 Implement `data/lua/jasper/autocmds.lua` with modular auto-command groups

## 3. Composable LSP — On-attach generator

- [x] 3.1 Implement `data/lua/jasper/lsp.lua` with feature-based `on_attach(features)` function
- [x] 3.2 Implement feature blocks: keymaps, diagnostics, formatting, hover
- [x] 3.3 Implement `jasper.lsp.server(name, opts)` convenience builder
- [x] 3.4 Refactor `configs/lspconfig.lua` to use `jasper.lsp.on_attach` instead of inline keymaps
- [x] 3.5 Refactor individual LSP server configs in `plugins/spec/lsp/` to use `jasper.lsp.server()` (not applicable — only mason.lua there, server configs live in lspconfig.lua)

## 4. Telescope picker factory — Layout presets

- [x] 4.1 Implement `data/lua/jasper/telescope.lua` with layout presets (horizontal, vertical, tiny, full)
- [x] 4.2 Implement `jasper.telescope.picker(name, opts)` factory function
- [x] 4.3 Implement convenience wrappers (`ff`, `fg`, `fb`, `fw`, `fr`, `fh`)
- [x] 4.4 Update keymaps in `mappings.lua` to use `jasper.telescope` wrappers

## 5. Plugin import autogen — Script

- [x] 5.1 Implement `data/scripts/auto-import.lua` that scans `plugins/spec/` and validates plugin specs
- [x] 5.2 Implement validation: skip files that don't return a table, print warnings
- [x] 5.3 Generate `plugins/init.lua` with proper lazy.nvim import format
- [x] 5.4 Add `task build` entry in `nvim/Taskfile.yml` to run the auto-import script

## 6. Backup sync — Shell commands

- [x] 6.1 Implement `nvim::backup` in `internal/base.zsh` with `rsync` reverse sync
- [x] 6.2 Implement `--dry-run` flag support (default behavior)
- [x] 6.3 Add `.git/`, `node_modules/`, `.lazy/`, `.cache/` exclude patterns
- [x] 6.4 Expose `nvim::backup` in `pkg/base.zsh`
- [x] 6.5 Enhance `nvim::install` to run Mason post-install
- [x] 6.6 Enhance `nvim::upgrade` to run `Lazy! sync`

## 7. Final integration

- [ ] 7.1 Run auto-import script to regenerate `plugins/init.lua`
- [ ] 7.2 Verify `nvim` starts without errors after all changes
- [x] 7.3 Run `luac -p` syntax check on all new/modified Lua files (all pass)
- [ ] 7.4 Verify keymaps work correctly (LSP, Telescope, general navigation)
- [ ] 7.5 Verify `nvim::sync`, `nvim::backup`, `nvim::install`, `nvim::upgrade` commands
