# Task: Implementar y configurar OmniRoute en el módulo ai

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Implementar OmniRoute (gateway AI) en zsh/modules/ai/ siguiendo la guía implement-tool-in-module
- component: 
- labels: [dotfiles, zsh, ai]
- parentEpic: 
- issueKey: RD-199
- jpdSource: 

## Scenario

El módulo zsh/modules/ai/ sigue una arquitectura de tres capas (config/, internal/, pkg/) con convenciones ZSH_AI_<TOOL>_ para variables, ai::internal::<tool>::<accion> para lógica privada y ai::<tool>::<accion> para la API pública. Los tools se registran en el array ZSH_AI_TOOLS (config/base.zsh) y se agregan a las funciones agregadoras ai::sync y ai::install.

OmniRoute (https://github.com/diegosouzapw/OmniRoute) es un gateway AI local-first, auto-hosted e instalable vía npm (npm install -g omniroute). Expone el binario omniroute con subcomandos (chat, setup, doctor, update, run, configure, --mcp). No provee hooks de shell → patrón PATH-only. Su configuración vive en ~/.omniroute/ (.env + storage.sqlite). Requiere Node.js >= 22.22.2 < 23 o >= 24 < 27. Se actualiza con omniroute update (internamente npm install -g omniroute@latest --include=optional).

Objetivo: implementar OmniRoute como un nuevo tool del módulo ai/ siguiendo la guía docs/guides/implement-tool-in-module.md, tomando como referencia el patrón PATH-only (bruno/caddy) y las convenciones reales del módulo (opencode).


### Acceptance Tests

- [ ] Crear config/omniroute.zsh con variables ZSH_AI_OMNIROUTE_* (PACKAGE_NAME, INSTALL_CMD, CONFIG_DIR, DATA_PATH)
- [ ] Crear internal/omniroute.zsh con ai::internal::omniroute::{load,install,upgrade,sync} y guard core::exists omniroute
- [ ] Crear pkg/omniroute.zsh con wrappers públicos ai::omniroute::{install,upgrade,sync}
- [ ] Registrar omniroute en el array ZSH_AI_TOOLS de config/base.zsh
- [ ] Sourcear las tres capas en config/main.zsh, internal/main.zsh y pkg/main.zsh
- [ ] Agregar ai::omniroute::sync a la función agregadora ai::sync en pkg/base.zsh
- [ ] El módulo carga sin errores: source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh
- [ ] type ai::omniroute::install devuelve "function"
- [ ] Auto-install funciona cuando el tool no está instalado (core::exists guard)
- [ ] No usar echo para output — usar message_info / message_success / message_error
- [ ] No hardcodear comandos de instalación — usar variables ZSH_AI_OMNIROUTE_INSTALL_* o core::install


### Sources

- https://github.com/diegosouzapw/OmniRoute
- https://github.com/diegosouzapw/OmniRoute/blob/main/README.md
- docs/guides/implement-tool-in-module.md
- zsh/modules/ai/ (referencia: opencode, fabric)

- https://github.com/luismayta/dotfiles.git
