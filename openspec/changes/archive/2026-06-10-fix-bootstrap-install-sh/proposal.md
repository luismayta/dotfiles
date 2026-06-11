## Why

`install.sh` es el entry point curl|bash del proyecto — es lo primero que un usuario ejecuta. Actualmente contiene 8 bugs confirmados (variables undefined, `exit` sin código, mensajes engañosos), código muerto, y lógica frágil sin manejo de errores. En un script que se ejecuta `bash -c "$(curl -fsSL ...)"`, cada fallo silencioso es una experiencia de onboarding rota. Este cambio arregla los bugs, limpia el dead code, y hardnea el bootstrap para que sea confiable en cualquier entorno.

## What Changes

- **Fix bugs en install.sh**: `APP_NAME`, `GIT_BRANCH` undefined, `exit` sin código, mensaje de éxito post-fallo de clone, variable `ret` global sin `local`, lógica de brew/pip/gem corrupta al operar sobre array equivocado.
- **Hardening de errores**: `set -euo pipefail`, errores con nombre y mensaje, abortar en fallos críticos.
- **Eliminar dead code**: `message::warning`, `message::debug`, `check_config_and_bootstrap`, TRAVIS check, comentarios fantasma, style obsoleto.
- **Soportar multi-plataforma**: remover `PATH` hardcoded a `/opt/homebrew/bin`, detectar brew dinámicamente.
- **Hardening de provision scripts**: mejorar manejo de errores en `provision/script/run.sh`.
- **Sin dependencia externa**: `install.sh` debe seguir siendo autocontenido — no importa de `zsh/core/` (no existe aún cuando se ejecuta).

## Capabilities

### New Capabilities
- `bootstrap-install`: Script de instalación bootstrap autocontenido, robusto, que corre en cualquier entorno POSIX sin dependencias externas.

### Modified Capabilities
- *(none — no hay specs existentes que modificar)*

## Impact

- **install.sh**: rewrite de ~60% del script — bugs fixeados, dead code removido, estilo estandarizado.
- **provision/script/run.sh**: hardening menor de errores.
- **provision/**: cleanup de `check_config_and_bootstrap` obsoleto.
- Dependencias, APIs, sistema de mensajes: sin cambios — el script sigue siendo 100% autocontenido.