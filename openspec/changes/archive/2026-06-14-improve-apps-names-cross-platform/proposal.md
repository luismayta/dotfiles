## Why

El módulo de apps (`zsh/modules/apps/`) ya tiene una arquitectura OS-aware con archivos separados:
- `config/base.zsh` — categorías de apps comunes
- `config/osx.zsh` — apps exclusivas de macOS (raycast, unite, orbstack, arc, tunnelblick)
- `config/linux.zsh` — placeholder vacío para Linux

El problema: `config/base.zsh` hardcodea nombres de Homebrew cask de macOS (e.g., `brave-browser`, `discord`, `obsidian`) en todas las plataformas. En Linux (CachyOS/Arch) con `paru` como instalador, los nombres de paquetes son diferentes (e.g., `brave-bin`, `discord`, `obsidian-bin`). Además, el archivo carece del formato estructurado que tiene `goenv/config/base.zsh` (headers, secciones comentadas, documentación inline).

Este cambio añade soporte cross-platform real respetando la arquitectura existente: `base.zsh` define ambas variantes OS y resuelve la correcta según `$OSTYPE`, mientras que `osx.zsh` y `linux.zsh` siguen manejando apps exclusivas de cada plataforma.

## What Changes

- **Reestructurar** `zsh/modules/apps/config/base.zsh` siguiendo el formato de `goenv/config/base.zsh`: header de archivo, secciones con comentarios, declaraciones agrupadas
- **Renombrar arrays actuales** a `__DARWIN` (e.g., `APPS_BROWSER` → `APPS_BROWSER__DARWIN`) preservando todos los nombres macOS existentes
- **Añadir variantes `__LINUX`** con nombres de paquetes de Arch Linux (oficiales y AUR) para `paru`
- **Añadir bloque de resolución** al final de `base.zsh` que pobla `APPS_<CATEGORY>` según `$OSTYPE`
- **Poblar `config/linux.zsh`** con apps exclusivas de Linux (si las hay)
- **Mantener `config/osx.zsh`** sin cambios — ya funciona correctamente
- **`APPS_PACKAGES`**: sin cambios — sigue agregando los arrays resueltos

## Capabilities

### New Capabilities
- `apps-names`: Resolución cross-platform de nombres de aplicaciones por sistema operativo, con arrays `__DARWIN`/`__LINUX` en base.zsh y resolución vía `$OSTYPE`

### Modified Capabilities
- *(ninguno — refactor interno del módulo apps, no cambian specs existentes)*

## Impact

- **Modificado**: `zsh/modules/apps/config/base.zsh` — reestructuración completa con soporte Darwin + Linux
- **Modificado**: `zsh/modules/apps/config/linux.zsh` — se puebla con apps específicas de Linux
- **Sin cambios**: `zsh/modules/apps/config/osx.zsh` — se mantiene igual
- **Sin cambios**: `APPS_PACKAGES`, `plugin.zsh`, `config/main.zsh` — la resolución es transparente
- **Soporte**: macOS (brew) y Linux CachyOS/Arch (paru)
