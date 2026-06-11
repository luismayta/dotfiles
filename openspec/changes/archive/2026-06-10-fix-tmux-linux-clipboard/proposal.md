## Why

### Linux clipboard quoting bug
The tmux Linux clipboard integration in `zsh/modules/tmux/data/sync/tmux/linux.conf` uses a deeply nested `if-shell` chain to detect clipboard tools (pbcopy → xclip → wl-copy). The nested quoting on line 22 produces a "too many arguments" error in tmux, breaking the fallback path entirely. When neither pbcopy nor xclip is available, the `display-message` fallback fails instead of showing a helpful message.

### macOS clipboard modernization
`zsh/modules/tmux/data/sync/tmux/osx.conf` contains legacy patterns from older tmux versions (pre-2.6) that are unnecessary on tmux 3.5a:
- `default-command` with `reattach-to-user-namespace -l $SHELL` — forces a deprecated wrapper on ALL panes, not just clipboard
- `set-clipboard off` — blocks modern OSC 52 clipboard passthrough
- `mode-keys vi` — redundant with the global config in `.tmux.conf`

## What Changes

- **linux.conf**: Restructure the nested `if-shell` clipboard detection chain to use curly brace `{}` syntax, eliminating quoting conflicts
- **osx.conf**: Remove legacy workarounds, set `set-clipboard external`, remove redundant `mode-keys vi`
- **.tmux.conf**: Update OS-specific `if-shell` source-file lines to curly brace syntax for consistency

## Capabilities

### New Capabilities
- `clipboard-detection`: Reliable cross-tool clipboard detection for tmux on Linux with correct fallback behavior
- `macos-clipboard`: Streamlined macOS clipboard configuration without legacy workarounds

### Modified Capabilities
- None. All changes are internal refactors with identical observable behavior.

## Impact

- **`zsh/modules/tmux/data/sync/tmux/linux.conf`**: Rewrite of `if-shell` chain to curly braces
- **`zsh/modules/tmux/data/sync/tmux/osx.conf`**: Remove `default-command`, `set-clipboard off`, redundant `mode-keys vi`; update copy/paste helpers
- **`zsh/modules/tmux/data/conf/.tmux.conf`**: OS-specific source lines use curly braces
- **Behavior**: Fully backward compatible — no user-facing changes
