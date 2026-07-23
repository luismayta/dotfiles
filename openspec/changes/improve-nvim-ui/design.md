## Context

Our nvim config (post-minimalist migration) has solid plugin infrastructure but basic UI. We migrated from LazyVim to a clean 18-plugin setup with lazy.nvim, catppuccin theme, and proper nvim 0.12 API usage. The current UI is functional but lacks visual polish and discoverability features.

**Current state**:
- 18 plugins total
- lualine.lua: Basic statusline (mode, branch, diagnostics, filetype, location)
- gitsigns.lua: Basic git signs with current_line_blame
- telescope.lua: Custom keybindings, basic layout
- treesitter.lua: Language support with indent/highlight

**Constraints**:
- Must use lazy.nvim (not NvChad framework)
- Must keep catppuccin theme
- Must sync changes to `.dotfiles/zsh/modules/nvim/data/`
- Must maintain nvim 0.12 API compatibility

**Stakeholders**: User (Luchex) — daily nvim user, wants polished but not bloated UI

## Goals / Non-Goals

**Goals:**
- Enhanced statusline with NvChad-style mode colors and better section separation
- Tab-like buffer navigation with close buttons and diagnostics
- Visual indent guides with scope highlighting
- Which-key for key binding discoverability
- Minimal startup dashboard
- Better telescope layout and styling
- All UI components use consistent catppuccin highlight groups

**Non-Goals:**
- Full NvChad framework adoption (we keep lazy.nvim)
- New language servers or completion plugins
- File explorer changes (neo-tree already configured)
- Autopairs or snippet changes
- Keybinding overhaul (only add which-key hints)

## Decisions

### 1. Bufferline vs Native Tabs
**Decision**: Use `akinsho/bufferline.nvim`
**Rationale**: Provides tab-like buffer navigation with close buttons, diagnostics, and git status. Native tabs are limited and don't show buffer state.
**Alternatives considered**: 
- Native `:tabnew` — too basic, no buffer management
- `bufdelete.nvim` — only close buffers, no UI

### 2. Indent Guides Plugin
**Decision**: Use `lukas-reineke/indent-blankline.nvim`
**Rationale**: NvChad uses this, proven performance, scope highlighting, and catppuccin integration.
**Alternatives considered**:
- `mini.indentscope` — lighter but less configurable
- Native `list` chars — no scope highlighting

### 3. Which-key Integration
**Decision**: Use `folke/which-key.nvim`
**Rationale**: Shows key binding hints on delay, improves discoverability. NvChad includes this.
**Alternatives considered**:
- Manual keybinding docs — maintenance burden
- No hints — current users know bindings, but new users struggle

### 4. Dashboard Plugin
**Decision**: Use `goolord/alpha-nvim`
**Rationale**: Minimal startup screen with recent files and shortcuts. NvChad uses this pattern.
**Alternatives considered**:
- `dashboard-nvim` — more complex, less minimal
- No dashboard — direct to empty buffer

### 5. Telescope Layout
**Decision**: Adopt NvChad's telescope config (ascending sort, top prompt, rounded borders)
**Rationale**: Better visual hierarchy, prompt at top is more natural for search.
**Alternatives considered**:
- Keep current layout — functional but less polished
- Custom layout — reinventing the wheel

### 6. Git Signs Style
**Decision**: Use NvChad's git sign symbols (󰍵, 󱕖) with catppuccin integration
**Rationale**: Consistent with NvChad's visual language, better symbols than default.
**Alternatives considered**:
- Keep current signs — functional but less polished
- Custom symbols — reinventing the wheel

## Risks / Trade-offs

- **Performance**: Adding 4 plugins increases startup time → Mitigation: All plugins use lazy loading (event/cmd/keys)
- **Complexity**: More config files to maintain → Mitigation: Each plugin is self-contained, follows existing pattern
- **Theme integration**: Catppuccin must provide highlight groups for all new plugins → Mitigation: Catppuccin has official support for all chosen plugins
- **Source sync**: Changes must be mirrored to dotfiles module → Mitigation: Manual sync step after implementation
- **Keybinding conflicts**: Which-key may conflict with existing bindings → Mitigation: Which-key only shows hints, doesn't override bindings

## Migration Plan

1. **Phase 1**: Add new plugins (bufferline, indent-blankline, which-key, alpha)
2. **Phase 2**: Enhance existing plugins (lualine, gitsigns, telescope)
3. **Phase 3**: Configure theme integration and test
4. **Phase 4**: Sync to source module and commit

**Rollback**: Remove plugin files from `~/.config/nvim/lua/plugins/` and restart nvim. No database or config schema changes.

## Open Questions

- Should we add `nvim-web-devicons` explicitly or rely on mini.icons?
- Do we want to customize which-key hints or use defaults?
- Should alpha-nvim show git status or keep it minimal?
