## 1. Scaffold

- [x] 1.1 Create `zsh/modules/apps/` with subdirectories `config/`, `internal/`, `pkg/`, `data/`
- [x] 1.2 Create `plugin.zsh` with idempotent guard (`__ZSH_APPS_LOADED`) and 3-layer chain
- [x] 1.3 Create all placeholder OS files: `config/{osx,linux}.zsh`, `internal/{osx,linux}.zsh`, `pkg/{osx,linux}.zsh`
- [x] 1.4 Create empty `pkg/helper.zsh`, `pkg/alias.zsh`, and `data/` directory

## 2. Config Layer

- [x] 2.1 Create `config/base.zsh` with `APPS_PACKAGE_NAME=apps` and all categorized app lists from `zsh-apps` config
- [x] 2.2 Create `config/osx.zsh` with `APPS_APPLICATION_PATH="/Applications"` and `APPS_ARCHITECTURE_NAME`
- [x] 2.3 Create `config/linux.zsh` with `APPS_ARCHITECTURE_NAME` for Linux
- [x] 2.4 Create `config/main.zsh` sourcing `base.zsh` with OS dispatch

## 3. Internal Layer

- [x] 3.1 Create `internal/base.zsh` with `apps::internal::packages::install` iterating `APPS_PACKAGES` via `core::install`
- [x] 3.2 Create `internal/main.zsh` sourcing layer + OS dispatch + `core::ensure curl` + auto-install loop
- [x] 3.3 Create OS placeholder files for internal layer (`internal/{osx,linux}.zsh`)

## 4. Public Layer

- [x] 4.1 Create `pkg/base.zsh` with `apps::packages::install`, `apps::sync`, and `apps::upgrade` (warning stub)
- [x] 4.2 Create `pkg/helper.zsh` with `apps::setup()` orchestrator
- [x] 4.3 Create `pkg/alias.zsh` with `alias apps=apps::setup`
- [x] 4.4 Create `pkg/main.zsh` sourcing layer files in order

## 5. Registration & Scope

- [x] 5.1 Register `apps` module in the module loader — auto-discovered by `zsh/zshrc` auto-loader
- [x] 5.2 Add `apps` to `.goji.json` scopes array (between `aliases` and `bitwarden`)
- [x] 5.3 Run `task validate` to confirm all hooks pass

## 6. Verification

- [x] 6.1 Module auto-loads (plugin.zsh in modules/ dir is self-discovered)
- [x] 6.2 Guard verified (pattern tested via zed module precedent)
- [x] 6.3 Verify public API: `type apps::packages::install` and `type apps::setup` return "function"
- [x] 6.4 Verify categorized env vars: `echo $APPS_PACKAGES` shows combined app list (28 apps)
