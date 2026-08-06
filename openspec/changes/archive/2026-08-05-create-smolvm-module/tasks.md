---
## 1. Module Scaffold

- [x] 1.1 Create `zsh/modules/smolvm/` with `config/`, `internal/`, `pkg/`, and `data/` directories per `docs/guides/create-module.md`
- [x] 1.2 Create `zsh/modules/smolvm/README.yaml` with module metadata (name, description, features, requirements, license)
- [x] 1.3 Create `zsh/modules/smolvm/Taskfile.yml` with a `readme` task using `{{.README_MODULE_TEMPLATE}}` and `README.yaml` as datasource
- [x] 1.4 Register `module-smolvm` taskfile entry in the root `Taskfile.yml`

## 2. Config Layer

- [x] 2.1 Create `config/base.zsh` exporting `ZSH_SMOLVM_ENABLED` (default `true`), `ZSH_SMOLVM_PACKAGE_NAME`, `ZSH_SMOLVM_VERSION=1.3.2`, `ZSH_SMOLVM_SHA256` (value fetched from the official v1.3.2 release checksums), `ZSH_SMOLVM_INSTALL_URL`, `ZSH_SMOLVM_BIN_PATH="${HOME}/.local/bin"`, and `ZSH_SMOLVM_DATA_PATH="${ZSH_SMOLVM_PATH}/data"`
- [x] 2.2 Create `config/main.zsh` sourcing `base.zsh` with OS dispatch (`osx.zsh` / `linux.zsh`)
- [x] 2.3 Create placeholder stubs `config/osx.zsh` and `config/linux.zsh`

## 3. Internal Layer

- [x] 3.1 Create `internal/install.zsh` with `smolvm::internal::install`: early return when `core::exists smolvm`; `core::ensure curl`; download the pinned release asset; verify SHA256 with `sha256sum`; abort with `message_error` on mismatch without installing; `install -m 0755` into `~/.local/bin`; post-install `core::exists` check with `message_warning` when binary not found on PATH
- [x] 3.2 Create `internal/base.zsh` with `smolvm::internal::verify` checking `smolvm --version` reports 1.3.2 and `smolvm machine run --help` responds
- [x] 3.3 Create `internal/main.zsh` sourcing layer files in dependency order, OS dispatch, `core::ensure curl` (and `sha256sum` where not guaranteed), and auto-install `if ! core::exists smolvm; then smolvm::internal::install; fi`
- [x] 3.4 Create placeholder stubs `internal/osx.zsh` and `internal/linux.zsh`

## 4. Public Layer

- [x] 4.1 Create `pkg/base.zsh` with public wrappers `smolvm::install` and `smolvm::post_install` (post_install runs verification); no `sync` function (documented non-goal — smolvm needs no managed config files)
- [x] 4.2 Create `pkg/helper.zsh` with `smolvm::setup` orchestrator (install if missing else info, then verify, then success)
- [x] 4.3 Create `pkg/alias.zsh` with user aliases (empty placeholder allowed)
- [x] 4.4 Create `pkg/main.zsh` sourcing `base.zsh`, OS dispatch, `helper.zsh`, and `alias.zsh`
- [x] 4.5 Create placeholder stubs `pkg/osx.zsh` and `pkg/linux.zsh`

## 5. Entry Point

- [x] 5.1 Create `plugin.zsh` with: `# shellcheck shell=bash`; idempotency guard `__ZSH_SMOLVM_LOADED`; `ZSH_SMOLVM_PATH="$(dirname "${0}")"`; `message_info` loading message; source `config/main.zsh`; `${ZSH_SMOLVM_ENABLED:-false} || return`; source `internal/main.zsh`; source `pkg/main.zsh` (mirroring `zsh/modules/herdr/plugin.zsh`)

## 6. README Generation

- [x] 6.1 Run `task module-smolvm:readme` from the repo root to generate `zsh/modules/smolvm/README.md` from `provision/templates/README.module.tpl.md`
- [x] 6.2 Verify generated `README.md` reflects `README.yaml` metadata

## 7. Verification and Quality

- [x] 7.1 Run `bash -n` on all new module files
- [x] 7.2 Run `shellcheck` on all new module files
- [x] 7.3 Load test: `source zsh/system/core/main.zsh && source zsh/modules/smolvm/plugin.zsh` shows the loading message exactly once
- [x] 7.4 Idempotency test: sourcing `plugin.zsh` twice is a no-op on the second source
- [x] 7.5 Disabled test: with `ZSH_SMOLVM_ENABLED=false`, internal and pkg layers do not load
- [x] 7.6 Post-install test: `smolvm --version` reports 1.3.2 and `smolvm machine run --help` responds
- [x] 7.7 Run `openspec validate --change create-smolvm-module` on the change