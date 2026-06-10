## 1. Module Structure

- [x] 1.1 Create `zsh/modules/goenv/` directory and subdirectories (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/goenv/plugin.zsh` with idempotency guard (`__ZSH_GOENV_LOADED`) and source chain (config/main → internal/main → pkg/main)

## 2. Config Layer

- [x] 2.1 Create `zsh/modules/goenv/config/main.zsh` with OS dispatch sourcing base.zsh + osx.zsh/linux.zsh
- [x] 2.2 Create `zsh/modules/goenv/config/base.zsh` with `export GO111MODULES`, `GOENV_ROOT`, `GOENV_ROOT_BIN`, `GOBREW_ROOT_BIN`, `GOBREW_CURRENT_BIN`, `GOBREW_DOWNLOAD_URL`, `GOENV_MESSAGE_BREW`, `GOENV_PACKAGE_NAME`, `ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH`, `GOENV_VERSIONS` array (1.24.11, 1.25.11), `GOENV_VERSION_GLOBAL` (default: 1.25.11), `GOENV_INSTALL_PACKAGES` array (34 Go packages)
- [x] 2.3 Create `zsh/modules/goenv/config/osx.zsh` (placeholder)
- [x] 2.4 Create `zsh/modules/goenv/config/linux.zsh` (placeholder)

## 3. Internal Layer

- [x] 3.1 Create `zsh/modules/goenv/internal/main.zsh` with OS dispatch sourcing base.zsh → osx.zsh/linux.zsh → helper.zsh, plus auto-load of `goenv::internal::load` and auto-install of curl/gobrew
- [x] 3.2 Create `zsh/modules/goenv/internal/base.zsh` with `goenv::internal::install`, `goenv::internal::load`, `goenv::internal::package::install`, `goenv::internal::packages::install`, `goenv::internal::version::all::install`, `goenv::internal::version::global::install`, `goenv::internal::upgrade`
- [x] 3.3 Create `zsh/modules/goenv/internal/osx.zsh` (placeholder)
- [x] 3.4 Create `zsh/modules/goenv/internal/linux.zsh` (placeholder)
- [x] 3.5 Create `zsh/modules/goenv/internal/helper.zsh` (placeholder)

## 4. Package Layer

- [x] 4.1 Create `zsh/modules/goenv/pkg/main.zsh` with OS dispatch sourcing base.zsh → osx.zsh/linux.zsh → helper.zsh
- [x] 4.2 Create `zsh/modules/goenv/pkg/base.zsh` with `goenv::install`, `goenv::load`, `goenv::post_install`, `goenv::upgrade`, `goenv::package::all::install`, `goenv::package::install`, `goenv::install::versions`, `goenv::install::version::global`
- [x] 4.3 Create `zsh/modules/goenv/pkg/osx.zsh` (placeholder)
- [x] 4.4 Create `zsh/modules/goenv/pkg/linux.zsh` (placeholder)
- [x] 4.5 Create `zsh/modules/goenv/pkg/helper.zsh` (placeholder)
- [x] 4.6 Create `zsh/modules/goenv/pkg/alias.zsh` (placeholder)

## 5. Remove External Dependency

- [x] 5.1 Remove `hadenlabs/zsh-goenv` from `zsh/zsh_plugins.txt`

## 6. Verification

- [x] 6.1 Source module in subshell and confirm no errors
- [x] 6.2 Verify
- [x] 6.3 Verify idempotent loading (second source returns immediately)
- [x] 6.4 Run `task validate` to confirm pre-commit passes
