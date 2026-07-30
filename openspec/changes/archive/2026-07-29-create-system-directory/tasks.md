## 1. Mover directorios con git mv

- [x] 1.1 `git mv zsh/core/ zsh/system/core/`
- [x] 1.2 `git mv zsh/modules/nix/ zsh/system/nix/`
- [x] 1.3 `git mv zsh/modules/nix-darwin/ zsh/system/nix-darwin/`

## 2. Actualizar zshrc con nuevo orden de carga

- [x] 2.1 Cambiar `DOTFILES_CORE_PATH="${DOTFILES_ZSH_DIR}/core"` → `"${DOTFILES_ZSH_DIR}/system/core"`
- [x] 2.2 Exportar nueva variable `DOTFILES_SYSTEM_DIR="${DOTFILES_ZSH_DIR}/system"`
- [x] 2.3 Agregar loop de carga de `$DOTFILES_SYSTEM_DIR/*/plugin.zsh` entre core y el customrc
- [x] 2.4 Excluir `core/` del loop de system modules (core se carga aparte via main.zsh)
- [x] 2.5 El loop de system modules SHALL respetar `ZSH_DISABLED_MODULES`

## 3. Actualizar archivos con rutas fijas

- [x] 3.1 Actualizar `DOTFILES_CORE_PATH="${DOTFILES_ZSH_DIR}/system/core"` en `zsh/system/core/config/paths.zsh`
- [x] 3.2 Actualizar `CORE_MESSAGE_NIX` en `zsh/system/core/config/env.zsh` — cambiar `zsh/modules/nix` por `zsh/system/nix`
- [x] 3.3 Actualizar `Taskfile.yml` — includes de `./zsh/modules/nix/Taskfile.yml` → `./zsh/system/nix/Taskfile.yml` y `nix-darwin` igual
- [x] 3.4 Actualizar `docs/guides/implement-tool-in-module.md` — referencias a `zsh/core/`
- [x] 3.5 Actualizar `docs/guides/create-module.md` — referencias a `zsh/core/`
- [x] 3.6 Actualizar `openspec/specs/shared-paths/spec.md` — `DOTFILES_CORE_DIR` apunta a `system/core`
- [x] 3.7 Actualizar `openspec/specs/zshrc-load/spec.md` — `DOTFILES_CORE_DIR` apunta a `system/core`

## 4. Validar auto-resolución (rutas relativas — sin cambios necesarios)

- [x] 4.1 Verificar que `ZSH_NIX_PATH="$(dirname "${0}")"` en `zsh/system/nix/plugin.zsh` resuelve correctamente
- [x] 4.2 Verificar que `NIX_DARWIN_PATH="${0:A:h}"` en `zsh/system/nix-darwin/plugin.zsh` resuelve correctamente
- [x] 4.3 Verificar que `CORE_PATH="$(dirname "${0}")"` en `zsh/system/core/main.zsh` resuelve correctamente
- [x] 4.4 `"${DOTFILES_CORE_PATH}"` en todos los archivos dentro de `zsh/system/core/` — auto-resuelven desde `paths.zsh`

## 6. Verificación final

- [x] 6.1 Ejecutar `task validate` y confirmar todos los checks
- [x] 6.2 Verificar que `zsh/system/core/main.zsh` carga sin errores
- [x] 6.3 Verificar que `zsh/system/nix/plugin.zsh` carga en fase system
- [x] 6.4 Verificar que `zsh/system/nix-darwin/plugin.zsh` carga solo en macOS
- [x] 6.5 Verificar que `ZSH_DISABLED_MODULES` sigue funcionando para system modules
