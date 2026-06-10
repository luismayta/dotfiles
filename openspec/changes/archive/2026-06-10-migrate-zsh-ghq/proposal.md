## Why

Migrate `hadenlabs/zsh-ghq` from an external antidote-managed zsh plugin into a first-class module under `zsh/modules/ghq/`. This plugin provides ghq (repository management) integration, cookiecutter templates, and helper functions. Migrating it eliminates an external dependency and standardizes its architecture.

## What Changes

- Create `zsh/modules/ghq/` with ~20+ files following the canonical architecture — config/, internal/, pkg/ with OS dispatch
- Port all `ghq::*` namespaced functions (~18 functions) plus cookiecutter configuration
- Remove `hadenlabs/zsh-ghq` line from `zsh/zsh_plugins.txt`
- Module root path variable: `ZSH_GHQ_PATH`
- No change to `zshenv` or `zshrc` module loader

## Capabilities

### New Capabilities
- `ghq-module`: ghq repository management, cookiecutter integration, and helper functions as an internal zsh module

### Modified Capabilities
- None

## Impact

- `zsh/zsh_plugins.txt`: remove one line
- New directory `zsh/modules/ghq/` with ~20+ files
- No behavioral change — all `ghq::*` functions remain available