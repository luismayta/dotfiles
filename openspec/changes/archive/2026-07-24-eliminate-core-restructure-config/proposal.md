## Why

The Neovim config has two directories for configuration: `core/` and `config/`. This creates confusion and duplication. `core/` only contains options + keymaps + a 2-line init.lua, while `config/` already has options, keymaps, autocmds, and lazy setup. Having keymaps in `core/` (loaded) and `config/` (dead code) caused `<C-x>` bindings to silently not work for weeks. Eliminating `core/` consolidates all configuration in one place.

## What Changes

- **BREAKING**: Delete `core/` directory entirely (init.lua, options.lua, keymaps.lua)
- Merge `core/options.lua` content into `config/options.lua` (resolve conflicts: updatetime, scrolloff, wrap, foldmethod)
- Restore `config/keymaps.lua` with the merged keymaps from `core/keymaps.lua`
- Update `init.lua` to require `config.options` and `config.keymaps` directly (remove `require "core"`)
- Update dotfiles repo copy at `zsh/modules/nvim/data/lua/` to match

## Capabilities

### New Capabilities

- `config-consolidation`: Single directory for all Neovim configuration (options, keymaps, autocmds, lazy)

### Modified Capabilities

None — this is a structural refactor, not a behavior change.

## Impact

- `~/.config/nvim/init.lua` — remove `require "core"`, add requires for config files
- `~/.config/nvim/lua/core/` — delete entirely
- `~/.config/nvim/lua/config/options.lua` — merge from core, resolve conflicts
- `~/.config/nvim/lua/config/keymaps.lua` — restore with merged keymaps
- `~/.dotfiles/zsh/modules/nvim/data/lua/` — mirror all changes
