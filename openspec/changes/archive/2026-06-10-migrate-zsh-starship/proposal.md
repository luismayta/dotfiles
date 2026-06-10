## Why

Migrate `hadenlabs/zsh-starship` from an external antidote-managed zsh plugin into a first-class module under `zsh/modules/starship/`. This plugin initializes starship prompt and manages starship.toml configuration. Migrating eliminates an external dependency and unifies prompt setup with the module architecture.

## What Changes

- Create `zsh/modules/starship/` with ~12+ files following the canonical architecture — config/, internal/, pkg/ with OS dispatch
- Port all `starship::*` namespaced functions
- Copy `starship.toml` configuration into the module
- Remove `hadenlabs/zsh-starship` line from `zsh/zsh_plugins.txt`
- Module root path variable: `ZSH_STARSHIP_PATH`
- No change to `zshenv` or `zshrc` module loader

## Capabilities

### New Capabilities
- `starship-module`: Starship prompt initialization and configuration management as an internal zsh module

### Modified Capabilities
- None

## Impact

- `zsh/zsh_plugins.txt`: remove one line
- New directory `zsh/modules/starship/` with ~12+ files
- No behavioral change — all `starship::*` functions remain available