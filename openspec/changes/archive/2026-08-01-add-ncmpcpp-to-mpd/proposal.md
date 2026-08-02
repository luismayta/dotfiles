## Why

ncmpcpp es un cliente NCurses para MPD que ofrece una interfaz rica en terminal para navegar y reproducir música. Actualmente el módulo mpd solo incluye `mpc` (CLI básico) pero no tiene un cliente interactivo. Agregar ncmpcpp completa la experiencia de playback musical en terminal.

## What Changes

- Agregar `ncmpcpp` como paquete dependiente del módulo mpd
- Crear configuración base de ncmpcpp (colores, atajos, visualización)
- Agregar alias para lanzar ncmpcpp rápidamente
- Mantener compatibilidad con la estructura existente del módulo (config/internal/pkg)

## Capabilities

### New Capabilities

- `ncmpcpp-client`: Instalación, configuración y aliases del cliente NCurses para MPD

### Modified Capabilities

<!-- No hay capacidades existentes que cambien -->

## Impact

- **Archivos modificados**: `zsh/modules/mpd/config/base.zsh`, `zsh/modules/mpd/internal/base.zsh`, `zsh/modules/mpd/pkg/alias.zsh`
- **Archivos nuevos**: `zsh/modules/mpd/config/ncmpcpp.zsh`, `zsh/modules/mpd/data/ncmpcpp/config`, `zsh/modules/mpd/data/ncmpcpp/bindings`
- **Dependencias**: ncmpcpp (brew/apt)
- **Sistemas**: Reproducción musical en terminal via MPD
