## Why

Neovim es el editor principal en el flujo de trabajo diario. Actualmente no hay un módulo Zsh dedicado que gestione la configuración de nvimrc (LazyVim) — instalación, actualización y limpieza de forma automatizada. Esto obliga a gestionar ~/.config/nvim manualmente, sin integración con el ecosistema de dotfiles. El módulo nvim existente tiene el scaffold pero su approach actual (git clone desde GitHub) no sigue el patrón establecido que usan otros módulos como hyprland, donde la configuración se almacena localmente en `data/` y se sincroniza vía rsync.

## What Changes

- **Migrar a patrón data/ + rsync**: En lugar de clonar nvimrc desde GitHub, los archivos de configuración de nvimrc se almacenan en `zsh/modules/nvim/data/` y se sincronizan a `~/.config/nvim` mediante `rsync`, exactamente como hace el módulo hyprland.
- **Completar capa config**: Agregar variable `NVIM_FILE_SETTINGS` faltante que `editnvim` referencia pero nunca se define.
- **Robustecer capa internal**: Implementar `install`/`upgrade`/`clean` con manejo de errores siguiendo el patrón hyprland. `install` = rsync data/ → config path. `upgrade` = re-sync. `clean` = remove caches.
- **Refinar capa pkg**: Asegurar que `nvim::install`, `nvim::upgrade`, `nvim::clean`, `nvim::sync` y helpers (`editnvim`, alias `vim`) funcionen correctamente.
- **Auto-instalación condicional**: La recarga del módulo sincroniza data/ automáticamente si no existe el directorio de configuración.
- **Taskfile.yml**: Añadir tarea de linting con `luac -p` sobre los archivos `.lua` en data/, igual que hyprland.

## Capabilities

### New Capabilities
- `nvim-module`: Módulo Zsh completo para Neovim siguiendo el patrón arquitectónico del módulo hyprland (config/ → internal/ → pkg/ con OS dispatch, configuración en data/ sincronizada via rsync). Cubre instalación, actualización, limpieza de cachés, auto-instalación al cargar, alias y helpers.

### Modified Capabilities
Ninguna. Es una incorporación nueva.

## Impact

- **Nuevo módulo**: `zsh/modules/nvim/` — completa los archivos ya scaffolded en config/internal/pkg y añade `data/` con los archivos de configuración de nvimrc.
- **Sin cambios breaking**: No se modifican módulos existentes.
- **Fuente de configuración local**: `/home/lucho/Projects/src/github.com/luismayta/nvimrc` — repositorio local de nvimrc del cual se copian los archivos a `data/`.
- **Referencia arquitectónica**: `zsh/modules/hyprland/` como módulo de referencia para el patrón data/ + rsync.
