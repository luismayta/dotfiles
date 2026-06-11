## 1. Create module directory structure

- [x] 1.1 Create `zsh/modules/nvim/plugin.zsh` with `__ZSH_NVIM_LOADED` guard, `ZSH_NVIM_PATH` variable, and chained sourcing of config → internal → pkg
- [x] 1.2 Create `zsh/modules/nvim/config/` with `main.zsh` (flat OS dispatch), `base.zsh` (env vars), `osx.zsh`, `linux.zsh`
- [x] 1.3 Create `zsh/modules/nvim/internal/` with `main.zsh` (OS dispatch + auto-install), `base.zsh` (install/upgrade/clean), `osx.zsh`, `linux.zsh`
- [x] 1.4 Create `zsh/modules/nvim/pkg/` with `main.zsh` (OS dispatch + alias/helper sourcing), `base.zsh` (public API), `alias.zsh` (`vim` function), `helper.zsh` (`editnvim` function), `osx.zsh`, `linux.zsh`

## 2. Port config layer from zsh-nvim

- [x] 2.1 Write `config/base.zsh` — port env vars: `NVIM_REPO_HTTPS`, `NVIM_CONFIG_PATH`, `NVIM_PACKAGE_NAME=nvim`, `NVIM_ROOT_PATH`, `EDITOR` fallback. Omit unused `NVIM_MESSAGE_*` vars
- [x] 2.2 Write `config/main.zsh` — flat OS dispatch sourcing `base.zsh` + OS file (no factory function)
- [x] 2.3 Write `config/osx.zsh` and `config/linux.zsh` — empty stubs

## 3. Port internal layer from zsh-nvim

- [x] 3.1 Write `internal/base.zsh` — port `nvim::internal::install` (git clone nvimrc), `nvim::internal::upgrade` (git pull), `nvim::internal::clean` (rm caches)
- [x] 3.2 Write `internal/osx.zsh` and `internal/linux.zsh` — empty stubs
- [x] 3.3 Write `internal/main.zsh` — OS dispatch, then ensure `rsync` and `nvim` via `core::install`, auto-clone nvimrc if `NVIM_CONFIG_PATH` missing

## 4. Port pkg (public API) layer from zsh-nvim

- [x] 4.1 Write `pkg/base.zsh` — port thin wrappers: `nvim::install`, `nvim::upgrade`, `nvim::clean`
- [x] 4.2 Write `pkg/alias.zsh` — port `function vim { nvim ${@} }`
- [x] 4.3 Write `pkg/helper.zsh` — port `editnvim()` function (preserving undefined `NVIM_FILE_SETTINGS` behavior)
- [x] 4.4 Write `pkg/main.zsh` — OS dispatch sourcing `pkg/base.zsh` + OS file + `alias.zsh` + `helper.zsh`
- [x] 4.5 Write `pkg/osx.zsh` and `pkg/linux.zsh` — empty stubs

## 5. Remove external plugin reference

- [x] 5.1 Check `zsh/zsh_plugins.txt` for `hadenlabs/zsh-nvim` — remove if present
- [x] 5.2 Verify module auto-loads via directory discovery (no central registration needed)

## 6. Verify module loads correctly

- [x] 6.1 Run `task validate` to confirm pre-commit hooks pass (only pre-existing rvm issues, nvim files clean)
- [x] 6.2 Source `zsh/modules/nvim/plugin.zsh` and confirm idempotency guard works
- [x] 6.3 Confirm `nvim::install`, `nvim::upgrade`, `nvim::clean`, `vim` function, and `editnvim` function are defined
