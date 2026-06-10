## 1. Scaffold

- [x] 1.1 Create `zsh/modules/notify/` directory structure (config/, internal/, pkg/, assets/, sounds/)
- [x] 1.2 Create `zsh/modules/notify/plugin.zsh` entry point

## 2. Configuration layer

- [x] 2.1 Create `zsh/modules/notify/config/base.zsh` — set `ZSH_NOTIFY_PATH` and notify defaults
- [x] 2.2 Create `zsh/modules/notify/config/main.zsh` — OS dispatch
- [x] 2.3 Create `zsh/modules/notify/config/osx.zsh` — macOS notification settings
- [x] 2.4 Create `zsh/modules/notify/config/linux.zsh` — Linux notification settings

## 3. Internal layer

- [x] 3.1 Create `zsh/modules/notify/internal/base.zsh` — internal notify helper functions
- [x] 3.2 Create `zsh/modules/notify/internal/main.zsh` — internal dispatch
- [x] 3.3 Create `zsh/modules/notify/internal/osx.zsh` — macOS internal helpers
- [x] 3.4 Create `zsh/modules/notify/internal/linux.zsh` — Linux internal helpers

## 4. Public API layer

- [x] 4.1 Create `zsh/modules/notify/pkg/base.zsh` — all `notify::*` public functions
- [x] 4.2 Create `zsh/modules/notify/pkg/main.zsh` — public API dispatch
- [x] 4.3 Create `zsh/modules/notify/pkg/osx.zsh` — macOS notification functions
- [x] 4.4 Create `zsh/modules/notify/pkg/linux.zsh` — Linux notification functions

## 5. Assets

- [x] 5.1 Copy `assets/` directory with visual assets
- [x] 5.2 Copy `sounds/` directory with sound themes (default, piano)

## 6. Module metadata

- [x] 6.1 Create `zsh/modules/notify/init.zsh`
- [x] 6.2 Create `zsh/modules/notify/LICENSE`
- [x] 6.3 Create `zsh/modules/notify/README.md`

## 7. Integration

- [x] 7.1 Remove `luismayta/zsh-notify` from `zsh/zsh_plugins.txt`

## 8. Verify

- [x] 8.1 Run `task validate` for shellcheck and codespell
- [x] 8.2 Confirm all `notify::*` functions are defined