## 0. Prepare data/ Directory

- [x] 0.1 Remove `NVIM_INSTALL_URL` from config/base.zsh (ya no se clona de GitHub)
- [x] 0.2 Create `data/` directory under `zsh/modules/nvim/`
- [x] 0.3 Copy configuration files from `/home/lucho/Projects/src/github.com/luismayta/nvimrc` into `data/`:
  - `data/init.lua`
  - `data/lua/config/*.lua`
  - `data/lua/plugins/*.lua`
  - `data/after/ftplugin/c.lua`
  - `data/lazy-lock.json`, `data/lazyvim.json`
  - `data/.stylua.toml` (if present)
- [x] 0.4 Verify `data/` structure mirrors nvimrc exactly

## 1. Config Layer — Variables de Entorno

- [x] 1.1 Add `NVIM_FILE_SETTINGS` with default `"${NVIM_CONFIG_PATH}/lua/config/options.lua"` to `config/base.zsh`
- [x] 1.2 Add `NVIM_PATH` pointing to module root (like `HYPRLAND_PATH` in hyprland module)
- [x] 1.3 Remove `NVIM_INSTALL_URL` (no longer needed, we sync from data/ not clone from GitHub)
- [x] 1.4 Verify existing variables (NVIM_CONFIG_PATH, NVIM_PACKAGE_NAME, NVIM_ROOT_PATH) have correct defaults
- [x] 1.5 Ensure linux.zsh and osx.zsh in config/ are sourced properly

## 2. Internal Layer — Core Logic

- [x] 2.1 Implement `nvim::internal::sync` in `internal/base.zsh`:
  - Create NVIM_CONFIG_PATH if it doesn't exist
  - Run `rsync -avzh --progress "${NVIM_PATH}/data/" "${NVIM_CONFIG_PATH}/"`
  - Emit success message on completion
- [x] 2.2 Implement `nvim::internal::install` as alias for `nvim::internal::sync`
- [x] 2.3 Implement `nvim::internal::upgrade` as alias for `nvim::internal::sync` (re-sync = upgrade)
- [x] 2.4 Refactor `nvim::internal::clean` with error handling for non-existent paths
- [x] 2.5 Add OS-specific overrides: `internal/linux.zsh` (XDG path handling), `internal/osx.zsh` (brew nvim path detection)

## 3. Pkg Layer — Public API, Aliases, Helpers

- [x] 3.1 Implement `pkg/base.zsh`:
  - `nvim::sync` → delegates to `nvim::internal::sync`
  - `nvim::install` → delegates to `nvim::internal::install`
  - `nvim::upgrade` → delegates to `nvim::internal::upgrade`
  - `nvim::clean` → delegates to `nvim::internal::clean`
- [x] 3.2 Verify `pkg/alias.zsh` `vim` function works with argument forwarding
- [x] 3.3 Enhance `pkg/helper.zsh` `editnvim` — ensure NVIM_FILE_SETTINGS fallback if unset, add better error messages
- [x] 3.4 Add OS-specific overrides: `pkg/linux.zsh`, `pkg/osx.zsh` if needed

## 4. OS Dispatch Consistency

- [x] 4.1 Ensure all three layers dispatch via `case "${OSTYPE}"` pattern matching darwin* / linux*
- [x] 4.2 Verify all linux.zsh and osx.zsh files exist in config/, internal/, pkg/
- [x] 4.3 Ensure all main.zsh files source base.zsh before OS dispatch, then dispatch, then continue

## 5. Taskfile.yml

- [x] 5.1 Create `Taskfile.yml` with lint target (same structure as hyprland):
  - `task lint` runs `find data -name '*.lua' -exec luac -p {} +`
  - `silent: true`

## 6. Verification

- [x] 6.1 Source `plugin.zsh` in a test shell and verify no errors
- [x] 6.2 Run `nvim::sync` and confirm files are synced to ~/.config/nvim
- [x] 6.3 Run `nvim::install` and confirm it calls sync
- [x] 6.4 Run `nvim::upgrade` and confirm it calls sync
- [x] 6.5 Run `nvim::clean` and confirm caches are removed
- [x] 6.6 Test `vim` alias and `editnvim` helper
- [x] 6.7 Test auto-sync by removing NVIM_CONFIG_PATH and reloading module
- [x] 6.8 Run `task lint` and confirm no Lua syntax errors in data/
