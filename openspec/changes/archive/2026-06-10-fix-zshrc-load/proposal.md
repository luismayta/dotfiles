## Why

`zsh/zshrc` no carga correctamente: el directorio `DOTFILES_MOD_DIR` apunta a `zsh/mod/` que no existe (el real es `zsh/core/`), lo que impide que se cargue todo el sistema core (variables como `CUSTOMRC`, funciones como `path::clean`, `core::install`, etc.). Además hay bugs de compatibilidad con `set -u`, `FPATH` corrupto, y ausencia de completions en Linux.

## What Changes

- Corregir `DOTFILES_MOD_DIR` → `DOTFILES_CORE_DIR` apuntando a `zsh/core/`
- Corregir guard `type -p path::clean` → `(( $+functions[path::clean] ))` para funciones zsh
- Corregir `FPATH` que está siendo asignado con `PATH` en vez de limpiar `FPATH`
- Agregar `CUSTOMRC="${HOME}/.customrc"` como fallback en `zshrc` para que exista aunque core no se haya cargado aún
- Cambiar shebang `ksh` → `zsh`
- Agregar bloque de completions para Linux (análogo al de macOS)

## Capabilities

### New Capabilities
- `zshrc-load`: Carga correcta de `zsh/core/` y dependencias desde `zsh/zshrc`

### Modified Capabilities
- `shared-paths`: `DOTFILES_CORE_DIR` reemplaza `DOTFILES_MOD_DIR` como variable de entorno
- `shared-utils`: `path::clean` detection corregida para funciones zsh

## Impact

- `zsh/zshrc`: archivo principal modificado (6 bugs corregidos)
- `zsh/core/config/paths.zsh`: nueva variable `DOTFILES_CORE_DIR` exportada (reemplaza `DOTFILES_MOD_DIR`)
- `openspec/specs/shared-paths/spec.md`: actualizar referencia de `DOTFILES_MOD_DIR` a `DOTFILES_CORE_DIR`