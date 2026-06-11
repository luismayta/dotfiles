## Why

El pipeline de instalación (`install.sh` → `run.sh` → `bootstrap.sh` → `functions.sh`) tiene bugs residuales que rompen o degradan la experiencia curl|bash: códigos de salida incorrectos, rutas hardcodeadas, referencias sin guard, y un tool install (`git-extras`) que usa `sudo` y frena la instalación automática.

## What Changes

- **run.sh**: Fix `exit 1` a `exit 0` en TEST mode; agregar guard para bootstrap.sh faltante
- **functions.sh**: Reemplazar ruta hardcodeada `~/.dotfiles` por `${PATH_REPO}`
- **install.sh**: Corregir redirect `>>/dev/null` a `>/dev/null` en `program_exists`
- **tools/git-extras**: Mitigar `sudo` para que no bloquee curl|bash — reemplazar por instalación sin sudo o mover a instalación manual

## Capabilities

### New Capabilities
- `git-extras-install`: Instalación de git-extras que no requiere sudo, compatible con curl|bash

### Modified Capabilities
<!-- No existing capabilities change at spec level -->

## Impact

- `provision/script/run.sh`: 2 líneas
- `provision/script/functions.sh`: 1 línea
- `install.sh`: 1 línea
- `tools/git-extras/install.sh`: refactor completo