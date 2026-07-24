## Why

In Neovim, the `<C-x>` key is mapped to `opencode.select()` (opencode.lua:15), but `<C-x>` is also used as a prefix for window management keybindings (`<C-x>1`, `<C-x>2`, `<C-x>3`, `<C-x>h/j/k/l`, etc.) defined in `config/keymaps.lua:47-49`. The opencode mapping fires immediately on `<C-x>`, intercepting the prefix before the window management combinations can be recognized. This breaks all `<C-x>*` window navigation and management shortcuts.

## What Changes

- Remap the opencode activation key from `<C-x>` to a non-conflicting combination
- Preserve all existing `<C-x>*` window management keybindings
- Ensure the new opencode keybinding is ergonomic and doesn't conflict with other plugins or native Vim commands

## Capabilities

### New Capabilities

- `opencode-keybinding`: Remap the opencode activation key to avoid conflicts with window management prefix

### Modified Capabilities

<!-- None — no existing specs are changing requirements -->

## Impact

- **Neovim config**: `opencode.lua` keybinding definition
- **Window management**: All `<C-x>*` keybindings in `config/keymaps.lua` will regain functionality
- **User workflow**: Slight adjustment to muscle memory for opencode activation
