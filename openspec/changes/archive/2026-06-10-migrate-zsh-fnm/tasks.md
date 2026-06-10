## 1. Module Structure

- [x] 1.1 Create `zsh/modules/fnm/` directory and subdirectories (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/fnm/plugin.zsh` with idempotency guard (`__ZSH_FNM_LOADED`) and source chain (config/main → internal/main → pkg/main)

## 2. Config Layer

- [x] 2.1 Create `zsh/modules/fnm/config/main.zsh` with OS dispatch sourcing base.zsh + osx.zsh/linux.zsh
- [x] 2.2 Create `zsh/modules/fnm/config/base.zsh` with `export FNM_PACKAGE_NAME`, `FNM_PATH`, `FNM_VERSION`, `FNM_VERSION_GLOBAL`, `FNM_VERSIONS` array, `FNM_PACKAGES` array (24 packages)
- [x] 2.3 Create `zsh/modules/fnm/config/osx.zsh` (placeholder)
- [x] 2.4 Create `zsh/modules/fnm/config/linux.zsh` (placeholder)

## 3. Internal Layer

- [x] 3.1 Create `zsh/modules/fnm/internal/main.zsh` with OS dispatch sourcing base.zsh → osx.zsh/linux.zsh → helper.zsh
- [x] 3.2 Create `zsh/modules/fnm/internal/base.zsh` with `fnm::internal::fnm::install`, `fnm::internal::fnm::load`, `fnm::internal::packages::install`, `fnm::internal::version::all::install`, `fnm::internal::version::global::install`, `fnm::internal::fnm::upgrade`
- [x] 3.3 Create `zsh/modules/fnm/internal/osx.zsh` (placeholder)
- [x] 3.4 Create `zsh/modules/fnm/internal/linux.zsh` (placeholder)
- [x] 3.5 Create `zsh/modules/fnm/internal/helper.zsh` (placeholder)

## 4. Package Layer

- [x] 4.1 Create `zsh/modules/fnm/pkg/main.zsh` with OS dispatch sourcing base.zsh → osx.zsh/linux.zsh → helper.zsh → alias.zsh
- [x] 4.2 Create `zsh/modules/fnm/pkg/base.zsh` with `fnm::install`, `fnm::load`, `fnm::post_install`, `fnm::upgrade`, `fnm::package::all::install`, `fnm::install::versions`, `fnm::install::version::global`, plus auto-invoke `fnm::load` and dependency install (`curl`, `unzip`, `fnm`) if missing
- [x] 4.3 Create `zsh/modules/fnm/pkg/osx.zsh` (placeholder)
- [x] 4.4 Create `zsh/modules/fnm/pkg/linux.zsh` (placeholder)
- [x] 4.5 Create `zsh/modules/fnm/pkg/helper.zsh` (placeholder)
- [x] 4.6 Create `zsh/modules/fnm/pkg/alias.zsh` (placeholder)

## 5. Remove External Dependency

- [x] 5.1 Remove `hadenlabs/zsh-fnm` from `zsh/zsh_plugins.txt`

## 6. Verification

- [x] 6.1 Source module in subshell and confirm no errors
- [x] 6.2 Verify `fnm::install`, `fnm::load`, `fnm::post_install`, `fnm::upgrade`, `fnm::package::all::install`, `fnm::install::versions`, `fnm::install::version::global`, `fnm::internal::fnm::install`, `fnm::internal::fnm::load`, `fnm::internal::packages::install`, `fnm::internal::version::all::install`, `fnm::internal::version::global::install`, `fnm::internal::fnm::upgrade` are all defined
- [x] 6.3 Verify idempotent loading (second source returns immediately)
- [x] 6.4 Run `task validate` to confirm pre-commit passes
