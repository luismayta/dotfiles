## Context

El módulo AI tiene un namespace de variables mixto: `ZSH_AI_PATH`, `ZSH_AI_ENABLED` y `__ZSH_AI_LOADED` usan prefijo `ZSH_AI_`, pero las ~47 variables de tool siguen con prefijo `AI_` (`AI_TOOLS`, `AI_<TOOL>_*`, `AI_INSTALL_URL_*`, `AI_OLLAMA_MODELS`, `AI_PACKAGE_NAME`, `AI_APPLICATION_PATH`, `AI_ARCHITECTURE_NAME`). La spec sincronizada `openspec/specs/ai-config-per-tool/spec.md` cita el prefijo `AI_<TOOL>_` en 12 lugares. Alcance medido: ~35 archivos `.zsh` (config 16, internal 15, pkg 4), ~180 refs, 0 refs externas al módulo.

## Goals / Non-Goals

**Goals:**
- Prefijo `ZSH_AI_` consistente en TODAS las variables del módulo AI.
- Valores y semántica intactos — solo cambia el prefijo.
- Spec `ai-config-per-tool` actualizada (MODIFIED) y re-sincronizada.
- Carga del módulo validada tras el rename.

**Non-Goals:**
- Renombrar funciones `ai::*` / `ai::internal::*` (permanecen igual; los wrappers pkg y la doc `ai::sync` no se tocan).
- Tocar `AI_IGNORE_CUSTOM` del Taskfile raíz (namespace Taskfile, no zsh).
- Estandarizar los ~16 módulos con prefijo bare (`DEVOPS_PATH`, `TMUX_PATH`, `HYPRLAND_PATH`...) — esfuerzo global separado.

## Decisions

**D1 — Alcance: TODAS las vars `AI_*` del módulo, no solo las de tool.**
Incluye `AI_TOOLS`, `AI_PACKAGE_NAME`, `AI_APPLICATION_PATH`, `AI_ARCHITECTURE_NAME`, `AI_OLLAMA_MODELS` además de `AI_<TOOL>_*` y `AI_INSTALL_URL_*`. *Alternativa*: solo las vars de tool — rechazada: deja el namespace mixto que se quiere eliminar.

**D2 — Mecánica: `sed -E 's/\bAI_/ZSH_AI_/g'` sobre los 35 archivos del módulo.**
`\b` (word boundary) no matchea dentro de `ZSH_AI_PATH` ni `__ZSH_AI_LOADED` (el `_` previo es word-char) → sin dobles renames. *Alternativa*: `replaceAll` por var (47 vars × archivos) — rechazada: más lento y con riesgo de orden de reemplazo entre prefijos compartidos. *Nota*: en BSD sed (macOS) usar `[[:<:]]AI_` en lugar de `\b`.

**D3 — Funciones `ai::*` intactas.**
El rename es de variables exclusivamente; `ai::internal::packages::install` pasa a iterar `ZSH_AI_TOOLS`, pero los nombres de función no cambian (evita romper callsites y documentación).

**D4 — Spec: MODIFIED + REMOVED en `ai-config-per-tool`.**
Los 5 requirements que nombran el prefijo se actualizan a `ZSH_AI_`; el requirement "Variable names stable across refactor" (R5) se marca REMOVED con migration — fue una restricción temporal del refactor config, superada por este change.

## Risks / Trade-offs

- **[Rename rompe referencias internas]** → Mitigación: grep post-cambio por var residual (`\bAI_[A-Z]`) + carga del módulo con entorno mínimo (método validado) + `type` de funciones clave.
- **[Diferencias de `\b` entre sed GNU y BSD]** → Mitigación: detectar plataforma; en macOS usar `[[:<:]]AI_`; si sed falla, fallback a replaceAll por archivo.
- **[Espec R5 contradice el rename]** → Mitigación: REMOVED documentado con reason + migration; sin ambigüedad en la spec final.
- **[Convención mixta del repo persiste]** → Trade-off aceptado (non-goal); el módulo AI queda como referencia del estándar `ZSH_`.

## Migration Plan

1. Implementar: aplicar el sed de prefijo en los 35 archivos de `zsh/modules/ai/`.
2. Verificar: 0 residuales `\bAI_[A-Z]`, `zsh -n` por archivo, carga del módulo con entorno mínimo, `type` de funciones `ai::*`.
3. Sincronizar la spec `ai-config-per-tool` (MODIFIED + REMOVED) a `openspec/specs/ai-config-per-tool/spec.md`.
4. Archivar el change.
5. Rollback: `git revert` del commit (sin migración de datos; los valores son idénticos, solo el prefijo).

## Open Questions

- Ninguna pendiente: el alcance (todas las vars `AI_*`) y la mecánica (`sed \bAI_` con fallback) quedaron resueltos en D1-D2.
