## Context

El módulo `zsh/modules/devops/` sigue una arquitectura de tres capas (`config/` → variables de entorno con prefijo `DEVOPS_<TOOL>_`; `internal/` → funciones privadas `devops::<tool>::internal::*`; `pkg/` → API pública `devops::<tool>::*`), con registro de tools en el array `DEVOPS_TOOLS` de `config/base.zsh`. Docker Compose es un CLI standalone sin shell hooks, por lo que aplica el patrón PATH-only cuya referencia canónica en el módulo es bruno. La guía `docs/guides/implement-tool-in-module.md` define el checklist y los anti-patterns. Ver proposal.md para motivación y specs/devops-docker-compose/spec.md para requerimientos.

## Goals / Non-Goals

**Goals:**
- Integrar docker-compose con la arquitectura de tres capas del módulo devops.
- Seguir el patrón PATH-only: guard `core::exists`, acceso vía PATH, sin `eval` ni keybindings.
- Registro en `DEVOPS_TOOLS` y feedback con `message_*`.

**Non-Goals:**
- No implementar shell hooks (completions, keybindings, history) — docker-compose no lo requiere.
- No crear capa `data/` con templates — no hay configuración sensible que renderizar con gomplate.
- No modificar la spec existente del módulo devops (`openspec/specs/devops/spec.md`).

## Decisions

1. **Patrón PATH-only sobre shell hooks** — docker-compose es un CLI standalone sin integración con el shell (no `eval "$(docker-compose init zsh)"`). Se replica el patrón de bruno: `load` solo verifica existencia con `core::exists docker-compose` y retorna; el acceso se da vía PATH. *Alternativa descartada:* patrón atuin (eval + path::prepend + INIT_FLAGS), innecesario aquí.
2. **Variables de instalación no hardcodeadas** — el comando de instalación vive en `DEVOPS_DOCKER_COMPOSE_INSTALL_CMD` (config), nunca inline en internal/pkg. *Alternativa descartada:* `brew install docker-compose` inline — viola la guía.
3. **Auto-install vía `main::factory`** — la factory en internal se invoca al source y llama a install solo si `core::exists docker-compose` falla; expuesta públicamente por `devops::docker-compose::install`.
4. **Convenciones estrictas** — prefijo `devops::docker-compose::` (doble colon), shebang `#!/usr/bin/env ksh`, feedback con `message_info`/`message_success`/`message_error` (prohibido `echo`).

## Risks / Trade-offs

- [docker-compose ya instalado vía otro gestor] → Mitigación: el guard `core::exists` hace el load idempotente; la instalación solo se dispara si el binario falta.
- [El comando de instalación por defecto puede fallar en distribuciones sin Docker CLI previo] → Mitigación: configurable vía `DEVOPS_DOCKER_COMPOSE_INSTALL_CMD`; el error se reporta con `message_error` sin romper el load.
- [Registro en DEVOPS_TOOLS afecta `DEVOPS_PACKAGES` y flujos de gestión de paquetes] → Mitigación: cambio mínimo (una entrada en el array), consistente con el resto de tools.