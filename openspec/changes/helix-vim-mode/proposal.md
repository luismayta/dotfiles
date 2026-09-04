## Why

Helix editor uses a selection-first editing philosophy that differs from Vim's operator-first approach. Users transitioning from Vim need familiar keybindings and muscle memory to be productive. Adding vim-mode support with a customizable leader key (',') reduces the learning curve and improves adoption for Vim users.

## What Changes

- Add vim-mode keybindings to Helix configuration (`data/config.toml`)
- Implement ',' as the leader key for quick command sequences
- Create common vim-style shortcuts: `jj`/`jk` to exit insert mode, `w`/`b`/`e` for word navigation, `dd`/`yy`/`p` for line operations
- Add leader key sequences: `,w` (save), `,q` (quit), `,e` (file picker), `,f` (find)
- Preserve Helix's native selection-mode benefits while offering vim familiarity

## Capabilities

### New Capabilities

- `helix-vim-mode`: Vim-mode keybindings and leader key configuration for Helix editor

### Modified Capabilities

(none - this is a new capability)

## Impact

- **Configuration files**: `zsh/modules/helix/data/config.toml` - adds `[keys.normal]`, `[keys.insert]`, `[keys.select]` sections
- **User experience**: Vim users get familiar keybindings; Helix native users can opt-out via config
- **No breaking changes**: Existing Helix functionality preserved; vim-mode is additive
