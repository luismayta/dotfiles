## Why

Migrate `hadenlabs/zsh-git` from an external antidote-managed zsh plugin into a first-class module under `zsh/modules/git/`. This external plugin provides git alias shortcuts, helper functions, and git-flow CLI scripts. Migrating it eliminates an external dependency and aligns with the monorepo module architecture.

## What Changes

- Create `zsh/modules/git/` with ~25+ files following the canonical architecture — config/, internal/, pkg/ with OS dispatch
- Port all `git::*` namespaced functions plus CLI scripts from `bin/` directory
- Remove `hadenlabs/zsh-git` line from `zsh/zsh_plugins.txt`
- Module root path variable: `ZSH_GIT_PATH`
- No change to `zshenv` or `zshrc` module loader

## Capabilities

### New Capabilities
- `git-module`: Git alias management, helper functions, and git-flow integration as an internal zsh module

### Modified Capabilities
- None

## Impact

- `zsh/zsh_plugins.txt`: remove one line
- New directory `zsh/modules/git/` with ~25+ files (config/, internal/, pkg/ + CLI scripts)
- No behavioral change — all `git::*` functions remain available
