## Why

Migrate `luismayta/zsh-scmbreeze` from an external antidote-managed zsh plugin into a first-class module under `zsh/modules/scmbreeze/`. This plugin provides scm_breeze integration for enhanced git status display and repository shortcuts. Migrating eliminates an external dependency and aligns with the module architecture.

## What Changes

- Create `zsh/modules/scmbreeze/` with ~15+ files following the canonical architecture — config/, internal/, pkg/ with OS dispatch
- Port all `scmbreeze::*` namespaced functions
- Remove `luismayta/zsh-scmbreeze` line from `zsh/zsh_plugins.txt`
- Module root path variable: `ZSH_SCMBREEZE_PATH`
- No change to `zshenv` or `zshrc` module loader

## Capabilities

### New Capabilities
- `scmbreeze-module`: scm_breeze integration for enhanced git status and repository management as an internal zsh module

### Modified Capabilities
- None

## Impact

- `zsh/zsh_plugins.txt`: remove one line
- New directory `zsh/modules/scmbreeze/` with ~15+ files
- No behavioral change — all `scmbreeze::*` functions remain available
