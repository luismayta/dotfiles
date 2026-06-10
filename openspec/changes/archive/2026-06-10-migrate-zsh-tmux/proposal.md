## Why

The external `hadenlabs/zsh-tmux` plugin manages tmux installation, TPM (Tmux Plugin Manager), tmuxinator setup, and provides UX helpers (session switching, tmuxinator project launcher) with OS-specific clipboard integration for macOS and Linux. Migrating it into `zsh/modules/tmux` removes an external antidote dependency, aligns with the monorepo module loader convention, and brings tmux configuration into the same structure already established by `zsh/modules/rust/` and other migrated modules. This completes the ongoing effort to consolidate all zsh plugins into the monorepo.

## What Changes

- Create `zsh/modules/tmux/` with the canonical module structure (`plugin.zsh`, `config/`, `internal/`, `pkg/`)
- Port all `tmux::*`, `ftm`, `ftmk`, `tx::project`, `edittmux` functions preserving public API exactly
- Adapt source chain from factory-function pattern to direct chained sourcing (rust/brew convention)
- Replace external `ZSH_TMUX_PATH` variable with local `TMUX_PATH`
- Sync config data (`data/conf/.tmux.conf`, `data/sync/tmux/*.conf`, `data/sync/tmuxinator/`) under module's `data/` directory
- Add `data/sync/tmuxinator/templates/` structure for tmuxinator templates

**No breaking changes.** All public functions and aliases remain identical.

## Capabilities

### New Capabilities
- `tmux-module`: tmux installation and TPM setup, tmuxinator management, tmux session management (`ftm`, `ftmk`), tmuxinator project launcher (`tx::project`), tmux config editor (`edittmux`), and OS-specific clipboard configuration for macOS (`reattach-to-user-namespace`) and Linux (`xclip`/`wl-copy`)

### Modified Capabilities

None.

## Impact

- `zsh/modules/tmux/` — new directory (~17 files including data)
- `zsh/zsh_plugins.txt` — remove `hadenlabs/zsh-tmux` line
- `zsh/zshrc` — no change needed (auto-loaded via module glob loop)
- External repo `/Users/luchomayta/projects/src/github.com/hadenlabs/zsh-tmux` — unaffected
