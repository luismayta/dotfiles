## 1. Module Structure

- [x] 1.1 Create `zsh/modules/rust/` directory and subdirectories (config/, internal/, pkg/)
- [x] 1.2 Create `zsh/modules/rust/plugin.zsh` with idempotency guard (`__ZSH_RUST_LOADED`) and source chain (config/main → internal/main → pkg/main)

## 2. Config Layer

- [x] 2.1 Create `zsh/modules/rust/config/main.zsh` with OS dispatch sourcing base.zsh + osx.zsh/linux.zsh
- [x] 2.2 Create `zsh/modules/rust/config/base.zsh` with `RUST_CARGO_BIN`, `RUST_CARGO_ENV`, `RUST_PACKAGE_NAME`, `RUST_CARGO_PACKAGES` array (20 packages), `RUST_RUSTUP_PACKAGES` array
- [x] 2.3 Create `zsh/modules/rust/config/osx.zsh` (placeholder)
- [x] 2.4 Create `zsh/modules/rust/config/linux.zsh` (placeholder)

## 3. Internal Layer

- [x] 3.1 Create `zsh/modules/rust/internal/main.zsh` with OS dispatch sourcing base.zsh → packages.zsh → osx.zsh/linux.zsh → helper.zsh
- [x] 3.2 Create `zsh/modules/rust/internal/base.zsh` with `rust::internal::rust::install`, `rust::internal::rust::init`, `rust::internal::package::install`, `rust::internal::rust::load`, `rust::internal::packages::install`, `rust::internal::version::all::install`, `rust::internal::version::global::install`, `rust::internal::rust::upgrade`
- [x] 3.3 Create `zsh/modules/rust/internal/packages.zsh` with `rust::internal::delta::load` (git-delta config) and `rust::internal::zoxide::load` (zoxide init)
- [x] 3.4 Create `zsh/modules/rust/internal/osx.zsh` (placeholder)
- [x] 3.5 Create `zsh/modules/rust/internal/linux.zsh` (placeholder)
- [x] 3.6 Create `zsh/modules/rust/internal/helper.zsh` (placeholder)

## 4. Package Layer

- [x] 4.1 Create `zsh/modules/rust/pkg/main.zsh` sourcing base.zsh
- [x] 4.2 Create `zsh/modules/rust/pkg/base.zsh` with `rust::dependences`, `rust::install`, `rust::load`, `rust::post_install`, `rust::package::all::install`, `rust::package::install`, `rust::upgrade`, `rust::install::versions`, `rust::install::version::global`, plus auto-invoke `rust::dependences && rust::load` if rustc not found
- [x] 4.3 Create `zsh/modules/rust/pkg/osx.zsh` (placeholder)
- [x] 4.4 Create `zsh/modules/rust/pkg/linux.zsh` (placeholder)
- [x] 4.5 Create `zsh/modules/rust/pkg/helper.zsh` (placeholder)
- [x] 4.6 Create `zsh/modules/rust/pkg/alias.zsh` (placeholder)

## 5. Remove External Dependency

- [x] 5.1 Remove `luismayta/zsh-rust` from `zsh/zsh_plugins.txt`

## 6. Verification

- [x] 6.1 Source module in subshell and confirm no errors
- [x] 6.2 Verify `rust::load`, `rust::install`, `rust::dependences`, `rust::post_install`, `rust::internal::rust::install`, `rust::internal::package::install`, `rust::internal::packages::install`, `rust::internal::rust::load`, `rust::internal::delta::load`, `rust::internal::zoxide::load`, `rust::package::all::install`, `rust::package::install`, `rust::upgrade` are all defined
- [x] 6.3 Verify idempotent loading (second source returns immediately)
- [x] 6.4 Run `task validate` to confirm pre-commit passes