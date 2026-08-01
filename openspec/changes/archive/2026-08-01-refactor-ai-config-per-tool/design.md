## Context

La capa `config/` del módulo AI tiene un estado híbrido: 6 tools (opencode, fabric, ollama, graphify, openspec, skills) tienen archivo propio, pero 6 más (shimmy, openclaw, codegraph, rtk, hunk, pi) están agregados en `config/tools.zsh`; `base.zsh` declara 10 `AI_INSTALL_URL_*` y `AI_OLLAMA_MODELS` pese a que su header afirma que las variables de dominio viven en archivos propios; `hf` y `tmuxai` no tienen config; y existe duplicación de `AI_INSTALL_URL_SHIMMY` (base + plataforma) junto con naming inconsistente (registry `codegraph` vs archivo `graphify.zsh` vs `AI_INSTALL_URL_CODEGRAPH`).

La guía `docs/guides/implement-tool-in-module.md` (Step 1) exige `config/<tool>.zsh` por tool con prefijo `<MODULE>_<TOOL>_`, y el módulo de referencia `devops` lo ejemplifica (atuin, bruno, direnv, tfenv, worktrunk cada uno con su archivo).

Restricciones: las capas `internal/` y `pkg/` referencian estas variables por nombre; el change `standardize-ai-tools` (en curso) toca `pkg/tools.zsh` e `internal/tools.zsh` con otro objetivo.

## Goals / Non-Goals

**Goals:**
- Un archivo `config/<tool>.zsh` por cada tool registrado en `AI_TOOLS`.
- `base.zsh` reducido a concerns cross-cutting + registry `AI_TOOLS` (patrón `DEVOPS_TOOLS`).
- URLs de instalación colocalizadas con su tool.
- Cero renombramientos de variables existentes — solo movimiento entre archivos.
- Eliminar la URL shimmy muerta de `base.zsh`.
- Naming consistente graphify/codegraph sin romper el instalador.

**Non-Goals:**
- Modificar `internal/` o `pkg/` (alcance de `standardize-ai-tools`).
- Renombrar variables `AI_<TOOL>_*`.
- Añadir/eliminar tools o cambiar comandos de instalación.
- Refactorizar `base.zsh` del módulo devops (es la referencia, fuera de alcance).

## Decisions

**D1 — Split de `tools.zsh` en 6 archivos por tool.**
`tools.zsh` → `shimmy.zsh`, `openclaw.zsh`, `codegraph.zsh`, `rtk.zsh`, `hunk.zsh`, `pi.zsh`, cada uno con sus vars (`AI_<TOOL>_BIN_PATH`, `_CONFIG_PATH`, `_CONFIG_SOURCE_PATH`). *Alternativa considerada*: mantener `tools.zsh` como archivo de "tools menores" — rechazada: viola la guía y dificulta la descubribilidad.

**D2 — Colocalizar `AI_INSTALL_URL_*` en su tool file.**
Cada URL migra al `config/<tool>.zsh` correspondiente (opencode, fabric, ollama, shimmy, hf, openclaw, codegraph, tmuxai, rtk, pi, skills). *Alternativa*: mantenerlas en base — rechazada: contradice el contrato declarado del propio `base.zsh`.

**D3 — `AI_OLLAMA_MODELS` → `ollama.zsh`.**
El modelo de lista se agrupa con `AI_OLLAMA_MODELS_PATH` en un solo archivo de dominio.

**D4 — Crear `hf.zsh` y `tmuxai.zsh`.**
Completan el registry: cada entry de `AI_TOOLS` debe tener archivo de config (aunque sea mínimo con la URL/`BIN_PATH`).

**D5 — Shimmy: la URL arch-específica vive solo en plataforma.**
Se elimina la definición genérica de `base.zsh` (código muerto: siempre sobrescrita). `linux.zsh`/`osx.zsh` mantienen el override con `AI_ARCHITECTURE_NAME`. *Alternativa*: definir en `shimmy.zsh` con condicional de OSTYPE — rechazada: duplica el patrón de plataforma que ya usan linux/osx.

**D6 — Naming canónico graphify/codegraph.**
El archivo de config, las vars `AI_GRAPHIFY_*` y las funciones `graphify::*` ya usan `graphify`. La renominación del entry del registry (`codegraph` → `graphify`) y de `AI_INSTALL_URL_CODEGRAPH` depende de cómo `internal/tools.zsh` resuelve URLs — verificar antes (Open Question). Si el registry está acoplado al binario, se conserva el entry y solo se alinea el archivo/vars.

## Risks / Trade-offs

- **[Movimiento de vars rompe referencia en internal/pkg]** → Mitigación: grep de cada var migrada tras el cambio + test de carga del módulo.
- **[Renombrar registry entry `codegraph` rompe instalación]** → Mitigación: verificar la keying de `internal/tools.zsh::packages::install` antes de renombrar; si está acoplado, no renombrar el entry (Open Question O1).
- **[Double-source / redefinición al migrar]** → Mitigación: un solo dispatcher en `base.zsh`; eliminar `tools.zsh`; `zsh -n` en cada archivo.
- **[Conflicto con change `standardize-ai-tools`]** → Mitigación: este refactor toca solo `config/`; los cambios de función no solapan archivos, pero coordinar orden de merge.
- **[Regresión silenciosa en carga del módulo]** → Mitigación: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh` y verificar `type ai::*` + vars con `printenv`.

## Migration Plan

1. Crear los 8 archivos de config (6 del split + `hf.zsh` + `tmuxai.zsh`) con las vars movidas.
2. Adelgazar `base.zsh`: quitar URLs y `AI_OLLAMA_MODELS`; actualizar la lista de `source`; mantener `AI_TOOLS`.
3. Eliminar `tools.zsh`.
4. Verificación: `zsh -n` por archivo, grep de vars, test de carga del módulo.
5. Rollback: `git revert` del commit del refactor (sin migración de datos involucrada).

## Open Questions

- **O1 — RESUELTO (dos tools)**: `codegraph` y `graphify` son tools distintas y reales. Evidencia: MCP server `codegraph` (SQLite, `.codegraph/`) coexiste con el skill `graphify` (`graphify-out/`); instaladores diferentes (curl vs `uv tool install graphifyy[all]`). El registry `AI_TOOLS` usa entries como claves de dispatch en el `case` de `packages::install` — el branch `graphify)` ya existe (internal/tools.zsh:68). Decisión: añadir `graphify` al registry (el case muerto se vuelve alcanzable), conservar `codegraph` con su archivo `config/codegraph.zsh`, y mantener `config/graphify.zsh` para la familia graphify.
- **O2 — RESUELTO**: `openspec.zsh` permanece reservado (sin vars; openspec no está en `AI_TOOLS`).

## Alcance extendido (aprobado)

Tras la revisión de `internal/` y `pkg/`, ambos tienen el mismo anti-patrón catch-all que tenía `config/tools.zsh`: `internal/tools.zsh` (6 tools) y `pkg/tools.zsh` (7 tools). Además `internal/main.zsh` no invoca `ai::internal::openclaw::load` (H4). Estos splits se ejecutan en el mismo change (secciones 8-10 de tasks.md), coordinados con el change `standardize-ai-tools` que también toca `internal/tools.zsh`.
