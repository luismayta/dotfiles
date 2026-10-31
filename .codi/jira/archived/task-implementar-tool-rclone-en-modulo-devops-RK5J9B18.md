# Task: Implementar tool rclone en módulo devops

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Integrar rclone como tool del módulo devops siguiendo la guía implement-tool-in-module
- component: DevOps
- labels: [rclone, devops, tool]
- parentEpic: 
- issueKey: RD-264
- jpdSource: 

## Scenario

El módulo `zsh/modules/devops/` sigue la arquitectura de tres capas (`config/` -> `internal/` -> `pkg/`). Se necesita integrar [rclone](https://rclone.org/) — programa de sincronización y copia de archivos en la nube multi-provider (S3, Google Drive, SFTP, etc.) — como un tool nuevo del módulo, siguiendo la guía `docs/guides/implement-tool-in-module.md`.

rclone es un CLI independiente sin shell hooks (sin keybindings ni completions de shell), por lo que aplica el patrón **PATH-only** (ver referencias: caddy, bruno). La instalación se hace con el package manager nativo mediante `core::install "${DEVOPS_RCLONE_PACKAGE_NAME}"`.

El tool debe quedar registrado en `DEVOPS_TOOLS`, cableado en los tres `main.zsh`, exponer API pública `devops::rclone::*` y auto-instalarse vía `main::factory` cuando falte.


### Acceptance Tests

- Existe `config/rclone.zsh` con variables `DEVOPS_RCLONE_*` (PACKAGE_NAME, CONFIG_DIR) y shebang `#!/usr/bin/env ksh`
- Existe `internal/rclone.zsh` con funciones `devops::rclone::internal::load`, `devops::rclone::internal::install`, `devops::rclone::internal::upgrade`, `devops::rclone::internal::main::factory`
- `internal::load` tiene guard `if ! core::exists rclone; then return; fi`
- `internal::install` usa `core::install "${DEVOPS_RCLONE_PACKAGE_NAME}"` (sin comandos hardcodeados) con `message_info` / `message_success`
- Existe `pkg/rclone.zsh` con wrappers públicos `devops::rclone::install`, `devops::rclone::upgrade`, `devops::rclone::post_install` (post_install con guidance de rclone: `rclone config`, `rclone listremotes`)
- `rclone` agregado al array `DEVOPS_TOOLS` en `config/base.zsh`
- Cableado con `source` en `config/main.zsh`, `internal/main.zsh` y `pkg/main.zsh`
- El módulo carga sin errores: `source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh`
- `type devops::rclone::install` devuelve "function"
- Auto-install funciona: si `rclone` no está instalado, cargar el módulo dispara la instalación
- No se usa `echo` para output (solo `message_info` / `message_success` / `message_error`) ni prefijos con un solo guion bajo (`devops_rclone_`)


### Sources

- https://rclone.org/
- docs/guides/implement-tool-in-module.md
- Referencias de implementación: `zsh/modules/devops/config/caddy.zsh`, `internal/caddy.zsh`, `pkg/caddy.zsh` (patrón PATH-only + core::install)
- Referencias: `zsh/modules/devops/config/bruno.zsh`, `internal/bruno.zsh`, `pkg/bruno.zsh`

- https://github.com/luismayta/dotfiles.git
