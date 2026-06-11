## 1. Create module directory structure

- [x] 1.1 Create `zsh/modules/rvm/plugin.zsh` with idempotency guard, `RVM_PATH` variable, and chained sourcing
- [x] 1.2 Create `zsh/modules/rvm/config/` directory with `main.zsh` (flat OS dispatch), `base.zsh` (env vars), `osx.zsh`, `linux.zsh`
- [x] 1.3 Create `zsh/modules/rvm/internal/` directory with `main.zsh` (OS dispatch), `base.zsh` (core functions), `osx.zsh` (macOS overrides), `linux.zsh`
- [x] 1.4 Create `zsh/modules/rvm/pkg/` directory with `main.zsh` (OS dispatch), `base.zsh` (public API), `osx.zsh`, `linux.zsh`

## 2. Port config layer from zsh-rvm

- [x] 2.1 Write `config/base.zsh` — port `RVM_PACKAGE_NAME`, `RVM_ROOT`, `RVM_VERSIONS`, `RVM_VERSION_GLOBAL`, `RVM_PACKAGES` with dotfiles conventions (shellcheck headers)
- [x] 2.2 Write `config/main.zsh` — flat OS dispatch sourcing `base.zsh` + OS file (no factory function)
- [x] 2.3 Write `config/osx.zsh` and `config/linux.zsh` — empty stubs per dotfiles convention

## 3. Port internal layer from zsh-rvm

- [x] 3.1 Write `internal/base.zsh` — port `rvm::internal::rvm::install`, `rvm::internal::install::gpg`, `rvm::internal::rvm::load`, `rvm::internal::packages::install`, `rvm::internal::version::install`, `rvm::internal::version::all::install`, `rvm::internal::version::global::install`
- [x] 3.2 Write `internal/osx.zsh` — port macOS overrides: openssl@3 paths for `version::install`, `rvm::load`, `rvm::install`
- [x] 3.3 Write `internal/linux.zsh` — empty stub
- [x] 3.4 Write `internal/main.zsh` — OS dispatch with `core::ensure curl`, `core::ensure gpg`, auto-load rvm, auto-install if missing

## 4. Port pkg (public API) layer from zsh-rvm

- [x] 4.1 Write `pkg/base.zsh` — port thin wrappers: `rvm::install`, `rvm::load`, `rvm::upgrade`, `rvm::package::all::install`, `rvm::install::versions`, `rvm::install::version::global`
- [x] 4.2 Write `pkg/main.zsh` — OS dispatch sourcing `pkg/base.zsh` + OS file
- [x] 4.3 Write `pkg/osx.zsh` and `pkg/linux.zsh` — empty stubs

## 5. Remove external plugin reference

- [x] 5.1 Check `zsh/zsh_plugins.txt` for `hadenlabs/zsh-rvm` — remove if present (not found, nothing to remove)
- [x] 5.2 Verify module auto-loads via directory discovery (no central registration needed) — confirmed, zshrc iterates `zsh/modules/*/plugin.zsh`

## 6. Verify module loads correctly

- [x] 6.1 Run `task validate` to confirm pre-commit hooks pass — all hooks passed, shellcheck clean
- [x] 6.2 Source `zsh/modules/rvm/plugin.zsh` and confirm idempotency guard works — second load skipped, `__ZSH_RVM_LOADED=1` set
- [x] 6.3 Confirm `rvm::load`, `rvm::install`, `rvm::install::versions` functions are defined — all 5 public functions verified
