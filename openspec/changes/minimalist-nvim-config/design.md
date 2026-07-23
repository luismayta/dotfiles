# Design: Minimalist nvim Config

## Context

Our current config uses LazyVim v8 as a framework, which provides a "batteries included" experience but has grown unwieldy:
- **42+ plugin imports** with 15+ disabled/unused
- **6+ format-on-save implementations** (conform.nvim, efm, format-on-save.nvim, etc.)
- **Conflicting keymaps** from LazyVim's defaults + our overrides
- **Redundant plugins** doing the same thing (e.g., neo-tree + nvim-tree, noice + native UI)

The reference config (Sin-cy/dotfiles) demonstrates a clean approach:
- **27 focused plugins**, each in its own file
- **No LazyVim** — just lazy.nvim as the plugin manager
- **Clear separation**: `core/` (options, keymaps), `plugins/` (one file per plugin)
- **Modern nvim features**: uses `vim._core.ui2` for UI enhancements

## Goals / Non-Goals

**Goals:**
- Remove LazyVim dependency entirely
- Keep essential functionality: LSP, completion, treesitter, telescope, git signs
- Single format-on-save implementation (conform.nvim)
- Clean, understandable config that's easy to modify
- Preserve catppuccin theme and keybindings we actually use

**Non-Goals:**
- Rewrite everything from scratch (reuse good plugin configs)
- Add new features (this is a consolidation, not expansion)
- Change leader key from space
- Remove plugins we actively use (just remove redundant ones)

## Decisions

### 1. Plugin Manager: Keep lazy.nvim (no change)
**Rationale**: LazyVim is the framework on top; lazy.nvim itself is excellent and well-maintained.
**Alternative considered**: Packer.nvim — abandoned, not worth switching.

### 2. Remove LazyVim Framework
**What we lose**: LazyVim's default configs, keymaps, option presets, UI customizations.
**What we gain**: Full control, no conflicts, faster startup, easier debugging.
**Migration**: Hand-roll `core/options.lua` and `core/keymaps.lua` based on our actual usage (reference: Sin-cy's core/).

### 3. Plugin Structure: Flat `plugins/` Directory
**Current**: Nested `plugins/{ai,dap,lang,lsp,navigation,text,tools,ui}/` with complex imports.
**New**: Flat `plugins/` with one file per plugin (e.g., `plugins/telescope.lua`, `plugins/lsp.lua`).
**Rationale**: Matches reference config, easier to find and maintain.

### 4. Consolidate Format-on-Save
**Current**: 6+ implementations (conform.nvim, efm, format-on-save.nvim, mason-conform, etc.)
**New**: Single conform.nvim with `<leader>f` keymap (reference: formatting.lua).
**Rationale**: Conform.nvim is the modern standard, handles all formatters.

### 5. LSP Setup: mason-lspconfig + nvim-lspconfig
**Current**: LazyVim's LSP layer + mason-tools + custom overrides.
**New**: Direct mason-lspconfig setup with explicit server list (reference: lsp/).
**Rationale**: Clearer ownership, easier to add/remove servers.

### 6. Remove These Plugins (15+)
| Plugin | Reason for Removal |
|--------|-------------------|
| dressing.nvim | nvim 0.10+ has built-in `vim.ui.select` |
| telescope-ui-select | Redundant with dressing.nvim removal |
| bufferline.nvim | We don't use tabs, use snacks tabBar instead |
| noice.nvim | Use native `vim._core.ui2` instead |
| project.nvim | Not actively used |
| none-ls | Use conform.nvim + nvim-lspconfig directly |
| format-on-save.nvim | Use conform.nvim |
| efm | Use conform.nvim |
| mason-conform | Use mason-lspconfig directly |
| mason-null-ls | Use mason-lspconfig directly |
| mason-nvim-dap | Not actively debugging |
| dap-ui | Not actively debugging |
| dap-virtual-text | Not actively debugging |
| goto-preview | Use LSP hover/references instead |
| neocomposer | Use native macro recording |
| edgy.nvim | Use snacks.layout or native splits |
| focus.nvim | Not actively used |

### 7. Keep These Plugins (~25)
**Core**: lazy.nvim, plenary.nvim
**Theme**: catppuccin
**Editor**: treesitter, telescope, gitsigns, which-key, mini.nvim, vim-tmux-navigator
**LSP**: nvim-lspconfig, mason-lspconfig, mason.nvim
**Completion**: blink.cmp, luasnip, cmp-nvim-lsp
**Formatting**: conform.nvim
**UI**: nvim-web-devicons, lualine (or snacks.winbar), edarc (or native statusline)
**Git**: neogit or fugitive (pick one)
**Misc**: comment.nvim, todo-comments.nvim, undotree

## Risks / Trade-offs

| Risk | Mitigation |
|------|-----------|
| Losing LazyVim's battle-tested defaults | Reference config (Sin-cy) has been using this approach successfully |
| Keymap conflicts during migration | Test incrementally, keep which-key for discoverability |
| Missing a plugin we actually use | Grep for `<leader>` keymaps in old config, preserve essential ones |
| LSP config complexity | Start with minimal servers (lua, typescript, go, rust), add as needed |

## Migration Plan

1. **Backup**: Create branch `feature/HAD-89-minimalist-nvim` from current state
2. **Phase 1 - Core**: Create `core/options.lua` and `core/keymaps.lua` from reference
3. **Phase 2 - Plugin Structure**: Create flat `plugins/` directory, migrate one plugin at a time
4. **Phase 3 - LSP**: Set up mason-lspconfig + lspconfig directly
5. **Phase 4 - Formatting**: Configure conform.nvim as single source
6. **Phase 5 - Cleanup**: Remove LazyVim dependency, delete old structure
7. **Phase 5 - Verify**: Test all keybindings, ensure LSP works, format-on-save works

## Open Questions

- **Statusline**: Use lualine (keep) or snacks.winbar (newer, lighter)?
- **Git integration**: Keep neogit or switch to fugitive?
- **File explorer**: Keep neo-tree or switch to oil.nvim (reference uses oil)?
