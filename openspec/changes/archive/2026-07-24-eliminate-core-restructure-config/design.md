## Context

Neovim config currently splits configuration across two directories:
- `core/` (loaded): init.lua, options.lua, keymaps.lua
- `config/` (partially loaded): lazy.lua, options.lua, keymaps.lua (deprecated), autocmds.lua

`init.lua` loads `config.lazy` then `core` (which loads core.options + core.keymaps). The `config/options.lua` and `config/keymaps.lua` are never loaded — dead code that caused the `<C-x>` keybinding issue.

## Goals / Non-Goals

**Goals:**
- Single directory (`config/`) for all Neovim configuration
- Eliminate `core/` entirely
- Resolve option conflicts between core/options.lua and config/options.lua
- Maintain all existing keymaps and behaviors

**Non-Goals:**
- Changing keybinding behaviors (just consolidating)
- Restructuring plugin layout
- Adding new features

## Decisions

### 1. Merge strategy for conflicting options

| Setting | core (loaded) | config (dead) | Decision |
|---------|---------------|---------------|----------|
| `updatetime` | 50 | 100 | Keep 50 (faster cursor hold) |
| `scrolloff` | 8 | 10 | Keep 8 (less aggressive) |
| `wrap` | false | true | Keep false (user's active preference) |
| `foldmethod` | manual | expr (treesitter) | Keep manual (user chose this) |

**Rationale**: `core/options.lua` is what's actually loaded and working. `config/options.lua` was never active. Keep the working values.

### 2. Keymaps: use the merged version from core/keymaps.lua

The recently merged `core/keymaps.lua` (122 lines) is the single source of truth. Move it to `config/keymaps.lua`.

### 3. init.lua structure

```lua
-- [[ Bootstrap lazy.nvim ]]
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require "config.lazy"
require "config.options"
require "config.keymaps"
```

No more `require "core"` — direct requires to config/.

### 4. autocmds.lua stays as-is

Currently empty (just augroup definition). Keep it for future use.

## Risks / Trade-offs

- **Risk**: Breaking existing config if merge misses something → Mitigation: Verify all settings from both files are present in merged output
- **Risk**: Dotfiles repo out of sync → Mitigation: Update both runtime and dotfiles in same change
