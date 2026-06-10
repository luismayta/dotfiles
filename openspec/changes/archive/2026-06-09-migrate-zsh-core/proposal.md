## Why

Dotfiles currently depend on `hadenlabs/zsh-core` as an external antidote plugin. This creates tight coupling to an external repo for core shell functionality that can now live in the `modules/` convention. Migrating eliminates the external dependency, removes the antidote load of zsh-core, and lets dotfiles own all shell behavior directly.

## What Changes

- Migrate entire `hadenlabs/zsh-core` into a single `zsh/modules/core/plugin.zsh` module
- Remove `hadenlabs/zsh-core` from `zsh_plugins.txt` (antidote bundle)
- Keep existing `mod/` unchanged — the module is additive

## Capabilities

### New Capabilities

- `core`: Single module housing all zsh-core functionality — env vars (ANDROID_HOME, CORE_MESSAGE_*), brew/cargo auto-install, messaging functions, fzf helpers (fkill, fa, fcs, etc.), Docker CLI wrappers, eza aliases, Linux clipboard helpers, git URL parsing, and rsync project backup

### Modified Capabilities

- *(none)*

## Impact

- `zsh/modules/core/` — new module directory with `plugin.zsh` entry point
- `zsh/zsh_plugins.txt` — remove `hadenlabs/zsh-core` line
- `mod/` — unchanged
