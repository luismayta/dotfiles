## 1. Scaffold

- [x] 1.1 Create `zsh/modules/git/` directory structure (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/git/plugin.zsh` entry point

## 2. Configuration layer

- [x] 2.1 Create `zsh/modules/git/config/base.zsh` — set `ZSH_GIT_PATH` and git defaults
- [x] 2.2 Create `zsh/modules/git/config/main.zsh` — OS dispatch
- [x] 2.3 Create `zsh/modules/git/config/osx.zsh` — macOS git paths
- [x] 2.4 Create `zsh/modules/git/config/linux.zsh` — Linux git paths

## 3. Internal layer

- [x] 3.1 Create `zsh/modules/git/internal/base.zsh` — internal git helper functions
- [x] 3.2 Create `zsh/modules/git/internal/main.zsh` — internal dispatch
- [x] 3.3 Create `zsh/modules/git/internal/osx.zsh` — macOS internal helpers
- [x] 3.4 Create `zsh/modules/git/internal/linux.zsh` — Linux internal helpers

## 4. Public API layer

- [x] 4.1 Create `zsh/modules/git/pkg/base.zsh` — all `git::*` public functions and CLI scripts
- [x] 4.2 Create `zsh/modules/git/pkg/main.zsh` — public API dispatch
- [x] 4.3 Create `zsh/modules/git/pkg/osx.zsh` — macOS-specific public functions
- [x] 4.4 Create `zsh/modules/git/pkg/linux.zsh` — Linux-specific public functions

## 5. Module metadata

- [x] 5.1 Create `zsh/modules/git/init.zsh`
- [x] 5.2 Create `zsh/modules/git/LICENSE`
- [x] 5.3 Create `zsh/modules/git/README.md`

## 6. Integration

- [x] 6.1 Remove `hadenlabs/zsh-git` from `zsh/zsh_plugins.txt`

## 7. Verify

- [x] 7.1 Run `task validate` for shellcheck and codespell
- [x] 7.2 Confirm all `git::*` functions are defined