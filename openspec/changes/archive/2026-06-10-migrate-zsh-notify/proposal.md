## Why

Migrate `luismayta/zsh-notify` from an external antidote-managed zsh plugin into a first-class module under `zsh/modules/notify/`. This plugin provides desktop notifications with configurable sound themes and terminal integration. Migrating eliminates an external dependency and preserves the audio/asset structure within the monorepo.

## What Changes

- Create `zsh/modules/notify/` with ~20+ files following the canonical architecture — config/, internal/, pkg/ with OS dispatch
- Port all `notify::*` namespaced functions
- Copy audio assets (`assets/` and `sounds/` directories with 2 sound themes: default and piano)
- Remove `luismayta/zsh-notify` line from `zsh/zsh_plugins.txt`
- Module root path variable: `ZSH_NOTIFY_PATH`
- No change to `zshenv` or `zshrc` module loader

## Capabilities

### New Capabilities
- `notify-module`: Desktop notification system with terminal output integration, sound themes, and OS dispatch as an internal zsh module

### Modified Capabilities
- None

## Impact

- `zsh/zsh_plugins.txt`: remove one line
- New directory `zsh/modules/notify/` with ~20+ files + assets/ and sounds/ directories
- No behavioral change — all `notify::*` functions remain available