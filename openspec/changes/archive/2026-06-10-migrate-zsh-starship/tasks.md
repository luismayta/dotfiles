## 1. Scaffold

- [x] 1.1 Create `zsh/modules/starship/` directory structure (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/starship/plugin.zsh` entry point

## 2. Configuration layer

- [x] 2.1 Create `zsh/modules/starship/config/base.zsh` — set `ZSH_STARSHIP_PATH` and starship defaults
- [x] 2.2 Create `zsh/modules/starship/config/main.zsh` — OS dispatch
- [x] 2.3 Create `zsh/modules/starship/config/osx.zsh` — macOS starship paths
- [x] 2.4 Create `zsh/modules/starship/config/linux.zsh` — Linux starship paths
- [x] 2.5 Copy `starship.toml` into `zsh/modules/starship/config/`

## 3. Internal layer

- [x] 3.1 Create `zsh/modules/starship/internal/base.zsh` — internal starship helper functions
- [x] 3.2 Create `zsh/modules/starship/internal/main.zsh` — internal dispatch
- [x] 3.3 Create `zsh/modules/starship/internal/osx.zsh` — macOS internal helpers
- [x] 3.4 Create `zsh/modules/starship/internal/linux.zsh` — Linux internal helpers

## 4. Public API layer

- [x] 4.1 Create `zsh/modules/starship/pkg/base.zsh` — all `starship::*` public functions
- [x] 4.2 Create `zsh/modules/starship/pkg/main.zsh` — public API dispatch
- [x] 4.3 Create `zsh/modules/starship/pkg/osx.zsh` — macOS-specific functions
- [x] 4.4 Create `zsh/modules/starship/pkg/linux.zsh` — Linux-specific functions

## 5. Module metadata

- [x] 5.1 Create `zsh/modules/starship/init.zsh`
- [x] 5.2 Create `zsh/modules/starship/LICENSE`
- [x] 5.3 Create `zsh/modules/starship/README.md`

## 6. Integration

- [x] 6.1 Remove `hadenlabs/zsh-starship` from `zsh/zsh_plugins.txt`

## 7. Verify

- [x] 7.1 Run `task validate` for shellcheck and codespell
- [x] 7.2 Confirm all `starship::*` functions are defined