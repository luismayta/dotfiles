---
# Migrate Antidote to zsh/system
---

## Why

Antidote (plugin manager de zsh) se instala hoy desde `tools/antidote/install.sh`, un instalador suelto que es el único resto del mecanismo genérico de `provision` (`APPS` + `TOOLS_PATH`). El resto de instalaciones ya se consolidó en módulos autocontenidos de `zsh/system/` (patrón `nix`); migrar antidote elimina la última dependencia del framework `tools/` y permite borrar ese mecanismo muerto.

## What Changes

- **NEW** módulo de sistema `zsh/system/antidote/` siguiendo el patrón `nix` (`plugin.zsh` + capas `config/`, `internal/`, `pkg/`):
  - Install idempotente en `internal/`: clona `https://github.com/mattmc3/antidote.git` (depth 1) a `${ZDOTDIR:-$HOME}/.antidote` solo si no existe (guard), con `message_info`.
  - Init en `pkg/` como función pública `antidote::init`: sourcea `${ANTIDOTE_PATH}/antidote.zsh`, concatena `zsh/zsh_plugins.txt` + `~/.custom_zsh_plugins.txt` a `~/.zsh_plugins.txt` y ejecuta `antidote load ~/.zsh_plugins.txt`.
  - Registro opcional de `antidote::setup` para `dotfiles::setup`.
- **MODIFIED** `zsh/zshrc`: el bloque L73-80 (source + concat + load) se reemplaza por `antidote::init` en la misma posición, preservando el orden de carga.
- **REMOVED** `tools/antidote/install.sh` y el directorio `tools/` completo. **BREAKING**: se elimina el mecanismo de instalación genérico de provision — `APPS=("antidote")` en `provision/script/config/base.sh`, el bucle `dotfiles_install_apps` en `provision/script/functions.sh` y `TOOLS_PATH` en `provision/script/bootstrap.sh`.
- Se mantiene la variable `ANTIDOTE_PATH` (convención `_PATH` ya establecida en el change `rename-dir-vars-to-path`).

## Capabilities

### New Capabilities

- `antidote-module`: Módulo de sistema zsh que instala el plugin manager antidote de forma idempotente y gestiona su init (carga de bundles desde `zsh_plugins.txt` + custom), siguiendo el patrón de módulos de `zsh/system/`.

### Modified Capabilities

<!-- Ninguna: no hay spec viva que cambie de requirement (el mecanismo tools/ de provision no tiene spec). -->

## Impact

- **Código eliminado**: `tools/antidote/install.sh`, `tools/` (directorio), `APPS` + `dotfiles_install_apps` + `TOOLS_PATH` en `provision/script/`.
- **Código nuevo**: `zsh/system/antidote/` (`plugin.zsh`, `config/`, `internal/`, `pkg/`).
- **Código modificado**: `zsh/zshrc` (L73-80 → `antidote::init`).
- **Datos**: `zsh/zsh_plugins.txt` se conserva como fuente de bundles.
- **Runtime**: el install deja de ocurrir en el bootstrap de provision y pasa a auto-install al cargar el shell (patrón `core::ensure` de los módulos system); el orden de carga de plugins no cambia.
- **Dependencias**: git (ya requerido); ninguna nueva.
