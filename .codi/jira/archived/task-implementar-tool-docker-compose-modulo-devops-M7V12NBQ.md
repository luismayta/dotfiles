# Task: Implementar tool de docker-compose en el módulo devops

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Implementar la tool docker-compose en zsh/modules/devops/ siguiendo la guía implement-tool-in-module.md
- component: DevOps
- labels: []
- parentEpic:
- issueKey: RD-107

## Scenario

Docker Compose es una tool standalone de la familia DevOps que debe integrarse al módulo `devops` siguiendo la guía `docs/guides/implement-tool-in-module.md`.

La integración sigue la arquitectura de tres capas del módulo:
- `config/` → variables de entorno con prefijo `DEVOPS_DOCKER_COMPOSE_`
- `internal/` → funciones privadas `devops::docker-compose::internal::*` (load, install, upgrade, main::factory)
- `pkg/` → API pública `devops::docker-compose::*` (install, upgrade)

Docker Compose es un CLI standalone sin shell hooks → patrón PATH-only (referencia: bruno). El load solo verifica existencia con `core::exists` y el acceso se da vía PATH. No requiere `eval` ni keybindings.

Debe registrarse la tool en el array `DEVOPS_TOOLS` de `config/base.zsh` y respetar las convenciones de la guía (prefijos, guards, mensajes).

### Acceptance Tests

1. Crear `zsh/modules/devops/config/docker-compose.zsh` con variables `DEVOPS_DOCKER_COMPOSE_*` (PACKAGE_NAME, INSTALL_CMD, CONFIG_DIR)
2. Crear `zsh/modules/devops/internal/docker-compose.zsh` con `devops::docker-compose::internal::load`, `install`, `upgrade` y `main::factory`
3. Crear `zsh/modules/devops/pkg/docker-compose.zsh` con funciones públicas `devops::docker-compose::install` y `upgrade`
4. Registrar `docker-compose` en el array `DEVOPS_TOOLS` de `zsh/modules/devops/config/base.zsh`
5. Aplicar patrón PATH-only: guard `core::exists docker-compose` en load; sin `eval` en config
6. Usar `message_info`/`message_success`/`message_error` para feedback (prohibido `echo`)
7. No hardcodear comandos de instalación — usar variables `DEVOPS_DOCKER_COMPOSE_INSTALL_*`
8. El módulo carga sin errores: `source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh`
9. Verificar funciones disponibles: `type devops::docker-compose::install` → `function`
10. Todas las funciones usan prefijo `devops::docker-compose::` (nunca single underscore)

### Sources

- `docs/guides/implement-tool-in-module.md` — guía de implementación (checklist y anti-patterns)
- `zsh/modules/devops/config/bruno.zsh`, `internal/bruno.zsh`, `pkg/bruno.zsh` — referencia patrón PATH-only
- `zsh/modules/devops/config/atuin.zsh`, `internal/atuin.zsh`, `pkg/atuin.zsh` — referencia patrón shell hooks
- `zsh/modules/devops/config/base.zsh` — registro del array `DEVOPS_TOOLS`
- https://github.com/luismayta/dotfiles.git
