## 1. Module Structure

- [x] 1.1 Create `zsh/modules/brew/` directory and subdirectories (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/brew/plugin.zsh` with idempotency guard (`__ZSH_BREW_LOADED`) and source chain (config/main → internal/main → pkg/main)

## 2. Config Layer

- [x] 2.1 Create `zsh/modules/brew/config/main.zsh` with OS dispatch sourcing base.zsh + osx.zsh/linux.zsh
- [x] 2.2 Create `zsh/modules/brew/config/base.zsh` with `brew_package_name=brew`
- [x] 2.3 Create `zsh/modules/brew/config/osx.zsh` (placeholder)
- [x] 2.4 Create `zsh/modules/brew/config/linux.zsh` (placeholder)

## 3. Internal Layer

- [x] 3.1 Create `zsh/modules/brew/internal/main.zsh` sourcing all internal modules
- [x] 3.2 Create `zsh/modules/brew/internal/base.zsh` with `brew::dependences::checked`, `brew::dependences::install`, `brew::install`, `brew::post_install`
- [x] 3.3 Create `zsh/modules/brew/internal/osx.zsh` with `brew::install::osx` (ruby curl Homebrew)
- [x] 3.4 Create `zsh/modules/brew/internal/linux.zsh` with `brew::install::linux` (ruby curl Linuxbrew + vendor-install ruby)

## 4. Package Layer

- [x] 4.1 Create `zsh/modules/brew/pkg/main.zsh` sourcing base.zsh
- [x] 4.2 Create `zsh/modules/brew/pkg/base.zsh` with `brew::load` (PATH/MANPATH/INFOPATH/LD_LIBRARY_PATH exports) and auto-invoke `brew::load` + auto-install guard

## 5. Remove External Dependency

- [x] 5.1 Remove `luismayta/zsh-brew` from `zsh/zsh_plugins.txt`

## 6. Verification

- [x] 6.1 Source module in subshell and confirm no errors
- [x] 6.2 Verify `brew::load`, `brew::install`, `brew::install::osx`, `brew::install::linux`, `brew::dependences::checked`, `brew::dependences::install`, `brew::post_install` are all defined
- [x] 6.3 Verify idempotent loading (second source returns immediately)
- [x] 6.4 Run `task validate` to confirm pre-commit passes
