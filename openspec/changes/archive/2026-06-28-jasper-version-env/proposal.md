## Why

Actualmente las versiones de herramientas (Go, Flutter, Android SDK, fnm, etc.) se definen de manera inconsistente entre módulos: algunas usan `JASPER_` prefix override (`goenv`), otras usan `${VAR:-default}` sin prefix (`mobile/flutter`), y otras tienen valores hardcodeados sin posibilidad de override externo (`core/env.zsh`). Esto impide centralizar la gestión de versiones desde un solo punto (`.customrc` o bootstrap) y obliga a modificar archivos del dotfiles para cambiar una versión.

## What Changes

- Estandarizar todas las variables de versión en todos los módulos al patrón `export VAR="${JASPER_VAR:-default}"`
- Agregar variables `JASPER_` faltantes en: mobile (flutter, android), fnm, core/env.zsh, y cualquier otro módulo con versiones硬coded
- Documentar en cada `config/*.zsh` qué variables `JASPER_` están disponibles para override
- No romper la compatibilidad hacia atrás — los valores default se mantienen

## Capabilities

### New Capabilities

- `jasper-env-override`: Sistema de override de versiones vía variables de entorno con prefijo `JASPER_` para todos los módulos que definan versiones de herramientas

### Modified Capabilities

- *(Ninguna — no existen specs previas para estos módulos)*

## Impact

- **Módulos afectados**: `mobile` (flutter, android), `fnm`, `goenv` (ya implementado), `docker` (ya implementado)
- **Core**: `zsh/core/config/env.zsh` (versiones hardcodeadas de Android)
- **Archivos**: archivos `config/*.zsh` en cada módulo — solo cambios de variables, no de lógica interna
- **Breaking**: Ninguno — los valores default no cambian, solo se expone el override vía `JASPER_`
- **Compatibilidad**: Cualquier `JASPER_VERSION` definida en `.customrc` o entorno será respetada
