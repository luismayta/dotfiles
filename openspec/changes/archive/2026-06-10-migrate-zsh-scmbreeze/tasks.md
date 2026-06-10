## 1. Scaffold

- [x] 1.1 Create `zsh/modules/scmbreeze/` directory structure (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/scmbreeze/plugin.zsh` entry point

## 2. Configuration layer

- [x] 2.1 Create `zsh/modules/scmbreeze/config/base.zsh` — set `ZSH_SCMBREEZE_PATH` and scmbreeze defaults
- [x] 2.2 Create `zsh/modules/scmbreeze/config/main.zsh` — OS dispatch
- [x] 2.3 Create `zsh/modules/scmbreeze/config/osx.zsh` — macOS scmbreeze paths
- [x] 2.4 Create `zsh/modules/scmbreeze/config/linux.zsh` — Linux scmbreeze paths

## 3. Internal layer

- [x] 3.1 Create `zsh/modules/scmbreeze/internal/base.zsh` — internal scmbreeze helper functions
- [x] 3.2 Create `zsh/modules/scmbreeze/internal/main.zsh` — internal dispatch
- [x] 3.3 Create `zsh/modules/scmbreeze/internal/osx.zsh` — macOS internal helpers
- [x] 3.4 Create `zsh/modules/scmbreeze/internal/linux.zsh` — Linux internal helpers

## 4. Public API layer

- [x] 4.1 Create `zsh/modules/scmbreeze/pkg/base.zsh` — all `scmbreeze::*` public functions
- [x] 4.2 Create `zsh/modules/scmbreeze/pkg/main.zsh` — public API dispatch
- [x] 4.3 Create `zsh/modules/scmbreeze/pkg/osx.zsh` — macOS-specific functions
- [x] 4.4 Create `zsh/modules/scmbreeze/pkg/linux.zsh` — Linux-specific functions

## 5. Module metadata

- [x] 5.1 Create `zsh/modules/scmbreeze/init.zsh`
- [x] 5.2 Create `zsh/modules/scmbreeze/LICENSE`
- [x] 5.3 Create `zsh/modules/scmbreeze/README.md`

## 6. Integration

- [x] 6.1 Remove `luismayta/zsh-scmbreeze` from `zsh/zsh_plugins.txt`

## 7. Verify

- [x] 7.1 Run `task validate` for shellcheck and codespell
- [x] 7.2 Confirm all `scmbreeze::*` functions are defined
