## Context

El skill `research-capture` (`.opencode/skills/research-capture/SKILL.md`, 431 líneas) guarda drafts de investigación en `00-Inbox/research/<estado>/<fecha>-<slug>.md`. La ruta está hardcodeada en 12 lugares del SKILL.md. El template `research-draft.md.tpl` usa la variable `titulo` (español) y no genera los campos de promoción que el skill menciona en su "Formato del draft promovido". Ver proposal.md para la motivación.

## Goals / Non-Goals

**Goals:**
- Migrar la raíz de almacenamiento a `.codi/inbox/research/`.
- Centralizar la ruta en una variable `RESEARCH_ROOT` para facilitar cambios futuros.
- Enriquecer el template con campos de promoción y unificar el idioma de variables.
- Agregar sanitización de slug.
- Actualizar el modo BROWSE a la nueva ruta.

**Non-Goals:**
- No cambiar el flujo de investigación ni el pipeline downstream (`research-draft` → `idea-jpd-create` → `jpd-epic-generator`).
- No migrar drafts existentes de `00-Inbox/research/` (fuera de alcance; se documenta como paso manual opcional).
- No tocar otros skills.

## Decisions

### D1: Nueva raíz `.codi/inbox/research/`
Se adopta `.codi/inbox/research/` como raíz de almacenamiento, alineada con la convención interna de CodipLabs (`.codi/`). La estructura de estados (`draft/`, `researched/`, `validated/`) y el patrón de nombre `<fecha>-<slug>.md` se mantienen.
- **Alternativa**: mantener `00-Inbox/research/` — rechazada por no seguir la convención `.codi/`.

### D2: Variable `RESEARCH_ROOT` centralizada
Se define `RESEARCH_ROOT=".codi/inbox/research"` al inicio del SKILL.md y se referencia en los 12 lugares donde hoy aparece la ruta hardcodeada. Esto reduce el riesgo de inconsistencias y facilita futuros cambios de ruta.
- **Alternativa**: reemplazo directo de la cadena — rechazada por dejar la ruta dispersa y frágil.

### D3: Template enriquecido con campos de promoción
Se agregan al template los campos opcionales `validated_at`, `validated_by`, `promoted_at`, `promoted_by`, `related_docs`. Se renombra `titulo` → `title`. Los campos opcionales se renderizan solo si la variable está definida (gomplate `if`), para no romper drafts en estados tempranos.
- **Alternativa**: mantener el template mínimo — rechazada porque el skill ya documenta estos campos en el "Formato del draft promovido" pero no los genera.

### D4: Sanitización de slug
Se agrega una regla de normalización: minúsculas, espacios y no-alfanuméricos → guiones, colapso de guiones duplicados, trim de guiones. Se aplica al generar `<fecha>-<slug>.md`.
- **Alternativa**: confiar en el slug manual del usuario — rechazada por riesgo de nombres inválidos en filesystem.

### D5: Creación automática de carpetas con mkdir -p
Antes de escribir o mover cualquier draft, el skill SHALL garantizar que la carpeta destino exista ejecutando `mkdir -p $RESEARCH_ROOT/<estado>/`. Esto elimina la dependencia de que el usuario cree manualmente la estructura y evita errores de "directorio no existe" al guardar o promover drafts.
- **Alternativa**: exigir al usuario crear la carpeta manualmente — rechazada por fricción innecesaria y riesgo de fallos.

## Risks / Trade-offs

- [Downstream skills apuntan a la ruta vieja] → Mitigación: verificar y actualizar `research-draft`, `idea-jpd-create`, `jpd-epic-generator`, `markdown-to-jira` en una tarea de seguimiento; documentar la nueva ruta.
- [Drafts existentes en `00-Inbox/research/` quedan huérfanos] → Mitigación: documentar migración manual opcional (`mv 00-Inbox/research/* .codi/inbox/research/`); no automatizar para evitar pérdida de datos.
- [Template con campos opcionales rompe si la variable no existe] → Mitigación: usar condicionales gomplate (`{{ if ... }}`) para renderizar solo campos definidos.
