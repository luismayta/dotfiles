# Task: Implementar tool rea en módulo ai

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Integrar REA (rea-agents) en zsh/modules/ai/ con capas config/internal/pkg y sus 4 puntos de registro
- component: 
- labels: [ai,tool]
- parentEpic: 
- issueKey: RD-245
- jpdSource: 

## Scenario

**REA (Reverse Engineer Anything)** — https://rea.tools/ — es un toolkit local de ingeniería inversa para agentes AI distribuido como paquete npm `rea-agents` (v6.7.0, repo `morluto/rea`, MIT). Ofrece: servidor MCP con 172+ tools, 6 prompts MCP guiados (`investigate_feature`, `compare_application_versions`, `verify_reconstruction`, `trace_crash`, `audit_residual_unknowns`, `prepare_bounded_process_capture`), skill `reverse-engineer-anything` instalable en `~/.agents/skills` y CLI `rea` (PATH-only, sin hooks de shell). Sin autenticación ni API key; requiere Node.js ≥22.19; instalación vía `npx rea-agents@latest setup`, `npm/bun install --global rea-agents` o curl installer a `~/.local/bin/rea`.

El módulo `zsh/modules/ai/` gestiona tools AI con arquitectura de tres capas (`config/`, `internal/`, `pkg/`) y registro en el array `ZSH_AI_TOOLS`. Esta task agrega `rea` al módulo siguiendo las convenciones REALES del módulo — prefijos `ZSH_AI_REA_*` y funciones `ai::internal::rea::*` (orden invertido respecto a la guía `docs/guides/implement-tool-in-module.md`, que es devops-céntrica: `DEVOPS_*` / `devops::<tool>::internal::*` / `main::factory` NO aplican aquí) — y el patrón PATH-only de referencia `tuicr` / `freellmapi`.

Alcance de integraciones (resultado de investigación):
- Tools MCP y prompts MCP: son agent-side — la task los documenta como disponibles para el agente; no se implementan en zsh.
- Zsh-ownable: (1) instalación del CLI con gate de Node ≥22.19, (2) gestión de la skill `reverse-engineer-anything` en `~/.agents/skills` (vía `rea setup` o sync propio), (3) wrappers de subcomandos CLI, (4) registro MCP del agente (p. ej. OpenCode `mcp.rea`) templátizado si se implementa.
- Referencias en repo: `openspec/specs/ai-freellmapi/spec.md` (4 puntos de registro obligatorios) y `openspec/changes/archive/2026-10-13-add-freellmapi-tool/tasks.md`.


### Acceptance Tests

1. Creados `config/rea.zsh`, `internal/rea.zsh` y `pkg/rea.zsh` en `zsh/modules/ai/` con header `# shellcheck shell=bash` y variables en estilo moderno `ZSH_AI_REA_*` (p. ej. `ZSH_AI_REA_INSTALL_URL`, no `ZSH_AI_INSTALL_URL_REA`).
2. `internal/rea.zsh` define `ai::internal::rea::load` (guard de existencia + PATH) y `ai::internal::rea::install` (guard `core::exists`, mensajes `message_info`/`message_success`/`message_error`, instalación npm/bun/curl con gate de Node ≥22.19).
3. `pkg/rea.zsh` expone `ai::rea::install`, wrappers de subcomandos (p. ej. `ai::rea::doctor`, `ai::rea::setup`) y `ai::rea::post_install` con guía de uso.
4. Registrado en los 4 puntos obligatorios: `config/base.zsh` (source + entrada `rea` en `ZSH_AI_TOOLS`), `internal/main.zsh` (source + llamada `ai::internal::rea::load`), `pkg/main.zsh` (source), `internal/tools.zsh` (branch `rea)` explícito en el `case`, sin caer al fallback `*)`).
5. Gestión de la skill cubierta: instalación/actualización de `reverse-engineer-anything` en `~/.agents/skills`, o decisión documentada de dejarla a `rea setup`.
6. Tools/prompts MCP (172+ tools, 6 prompts) documentados como disponibles del lado del agente; registro MCP del agente templátizado si aplica.
7. Verificación: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh` sin errores; `type ai::rea::install` responde `function`; con `rea` ausente el install se dispara correctamente.
8. Anti-patrones evitados: sin `eval` en `config/`, sin rutas absolutas (usar `${HOME}`/`${ZSH_AI_PATH}`), sin `echo` (usar `message_*`), sin editar `README.md` directamente (regenerar vía `README.yaml` + `task readme`).


### Sources

- https://rea.tools/
- https://github.com/morluto/rea
- https://www.npmjs.com/package/rea-agents
- https://github.com/morluto/rea/blob/main/docs/mcp-contracts.md
- https://github.com/morluto/rea/blob/main/docs/mcp-prompts.md
- https://github.com/morluto/rea/blob/main/docs/installation.md
- https://github.com/morluto/rea/blob/main/docs/client-configuration.md
- https://github.com/morluto/rea/blob/main/install.sh
- docs/guides/implement-tool-in-module.md
- openspec/specs/ai-freellmapi/spec.md

- https://github.com/luismayta/dotfiles.git