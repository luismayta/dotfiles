## Why

The herdr Zsh module at `zsh/modules/herdr/` exposes workspace helpers (`hrd` for switching, `hrdk` for killing) but has no dedicated wrapper for the `herdr worktree` subcommand. Worktrees are herdr workspaces with git checkout provenance — they let you work on multiple branches simultaneously via `~/.codi/worktrees/`. Without a helper, users must type the full `herdr worktree create --cwd . --branch <name>` command each time, breaking the ergonomic pattern established by `hrd`/`hrdk`.

## What Changes

- **New `hrdw::*` subcommand functions** in `pkg/helper.zsh`: `hrdw::create`, `hrdw::list`, `hrdw::open`, `hrdw::remove` — each wraps the corresponding `herdr worktree` subcommand, with branch auto-prefixing (`feature/`), fzf integration, and error guards
- **New internal functions** in `internal/base.zsh`: `hrd::internal::worktree::*` for worktree listing, creation, navigation, and info queries
- **Alias conflict resolution**: the existing `alias hrd=herdr` in `pkg/alias.zsh` shadows the `hrd()` function in `pkg/helper.zsh` — needs fixing so the function takes precedence and still delegates to the `herdr` binary when needed
- **Sourcing chain**: ensure new functions are loaded through the existing `pkg/main.zsh` → `plugin.zsh` chain

## Capabilities

### New Capabilities

- `herdr-worktree-helper`: Zsh wrapper around `herdr worktree` subcommands — create worktrees from current directory with branch auto-naming, list all worktrees with status, navigate worktrees via fzf, and open existing worktrees

### Modified Capabilities

*(None — this is a new capability, no existing specs are changing.)*

## Impact

- `zsh/modules/herdr/pkg/helper.zsh` — add `hrdw()` function
- `zsh/modules/herdr/internal/base.zsh` — add `hrd::internal::worktree_*` functions
- `zsh/modules/herdr/pkg/alias.zsh` — fix `hrd` alias shadowing the function
- `zsh/modules/herdr/pkg/main.zsh` — verify sourcing chain includes new functions
- `zsh/modules/herdr/plugin.zsh` — verify plugin-level sourcing is correct
- `zsh/modules/herdr/data/config.toml` — may need worktree directory config
