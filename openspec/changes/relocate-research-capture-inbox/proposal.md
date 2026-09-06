## Why

El skill `research-capture` guarda sus drafts de investigación en `00-Inbox/research/<estado>/<fecha>-<slug>.md`, una ruta que no sigue la convención de almacenamiento interno de CodipLabs (`.codi/`). Además, la ruta está hardcodeada en 12 lugares del SKILL.md, lo que hace frágil cualquier cambio futuro y dificulta el mantenimiento.

## What Changes

- **BREAKING**: Mover la raíz de almacenamiento de drafts de `00-Inbox/research/` a `.codi/inbox/research/`.
- Centralizar la ruta raíz en una variable `RESEARCH_ROOT` definida al inicio del skill, referenciada en lugar de hardcodearla en 12 lugares.
- Enriquecer el template `research-draft.md.tpl` con campos opcionales (`validated_at`, `validated_by`, `promoted_at`, `promoted_by`, `related_docs`) que el skill ya menciona en el "Formato del draft promovido" pero no genera.
- Unificar el idioma del template: renombrar la variable `titulo` → `title` para consistencia con el resto del skill (inglés).
- Agregar regla de sanitización de slug (normalización de espacios, mayúsculas y caracteres especiales) al generar `<fecha>-<slug>.md`.
- Actualizar los patrones de glob del modo BROWSE para apuntar a la nueva ruta.

## Capabilities

### New Capabilities
- `research-capture`: Comportamiento del skill de investigación de CodipLabs — ciclo de captura, browse, promoción y almacenamiento de drafts de investigación bajo `.codi/inbox/research/`.

### Modified Capabilities
<!-- Ninguna — no existe spec previa para research-capture -->

## Impact

- **Archivo principal**: `.opencode/skills/research-capture/SKILL.md` (12 referencias de ruta + reglas de slug + modo browse).
- **Template**: `.opencode/skills/research-capture/research-draft.md.tpl` (campos enriquecidos + renombrado `titulo` → `title`).
- **Downstream**: skills que consumen drafts (`research-draft`, `idea-jpd-create`, `jpd-epic-generator`, `markdown-to-jira`) — deben apuntar a la nueva ruta `.codi/inbox/research/`.
- **Sin impacto en código de runtime**: el skill es tooling de opencode, no afecta el comportamiento de capabilities del sistema de dotfiles.
