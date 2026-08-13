## Why

Docker Compose es una tool standalone de la familia DevOps que aún no está integrada en el módulo `devops`. RD-107 requiere añadirla siguiendo la arquitectura de tres capas del módulo (`config/`, `internal/`, `pkg/`) y el patrón PATH-only, para que el usuario pueda instalar, actualizar y verificar la tool desde el shell sin configuración manual.

## What Changes

- Crear `zsh/modules/devops/config/docker-compose.zsh` con variables de entorno `DEVOPS_DOCKER_COMPOSE_*` (`PACKAGE_NAME`, `INSTALL_CMD`, `CONFIG_DIR`).
- Crear `zsh/modules/devops/internal/docker-compose.zsh` con funciones privadas `devops::docker-compose::internal::*` (`load`, `install`, `upgrade`, `main::factory`).
- Crear `zsh/modules/devops/pkg/docker-compose.zsh` con la API pública `devops::docker-compose::*` (`install`, `upgrade`).
- Registrar `docker-compose` en el array `DEVOPS_TOOLS` de `zsh/modules/devops/config/base.zsh`.
- Aplicar el patrón PATH-only (referencia: bruno): guard `core::exists docker-compose` en `load`, sin `eval` ni keybindings.
- Usar `message_info`/`message_success`/`message_error` para feedback; prohibido `echo`.

## Capabilities

### New Capabilities
- `devops-docker-compose`: integración de la tool standalone docker-compose en el módulo devops con arquitectura de tres capas y patrón PATH-only (config, internal, pkg + registro en DEVOPS_TOOLS).

### Modified Capabilities
<!-- Ninguna: no cambian requerimientos de specs existentes -->

## Impact

- `zsh/modules/devops/config/docker-compose.zsh` (nuevo)
- `zsh/modules/devops/internal/docker-compose.zsh` (nuevo)
- `zsh/modules/devops/pkg/docker-compose.zsh` (nuevo)
- `zsh/modules/devops/config/base.zsh` (registro en `DEVOPS_TOOLS`)
- Referencias de patrón: `zsh/modules/devops/{config,internal,pkg}/bruno.zsh` (PATH-only), `atuin.zsh` (shell hooks, no aplica)
- Guía: `docs/guides/implement-tool-in-module.md`
- Trazabilidad: RD-107