## 1. Scaffold

- [x] 1.1 Create `zsh/modules/pyenv/` directory structure (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/pyenv/plugin.zsh` entry point

## 2. Configuration layer

- [x] 2.1 Create `zsh/modules/pyenv/config/base.zsh` — set `ZSH_PYENV_PATH` and pyenv defaults
- [x] 2.2 Create `zsh/modules/pyenv/config/main.zsh` — OS dispatch
- [x] 2.3 Create `zsh/modules/pyenv/config/osx.zsh` — macOS pyenv paths
- [x] 2.4 Create `zsh/modules/pyenv/config/linux.zsh` — Linux pyenv paths

## 3. Internal layer

- [x] 3.1 Create `zsh/modules/pyenv/internal/base.zsh` — internal helper functions
- [x] 3.2 Create `zsh/modules/pyenv/internal/main.zsh` — internal dispatch
- [x] 3.3 Create `zsh/modules/pyenv/internal/osx.zsh` — macOS internal helpers
- [x] 3.4 Create `zsh/modules/pyenv/internal/linux.zsh` — Linux internal helpers

## 4. Public API layer

- [x] 4.1 Create `zsh/modules/pyenv/pkg/base.zsh` — all `pyenv::*` public functions
- [x] 4.2 Create `zsh/modules/pyenv/pkg/main.zsh` — public API dispatch
- [x] 4.3 Create `zsh/modules/pyenv/pkg/osx.zsh` — macOS-specific public functions
- [x] 4.4 Create `zsh/modules/pyenv/pkg/linux.zsh` — Linux-specific public functions

## 5. Module metadata

- [x] 5.1 Create `zsh/modules/pyenv/init.zsh`
- [x] 5.2 Create `zsh/modules/pyenv/LICENSE`
- [x] 5.3 Create `zsh/modules/pyenv/README.md`

## 6. Integration

- [x] 6.1 Remove `luismayta/zsh-pyenv` from `zsh/zsh_plugins.txt`

## 7. Verify

- [x] 7.1 Run `task validate` for shellcheck and codespell
- [x] 7.2 Confirm all `pyenv::*` functions are defined