## Why

El módulo `nix` y `nix-darwin` son módulos de sistema fundamentales (proveen el gestor de paquetes Nix y la integración con nix-darwin), pero actualmente se cargan junto con el resto de módulos en `zsh/modules/` en una fase tardía del startup. Esto significa que `core/` (que carga primero) no puede depender de Nix, y módulos que sí lo necesitan tienen que esperar. Al crear `zsh/system/` y mover allí `core/`, `nix/` y `nix-darwin/`, estos se cargan en una fase temprana y dedicada, antes que los módulos regulares.

## What Changes

- Crear directorio `zsh/system/` como contenedor para módulos de sistema de carga temprana
- Mover `zsh/core/` → `zsh/system/core/`
- Mover `zsh/modules/nix/` → `zsh/system/nix/`
- Mover `zsh/modules/nix-darwin/` → `zsh/system/nix-darwin/`
- Actualizar `zshrc` para cargar `zsh/system/` antes del loop de módulos regulares
- Actualizar rutas internas (`DOTFILES_CORE_PATH`, etc.) y referencias cruzadas entre módulos
- **BREAKING**: `zsh/core/` cambia de ubicación — cualquier referencia externa a esa ruta debe actualizarse

## Capabilities

### New Capabilities
- `system-directory`: Estructura `zsh/system/` como contenedor de módulos de sistema con carga prioritaria

### Modified Capabilities
- `zshrc-load`: El archivo `zsh/zshrc` cambia para cargar `zsh/system/` + `zsh/detect/` antes del loop de módulos
- `core-api`: La variable `DOTFILES_CORE_PATH` cambia de `zsh/core/` a `zsh/system/core/`
- `internal-module-structure`: El patrón de carga de módulos se extiende para distinguir system vs modules

## Impact

- **Archivos movidos**: `zsh/core/`, `zsh/modules/nix/`, `zsh/modules/nix-darwin/` → `zsh/system/`
- **Archivos modificados**: `zsh/zshrc` (orden de carga), `zsh/core/config/paths.zsh` (DOTFILES_CORE_PATH)
- **Referencias externas**: cualquier script o documentación que referencie `zsh/core/` o `zsh/modules/nix/`
- **Sin breaking para el usuario final**: los módulos se cargan igual, solo cambia el orden y la ruta interna
