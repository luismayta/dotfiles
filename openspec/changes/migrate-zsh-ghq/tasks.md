## 1. Scaffold

- [x] 1.1 Create `zsh/modules/ghq/` directory structure (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/ghq/plugin.zsh` entry point

## 2. Configuration layer

- [x] 2.1 Create `zsh/modules/ghq/config/base.zsh` — set `ZSH_GHQ_PATH` and ghq defaults
- [x] 2.2 Create `zsh/modules/ghq/config/main.zsh` — OS dispatch
- [x] 2.3 Create `zsh/modules/ghq/config/osx.zsh` — macOS ghq paths
- [x] 2.4 Create `zsh/modules/ghq/config/linux.zsh` — Linux ghq paths

## 3. Internal layer

- [x] 3.1 Create `zsh/modules/ghq/internal/base.zsh` — internal ghq helper functions
- [x] 3.2 Create `zsh/modules/ghq/internal/main.zsh` — internal dispatch
- [x] 3.3 Create `zsh/modules/ghq/internal/osx.zsh` — macOS internal helpers
- [x] 3.4 Create `zsh/modules/ghq/internal/linux.zsh` — Linux internal helpers

## 4. Public API layer

- [x] 4.1 Create `zsh/modules/ghq/pkg/base.zsh` — all `ghq::*` public functions (18 functions)
- [x] 4.2 Create `zsh/modules/ghq/pkg/main.zsh` — public API dispatch
- [x] 4.3 Create `zsh/modules/ghq/pkg/osx.zsh` — macOS-specific public functions
- [x] 4.4 Create `zsh/modules/ghq/pkg/linux.zsh` — Linux-specific public functions
- [x] 4.5 Create `zsh/modules/ghq/pkg/cookiecutter.zsh` — cookiecutter integration

## 5. Module metadata

- [x] 5.1 Create `zsh/modules/ghq/init.zsh`
- [x] 5.2 Create `zsh/modules/ghq/LICENSE`
- [x] 5.3 Create `zsh/modules/ghq/README.md`

## 6. Integration

- [x] 6.1 Remove `hadenlabs/zsh-ghq` from `zsh/zsh_plugins.txt`

## 7. Verify

- [x] 7.1 Run `task validate` for shellcheck and codespell
- [x] 7.2 Confirm all `ghq::*` functions are defined
