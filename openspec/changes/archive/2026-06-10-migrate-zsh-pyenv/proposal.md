## Why

Migrate `luismayta/zsh-pyenv` from an external antidote-managed zsh plugin into a first-class module under `zsh/modules/pyenv/`, following the canonical module structure established by `zsh/modules/core/`. This eliminates an external dependency, enables direct maintenance, and unifies the pyenv configuration, internal logic, and public API into the same architecture as brew, rust, fnm, and goenv modules.

## What Changes

- Create `zsh/modules/pyenv/` with 17+ files following the canonical 3-layer architecture (config/, internal/, pkg/) with OS dispatch for darwin and linux
- Port all `pyenv::*` namespaced functions from the external repo
- Remove `luismayta/zsh-pyenv` line from `zsh/zsh_plugins.txt`
- Module root path variable: `ZSH_PYENV_PATH` (preferred pattern) or `PYENV_PATH` (safe since no env var collision)
- No change to `zshenv` or `zshrc` module loader

## Capabilities

### New Capabilities
- `pyenv-module`: Pyenv Python version management as an internal zsh module — path setup, version operations, cache configuration

### Modified Capabilities
- None

## Impact

- `zsh/zsh_plugins.txt`: remove one line
- New directory `zsh/modules/pyenv/` with ~17 files
- No behavioral change — all `pyenv::*` functions remain available
