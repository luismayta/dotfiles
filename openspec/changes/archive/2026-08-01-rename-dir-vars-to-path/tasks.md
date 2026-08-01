## 1. Module config dirs (leaf-first)

- [x] 1.1 Rename `ZSH_YAZI_CONFIG_DIR` → `ZSH_YAZI_CONFIG_PATH` en `zsh/modules/yazi/config/base.zsh` y actualizar usos en `zsh/modules/yazi/pkg/helper.zsh` y `zsh/modules/yazi/internal/base.zsh`
- [x] 1.2 Rename `ZSH_HERDR_CONFIG_DIR` → `ZSH_HERDR_CONFIG_PATH` en `zsh/modules/herdr/config/base.zsh` y actualizar usos en `zsh/modules/herdr/pkg/helper.zsh` y `zsh/modules/herdr/internal/install.zsh`
- [x] 1.3 Rename `ZSH_NOTIFY_NOTI_CONFIG_DIR` → `ZSH_NOTIFY_NOTI_CONFIG_PATH` en `zsh/modules/notify/config/adapter/noti.zsh` y actualizar usos en `zsh/modules/notify/internal/adapter/noti.zsh`
- [x] 1.4 Rename `NIX_DIRENV_CONFIG_DIR` → `NIX_DIRENV_CONFIG_PATH` en `zsh/system/nix/config/direnv.zsh` y actualizar uso en `zsh/system/nix/internal/direnv.zsh`
- [x] 1.5 Rename `NIX_CONF_DIR` → `NIX_CONF_PATH` en `zsh/system/core/config/env.zsh` y `zsh/system/nix/config/linux.zsh` (doble definición) y actualizar usos en `zsh/system/nix/config/linux.zsh` y `zsh/system/nix/internal/base.zsh`
- [x] 1.6 Rename `DEVOPS_ATUIN_CONFIG_DIR` → `DEVOPS_ATUIN_CONFIG_PATH` en `zsh/modules/devops/config/atuin.zsh` (definición; sin usos en código zsh)

## 2. Provision scripts

- [x] 2.1 Rename `SCRIPT_DIR` → `SCRIPT_PATH`, `ZSH_DIR` → `ZSH_PATH`, `TOOLS_DIR` → `TOOLS_PATH`, `ROOT_DIR` → `ROOT_PATH` en `provision/script/bootstrap.sh` y actualizar usos en `provision/script/functions.sh`, `provision/script/run.sh`, `provision/script/test.sh`
- [x] 2.2 Eliminar `EXTRAS_DIR` (0 usos) de `provision/script/bootstrap.sh`
- [x] 2.3 Eliminar `FONTS_DIR` (superseded por `RESOURCES_FONTS_PATH`) de `provision/script/config/base.sh`, `provision/script/config/osx.sh`, `provision/script/config/linux.sh`

## 3. Script-local bash vars

- [x] 3.1 Rename `SCRIPT_DIR` → `SCRIPT_PATH` y `TESTS_DIR` → `TESTS_PATH` en `zsh/modules/git/tests/run.sh`
- [x] 3.2 Rename `ANTIDOTE_DIR` → `ANTIDOTE_PATH` en `tools/antidote/install.sh`
- [x] 3.3 Rename `SCRIPT_DIR` local → `SCRIPT_PATH` en `zsh/modules/waybar/data/scripts/mpd-heart-toggle.sh` y `zsh/modules/waybar/data/scripts/is_in_playlist.sh`

## 4. Core bootstrap (last — highest risk)

- [x] 4.1 Rename `DOTFILES_DIR` → `DOTFILES_PATH`, `DOTFILES_ZSH_DIR` → `DOTFILES_ZSH_PATH`, `DOTFILES_SYSTEM_DIR` → `DOTFILES_SYSTEM_PATH` en `zsh/zshrc` (definiciones L11-15 y usos)
- [x] 4.2 Actualizar `zsh/system/core/config/paths.zsh` — `DOTFILES_ZSH_DIR` → `DOTFILES_ZSH_PATH` (en `DOTFILES_CORE_PATH`)
- [x] 4.3 Actualizar `zsh/system/nix-darwin/config/osx.zsh` — usos de `DOTFILES_DIR` → `DOTFILES_PATH`
- [x] 4.4 Actualizar los 10 scripts en `bin/` que usan `${DOTFILES_DIR:-${HOME}/.dotfiles}` → `${DOTFILES_PATH:-${HOME}/.dotfiles}` (preservar fallback)
- [x] 4.5 Actualizar `~/.zshrc` del usuario: `DOTFILES_DIR`/`DOTFILES_ZSH_DIR`/`DOTFILES_SYSTEM_DIR` → nombres `_PATH` (mismo cambio, precedente 2026-06-10)

## 5. Live specs y docs

- [x] 5.1 Aplicar delta `path-naming-convention` → `openspec/specs/path-naming-convention/spec.md`
- [x] 5.2 Aplicar delta `zshrc-load` → `openspec/specs/zshrc-load/spec.md` (DOTFILES_SYSTEM_PATH, DOTFILES_ZSH_PATH)
- [x] 5.3 Aplicar delta `shared-paths` → `openspec/specs/shared-paths/spec.md` (DOTFILES_ZSH_PATH)
- [x] 5.4 Aplicar delta `core-api` → `openspec/specs/core-api/spec.md` (DOTFILES_ZSH_PATH)
- [x] 5.5 Aplicar delta `devops-atuin` → `openspec/specs/devops-atuin/spec.md` (DEVOPS_ATUIN_CONFIG_PATH)
- [x] 5.6 Aplicar delta `devops-k9s` → `openspec/specs/devops-k9s/spec.md` (fix stale DEVOPS_K9S_CONF_DIR → DEVOPS_K9S_CONF_PATH)
- [x] 5.7 Actualizar `docs/guides/create-module.md` (fila herdr `ZSH_HERDR_CONFIG_DIR`) y `docs/guides/implement-tool-in-module.md` (fila atuin `DEVOPS_ATUIN_CONFIG_DIR`)

## 6. Verificación

- [x] 6.1 Grep residual: `grep -rn "_DIR=" zsh/ provision/ bin/ tools/` debe devolver solo excepciones (`APPS_WEB_APPS_BUILD_DIR`, `SDKMAN_DIR`, `XDG_RUNTIME_DIR`, `XDG_CONFIG_HOME`)
- [x] 6.2 `zsh -n` sobre todos los archivos modificados (sintaxis)
- [x] 6.3 Smoke test: `source zsh/zshrc` en shell limpio sin errores; `printenv DOTFILES_PATH DOTFILES_ZSH_PATH DOTFILES_SYSTEM_PATH`
- [x] 6.4 `openspec validate` del change + shellcheck de archivos nuevos
