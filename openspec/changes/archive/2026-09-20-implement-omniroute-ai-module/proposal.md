## Why

El módulo `zsh/modules/ai/` agrupa las herramientas de IA del entorno (opencode, fabric, ollama, jcode, etc.) bajo una arquitectura de tres capas (config/, internal/, pkg/). OmniRoute — un gateway AI local-first, auto-hosted e instalable vía npm — no está integrado, por lo que su instalación, configuración y actualización quedan fuera del ciclo de vida gestionado del módulo (`ai::install`, `ai::sync`, `ai::upgrade`). Integrarlo permite gestionarlo con las mismas convenciones que el resto de tools.

## What Changes

- Crear `config/omniroute.zsh` con variables `ZSH_AI_OMNIROUTE_*` (package name, install cmd, config dir, data path).
- Crear `internal/omniroute.zsh` con `ai::internal::omniroute::{load, install, upgrade, sync}` y guard `core::exists omniroute`.
- Crear `pkg/omniroute.zsh` con wrappers públicos `ai::omniroute::{install, upgrade, sync}`.
- Registrar `omniroute` en el array `ZSH_AI_TOOLS` de `config/base.zsh`.
- Sourcear las tres capas en `config/main.zsh`, `internal/main.zsh` y `pkg/main.zsh`.
- Agregar `ai::omniroute::sync` a la función agregadora `ai::sync` en `pkg/base.zsh`.
- Seguir el patrón PATH-only (sin hooks de shell): OmniRoute expone el binario `omniroute` vía npm global.

## Capabilities

### New Capabilities
- `omniroute-ai-tool`: Integración de OmniRoute como tool del módulo AI — variables de configuración, PATH loading, instalación vía npm, upgrade, sync de configuración y registro en el módulo.

### Modified Capabilities
<!-- Ninguna: los specs existentes (ai-config-per-tool, plugin-ai) ya cubren las convenciones que este cambio sigue. -->

## Impact

- **Código afectado**: `zsh/modules/ai/` — nuevos archivos `config/omniroute.zsh`, `internal/omniroute.zsh`, `pkg/omniroute.zsh`; modificaciones en `config/base.zsh` (registro), `internal/main.zsh` (source + load), `pkg/main.zsh` (source), `pkg/base.zsh` (`ai::sync`).
- **Dependencias**: Node.js >= 22.22.2 < 23 o >= 24 < 27 (runtime de OmniRoute); npm para instalación global.
- **Configuración**: `~/.omniroute/` (.env + storage.sqlite) — generada por OmniRoute en primer arranque; no requiere secrets obligatorios para uso básico.
- **Sin cambios en**: `plugin.zsh` (ya encadena las tres capas), specs existentes.