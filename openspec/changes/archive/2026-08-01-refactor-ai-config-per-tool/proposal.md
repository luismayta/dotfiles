## Why

La capa `config/` del módulo AI no respeta la separación por tool definida en `docs/guides/implement-tool-in-module.md`: 6 tools (shimmy, openclaw, codegraph, rtk, hunk, pi) viven agregados en un único `tools.zsh`, `base.zsh` concentra URLs de instalación y modelos de ollama contradiciendo su propio header, y `hf`/`tmuxai` no tienen archivo de config propio. Esto degrada la mantenibilidad, la descubribilidad y rompe la consistencia con el módulo de referencia `devops`.

## What Changes

- **Split de `config/tools.zsh`** en archivos por tool: `shimmy.zsh`, `openclaw.zsh`, `codegraph.zsh`, `rtk.zsh`, `hunk.zsh`, `pi.zsh`.
- **Migrar los 10 `AI_INSTALL_URL_*`** de `base.zsh` a cada `config/<tool>.zsh` correspondiente (p. ej. `AI_INSTALL_URL_OPENCODE` → `opencode.zsh`).
- **Mover `AI_OLLAMA_MODELS`** de `base.zsh` a `ollama.zsh` (que hoy solo define `AI_OLLAMA_MODELS_PATH`).
- **Crear `config/hf.zsh` y `config/tmuxai.zsh`** para los tools del registry que hoy carecen de variables propias.
- **Eliminar `AI_INSTALL_URL_SHIMMY` muerto de `base.zsh`** (siempre sobrescrito por `linux.zsh`/`osx.zsh`); la URL arch-específica permanece solo en los archivos de plataforma.
- **Unificar el naming codegraph/graphify**: registry `AI_TOOLS`, archivo de config y prefijo de vars deben usar el mismo nombre canónico.
- **`base.zsh` queda solo con** concerns cross-cutting (`ZSH_AI_ENABLED`, `ARCH_NAME`, `AI_PACKAGE_NAME`) + el registry `AI_TOOLS` (patrón `DEVOPS_TOOLS`).

## Capabilities

### New Capabilities

- `ai-config-per-tool`: Contrato estructural de la capa `config/` del módulo AI — un archivo de config por tool con variables `AI_<TOOL>_`, registro centralizado en `AI_TOOLS` y URLs de instalación colocalizadas con su tool.

### Modified Capabilities

<!-- Sin cambios a nivel de requisitos: la reorganización de config es detalle de implementación; ningún requerimiento existente cambia su comportamiento. -->

## Impact

- **Affected Code**:
  - `zsh/modules/ai/config/base.zsh` (adelgazado a registry + cross-cutting)
  - `zsh/modules/ai/config/tools.zsh` (eliminado o reducido a dispatcher)
  - `zsh/modules/ai/config/{shimmy,openclaw,codegraph,rtk,hunk,pi,hf,tmuxai}.zsh` (nuevos)
  - `zsh/modules/ai/config/{opencode,fabric,ollama,graphify,skills}.zsh` (reciben vars migradas)
  - `zsh/modules/ai/config/{linux,osx}.zsh` (sin cambios salvo confirmación de shimmy)
- **Sin cambios de nombres de variables** — las vars se mueven entre archivos pero no se renombran; `internal/*.zsh` y `pkg/*.zsh` siguen funcionando sin tocarse.
- **Dependencias**: ninguna nueva.
- **Sistemas**: shell zsh; carga del módulo AI vía `zsh/modules/ai/plugin.zsh`.
- **Advertencia de solapamiento**: el change `standardize-ai-tools` también toca `pkg/tools.zsh` e `internal/tools.zsh` (ciclo de vida de funciones); este refactor toca solo `config/`, sin conflicto de archivos.
