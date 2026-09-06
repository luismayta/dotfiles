# Task: Implementar omp (Oh My Pi) coding agent en módulo AI

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Agregar omp como herramienta del módulo AI siguiendo arquitectura de tres capas
- component:
- labels: [ai,tool,omp]
- parentEpic:
- issueKey: RD-155
- jpdSource:

## Scenario

omp (Oh My Pi) es un coding agent con IDE integrado, fork de Pi by Mario Zechner.
Instalable via `curl -fsSL https://omp.sh/install | sh` o `bun install -g @oh-my-pi/pi-coding-agent`.
Config en `~/.omp/agent/`. Requiere bun >= 1.3.14.

Se debe implementar en `zsh/modules/ai/` siguiendo la guía `docs/guides/implement-tool-in-module.md` y el patrón de tres capas usado por opencode, pi, y otras herramientas del módulo.

### Acceptance Tests

- [ ] `config/omp.zsh` creado con variables `ZSH_AI_OMP_*` (BIN_PATH, CONFIG_PATH, CONFIG_SOURCE_PATH, INSTALL_URL)
- [ ] `internal/omp.zsh` creado con funciones `ai::internal::omp::load`, `ai::internal::omp::install`, `ai::internal::omp::config::sync`
- [ ] `pkg/omp.zsh` creado con funciones públicas `ai::omp::install`, `ai::omp::config::sync`
- [ ] `omp` agregado al array `ZSH_AI_TOOLS` en `config/base.zsh`
- [ ] `source` de config/omp.zsh agregado en `config/base.zsh`
- [ ] `source` de internal/omp.zsh agregado en `internal/main.zsh`
- [ ] `source` de pkg/omp.zsh agregado en `pkg/main.zsh`
- [ ] `ai::internal::omp::load` invocado en `internal/main.zsh`
- [ ] Guard `core::exists omp` presente en load
- [ ] Instalación via curl si no existe (patrón similar a pi)
- [ ] Module carga sin errores: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh`
- [ ] Función verificable: `type ai::omp::install` retorna "function"

### Sources

- https://omp.sh/
- https://omp.sh/docs/quickstart
- https://github.com/can1357/oh-my-pi
- docs/guides/implement-tool-in-module.md
- https://github.com/luismayta/dotfiles.git
