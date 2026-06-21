## Context

El módulo nvim de dotfiles sigue la arquitectura estándar de 3 capas con OS dispatch, tomando como referencia directa el módulo hyprland (`zsh/modules/hyprland/`):

- **data/**: Archivos de configuración de nvimrc (Lua, JSON, etc.) — la fuente de verdad de la configuración Neovim
- **config/**: Variables de entorno con valores por defecto y overrides por SO
- **internal/**: Lógica de instalación (rsync), actualización (resync) y limpieza de nvimrc
- **pkg/**: API pública (sync, install, upgrade, clean, aliases, helpers)

El scaffold del módulo ya existe pero tiene los siguientes problemas:
- `NVIM_FILE_SETTINGS` se referencia en `editnvim` pero nunca se define
- La auto-instalación en `internal/main.zsh` corre siempre al cargar el módulo
- El approach actual usa `git clone` desde GitHub, en vez del patrón data/ + rsync que usan módulos como hyprland
- No hay manejo de errores en install/upgrade/clean
- Los OS dispatch files (linux.zsh, osx.zsh) están vacíos en las 3 capas
- No existe data/ con los archivos de configuración de nvimrc
- No existe Taskfile.yml para linting

## Goals / Non-Goals

**Goals:**
- Almacenar configuración nvimrc en `data/` y sincronizar via rsync al `NVIM_CONFIG_PATH`
- Completar todas las variables de entorno necesarias en config/base.zsh
- Implementar install/upgrade/clean con manejo de errores siguiendo el patrón hyprland
- Auto-instalar (sync) nvimrc condicionalmente solo si no existe y sin bloquear
- Refinar el helper editnvim y alias vim → nvim
- Añadir Taskfile.yml con linting de archivos Lua en data/
- Copiar configuración desde `/home/lucho/Projects/src/github.com/luismayta/nvimrc` a `data/`

**Non-Goals:**
- No se modifica el entry point plugin.zsh (ya funciona correctamente, sigue el patrón hyprland)
- No se agregan dependencias externas de red (la configuración es local en data/)
- No se modifica la configuración de Neovim en sí — nvimrc se gestiona en data/

## Decisions

| Decisión | Opción Elegida | Alternativas | Razón |
|---|---|---|---|
| Estrategia de configuración | `data/` + `rsync` (patrón hyprland) | git clone desde GitHub | Sigue la arquitectura establecida del proyecto; la configuración es parte del dotfiles, no una dependencia externa |
| Sincronización | `rsync -avzh --progress "${NVIM_PATH}/data/" "${NVIM_CONFIG_PATH}/"` | cp -r, install | rsync es idempotente, verboso, y es el estándar en el proyecto (hyprland lo usa) |
| NVIM_FILE_SETTINGS | `"${NVIM_CONFIG_PATH}/lua/config/options.lua"` | init.lua | options.lua es el archivo canónico de settings en nvimrc LazyVim |
| Auto-instalación | Guard condicional `if [[ ! -d ... ]]` en plugin.zsh (post pkg) | Hook separado | Sigue el patrón exacto de hyprland en plugin.zsh |
| Limpieza de cachés | `rm -rf` silencioso con `2>/dev/null \|\| true` | Con verificación previa | Sigue el patrón establecido, evita errores |
| OS dispatch linux.zsh | macOS: brew path check para nvim | No hacer dispatch | Brew puede instalar nvim en /opt/homebrew vs /usr/local |
| OS dispatch osx.zsh | Linux: XDG data/cache/state paths | Usar siempre ~/.local | XDG es el estándar en Linux |
| Linting | Taskfile.yml con `luac -p` sobre `data/**/*.lua` | Sin linting | Sigue el patrón hyprland que ya tiene Taskfile.yml |
| Fuente de configuración | `/home/lucho/Projects/src/github.com/luismayta/nvimrc` | Clonar de GitHub | Tenemos el repo local; la configuración se copia a data/ manualmente |

## Risks / Trade-offs

- **Riesgo: data/ se desincroniza de nvimrc upstream** → La actualización es manual: copiar los archivos actualizados de nvimrc a data/. Trade-off aceptado a cambio de tener la configuración como parte del dotfiles.
- **Riesgo: rsync sobrescribe cambios locales del usuario** → rsync siempre sobreescribe. El usuario debe hacer commit de sus cambios en data/ primero.
- **Trade-off: Auto-instalación en cada shell** → Solo ocurre si el directorio no existe (una vez). Es intencional: si alguien borra nvimrc, se reinstala automáticamente.
- **Trade-off: editnvim depende de EDITOR** → Si no está set, muestra error claro y abre el directorio como fallback.
