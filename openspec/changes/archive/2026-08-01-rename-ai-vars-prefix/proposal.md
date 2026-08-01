## Why

Tras renombrar `AI_PATH` → `ZSH_AI_PATH`, el módulo AI quedó con un namespace mixto: el flag (`ZSH_AI_ENABLED`), el guard (`__ZSH_AI_LOADED`) y el path raíz (`ZSH_AI_PATH`) usan prefijo `ZSH_AI_`, pero las ~47 variables de tool (`AI_TOOLS`, `AI_OPENCODE_*`, `AI_INSTALL_URL_*`, `AI_OLLAMA_MODELS`, `AI_PACKAGE_NAME`...) siguen con prefijo `AI_`. Estandarizar todo el namespace de variables a `ZSH_AI_` elimina la ambigüedad, hace la convención predecible y alinea el módulo AI con los 15 módulos que ya usan el prefijo `ZSH_<MOD>_` (ZSH_GIT_PATH, ZSH_GITHUB_PATH, ZSH_NIX_PATH...).

## What Changes

- Renombrar las ~47 variables con prefijo `AI_` del módulo AI a prefijo `ZSH_AI_` (valores y semántica idénticos, solo el prefijo):
  - `AI_TOOLS` → `ZSH_AI_TOOLS`
  - `AI_PACKAGE_NAME` → `ZSH_AI_PACKAGE_NAME`
  - Todas las `AI_<TOOL>_*` (paths, config paths, bin paths) → `ZSH_AI_<TOOL>_*`
  - Todas las `AI_INSTALL_URL_*` → `ZSH_AI_INSTALL_URL_*`
  - `AI_OLLAMA_MODELS`, `AI_APPLICATION_PATH`, `AI_ARCHITECTURE_NAME` → `ZSH_AI_*`
- **BREAKING** para consumidores externos del namespace `AI_` (no existen refs externas reales al módulo; verificado).
- NO se renombran las funciones `ai::*` / `ai::internal::*` (fuera de alcance).
- NO se toca `AI_IGNORE_CUSTOM` del Taskfile raíz (dominio Taskfile, no zsh).
- La spec `ai-config-per-tool` se actualiza: el prefijo de variables pasa a `ZSH_AI_<TOOL>_`.

## Capabilities

### New Capabilities

<!-- Ninguna: es un rename de convención, no introduce capability nueva. -->

### Modified Capabilities

- `ai-config-per-tool`: los requirements que nombran el prefijo de variables `AI_<TOOL>_` (y sus derivados `AI_TOOLS`, `AI_INSTALL_URL_*`, `AI_OLLAMA_MODELS`) se actualizan al nuevo prefijo `ZSH_AI_<TOOL>_`.

## Impact

- **Affected Code**:
  - ~35 archivos `.zsh` del módulo AI: `zsh/modules/ai/config/` (16 con `export AI_*`), `zsh/modules/ai/internal/` (15 consumidores), `zsh/modules/ai/pkg/` (4 consumidores)
  - ~180 referencias dentro del módulo
- **Specs**: `openspec/specs/ai-config-per-tool/spec.md` (requirements que citan el prefijo)
- **Sin refs externas al módulo**: verificadas 0 (las coincidencias de patrón en SKILL.md/caché Taskfile son falsos positivos; `AI_IGNORE_CUSTOM` es namespace Taskfile)
- **Seguridad del rename**: `\bAI_` no matchea dentro de `ZSH_AI_*` ni `__ZSH_AI_LOADED` (el `_` previo es word-char) → sin dobles renames
- **Dependencias**: ninguna nueva. **Sistemas**: carga del módulo zsh.
