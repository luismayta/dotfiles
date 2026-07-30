## 1. Create direnv tool in devops module

- [x] 1.1 Create `zsh/modules/devops/config/direnv.zsh` with `DEVOPS_DIRENV_*` variables (PACKAGE_NAME, NIX_DIRENV_PACKAGE, DATA_PATH)
- [x] 1.2 Create `zsh/modules/devops/internal/direnv.zsh` with load (direnv hook zsh), install (nix-direnv via nix profile), upgrade, and main::factory
- [x] 1.3 Create `zsh/modules/devops/pkg/direnv.zsh` with public API: install, upgrade, sync, post_install
- [x] 1.4 Create `zsh/modules/devops/data/direnv/direnvrc` with nix-direnv source line
- [x] 1.5 Register `direnv` in `DEVOPS_TOOLS` array in `zsh/modules/devops/config/base.zsh`
- [x] 1.6 Add `source pkg/direnv.zsh` and `source internal/direnv.zsh` in devops main.zsh files

## 2. Restructure nix module data directory

- [x] 2.1 Create `zsh/system/nix/data/nix/` directory
- [x] 2.2 Move `zsh/system/nix/data/sync/` contents to `data/nix/` (or create fresh nix config files)
- [x] 2.3 Update `nix::internal::config::sync` in `zsh/system/nix/internal/base.zsh` to sync `data/nix/` → `~/.config/nix/`
- [x] 2.4 Remove `zsh/system/nix/data/sync/` directory (after its content is migrated)

## 3. Remove direnv from nix module

- [x] 3.1 Remove `zsh/system/nix/internal/direnv.zsh`
- [x] 3.2 Remove `source internal/direnv.zsh` and `nix::internal::direnv::setup` call from `zsh/system/nix/internal/main.zsh`

## 4. Remove direnv from core module

- [x] 4.1 Remove `zsh/system/core/internal/direnv.zsh`
- [x] 4.2 Remove `source internal/direnv.zsh` (if present) from `zsh/system/core/internal/main.zsh`

## 5. Validate

- [x] 5.1 Run `task validate` to check pre-commit hooks
- [x] 5.2 Source `zsh/system/core/main.zsh && zsh/modules/devops/plugin.zsh` and verify no errors
- [x] 5.3 Verify functions: `type devops::direnv::install` returns function
- [x] 5.4 Verify nix module loads without direnv errors
