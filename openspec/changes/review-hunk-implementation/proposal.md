## Why

Hunk (`modem-dev/hunk`) es un visor de diff interactivo review-first diseñado específicamente para revisar cambios generados por agentes AI, con soporte para anotaciones inline, layouts responsivos y modo daemon para sesiones en vivo. Actualmente tiene integración parcial en el ecosistema: está instalable vía `npm`, tiene variables de entorno, carga de PATH, y funciones wrapper, pero la implementación tiene varias inconsistencias con el resto del módulo AI y omite capacidades clave como el manejo completo del daemon, el skill de agente AI, la integración como git difftool/pager, y la sincronización de configuración completa. Revisar y corregir la implementación asegura que hunk sea tan robusto como las otras herramientas del módulo (opencode, pi, rtk) y que se pueda usar de forma óptima tanto en terminal como desde agentes AI.

## What Changes

- **Uniformar sincronización de configuración**: Migrar `ai::hunk::config::sync` de `cp` a `rsync` (consistente con opencode/pi/rtk) y crear `ai::internal::hunk::config::sync`
- **Gestión completa del daemon**: Agregar `ai::hunk::daemon::stop`, `ai::hunk::daemon::status`, `ai::hunk::daemon::restart`
- **Integración con skill de agente AI**: Exponer `hunk skill path` como función `ai::hunk::skill::path` y documentar su uso en el comando `hadx-review`
- **Config template completo**: Actualizar `data/hunk/config.toml` con campos faltantes: `mode`, `vcs`, `watch`, `exclude_untracked`, `pager` y documentación actualizada
- **Sesiones de agente**: Agregar función `ai::hunk::session::list` y comando wrapper para listar sesiones activas del daemon
- **Git difftool/pager**: Evaluar y documentar configuración de hunk como `core.pager` y `diff.tool` en git
- **Zed keymaps**: Corregir comentario engañoso "Git Hunks" en `keymap.json` (son hunks nativos de Zed, no del CLI hunk)
- **Comando `hadx-review`**: Mejorar con manejo de errores, ciclo de vida del daemon, y detección de flags correcta

## Capabilities

### New Capabilities
- `hunk-daemon-lifecycle`: Gestión completa del ciclo de vida del daemon (start, stop, status, restart, session list)
- `hunk-agent-skill`: Integración del skill file de hunk para uso desde agentes AI (opencode/claude)

### Modified Capabilities
- `plugin-ai`: Actualizar la implementación de hunk en el módulo AI para que sea consistente con el patrón del resto de herramientas (config sync vía rsync, internal/public API simétrica)

## Impact

- **`zsh/modules/ai/`**: Modificaciones en `internal/base.zsh`, `pkg/helper.zsh`, `pkg/alias.zsh`, `data/hunk/config.toml`, y posiblemente `data/opencode/commands/hadx-review.md`
- **`zsh/modules/zed/`**: Corrección menor en `data/keymap.json` (comentario)
- **Archivos de configuración git**: Posible adición de configuración opcional de hunk como pager/difftool
- Sin breaking changes — todas las funciones existentes mantienen su firma y comportamiento
