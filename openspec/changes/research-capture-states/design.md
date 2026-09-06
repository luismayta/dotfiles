## Context

El skill `research-capture` (`.opencode/skills/research-capture/`) hoy mezcla dos modelos: un flujo de estados sobre `$RESEARCH_ROOT` (`.codi/inbox/research`) y una clasificación PARA (`01-Projects`, `02-Areas`, `03-Resources`) con preguntas de tenant/subpath/destination en captura y promoción. El SKILL.md actual (462 líneas) contiene referencias operativas a PARA en: descripción/frontmatter del skill, paso 5 del modo INVESTIGAR, sub-flujo de promoción, escaneo de browse (`$RESEARCH_ROOT/draft/01-Projects/**`), y el template `research-draft.md.tpl` (campo `destination`). Ver proposal.md — Why para la motivación.

## Goals / Non-Goals

**Goals:**
- Un único modelo de ubicación: el directorio físico bajo `$RESEARCH_ROOT` es la representación del estado.
- Máquina de estados explícita: `draft → researched → validated → archived`, con regresiones `validated → researched` y `researched → draft`, y archivado desde cualquier estado activo.
- Eliminar toda referencia operativa a PARA, tenant, subpath y `destination` del skill y su template.
- Mantener intactas las capacidades de investigación (web search, GitHub Search, Codegraph, codebase, Graphify, Context7), gomplate, preview, validación y el pipeline downstream.

**Non-Goals:**
- No rediseñar los skills downstream (`research-draft`, `idea-jpd-*`, `jpd-epic-generator`, `markdown-to-jira`).
- No cambiar el motor de renderizado (gomplate) ni el formato del cuerpo del template.
- No migrar automáticamente investigaciones existentes ya ubicadas en destinos PARA fuera de `$RESEARCH_ROOT` (fuera del alcance del skill; se documenta como migración manual).

## Decisions

### D1. El estado es la única fuente de ubicación
El directorio destino se deriva exclusivamente de `status`: `$RESEARCH_ROOT/{draft,researched,validated,archived}/`. Se elimina el paso "Definir destino final" del modo INVESTIGAR y el sub-flujo de promoción a destino PARA. Alternativa considerada: mantener `destination` como metadata opcional — descartada porque duplica la fuente de verdad y es exactamente lo que el usuario pide eliminar.

### D2. Máquina de estados con tabla de transiciones
Se implementa una tabla explícita de transiciones válidas:

| Desde | Hacia | Operación |
|---|---|---|
| draft | researched | promover |
| researched | validated | promover |
| validated | researched | regresión |
| researched | draft | regresión |
| draft/researched/validated | archived | archivar |

Cada transición ejecuta: `mkdir -p` del destino → `mv` del archivo → actualización del frontmatter (`status` + campos condicionales). Alternativa considerada: transiciones libres — descartada por riesgo de estados inconsistentes.

### D3. Frontmatter como metadata de transición
El template `research-draft.md.tpl` elimina `destination`. Los campos condicionales se mantienen: `validated_at`/`validated_by` al promover a `validated`; `promoted_at`/`promoted_by` ya no aplican (no hay promoción a destino externo) y se eliminan del flujo; `notes` se conserva para regresiones. El `status` del frontmatter es la fuente de verdad para validar consistencia con el directorio físico.

### D4. BROWSE por estado con exclusión de archived
El escaneo usa globs por directorio de estado: `$RESEARCH_ROOT/{draft,researched,validated}/*.md`. Se eliminan los globs PARA (`$RESEARCH_ROOT/draft/01-Projects/**`). `archived/` solo se consulta mediante operación explícita. El agrupado del listado pasa de `destination` a estado (DRAFT/RESEARCHED/VALIDATED).

### D5. Validaciones post-transición
Tras cada escritura o transición se verifica: (a) `status` ∈ {draft, researched, validated, archived}; (b) el directorio físico coincide con `status`; (c) el archivo existe y no fue sobrescrito (chequeo de colisión de nombre antes del `mv`). Ninguna operación escribe fuera de `$RESEARCH_ROOT`.

## Risks / Trade-offs

- [Investigaciones existentes bajo `$RESEARCH_ROOT/draft/01-Projects/**` o `03-Resources/**`] → El browse ya no las encuentra; se documenta una migración manual puntual (mover a `$RESEARCH_ROOT/draft/` o al estado correspondiente) en el SKILL.md.
- [Skills downstream que lean `destination` del frontmatter] → Verificación de compatibilidad: los consumidores listados (`idea-jpd-*`, `jpd-epic-generator`, `markdown-to-jira`) consumen desde `validated/`; si alguno depende de `destination`, se ajusta solo lo estrictamente necesario para el nuevo contrato.
- [Colisión de nombres en transición] → Chequeo previo al `mv`; si el destino ya tiene el archivo, se pide confirmación (no sobrescribir).
- [Regresión pierde metadata] → Al regresar se actualiza `status` pero se preserva el resto del frontmatter y el cuerpo completo.

## Migration Plan

1. Editar `SKILL.md`: reemplazar flujo INVESTIGAR (paso 5), sub-flujo de promoción, browse y reglas.
2. Editar `research-draft.md.tpl`: eliminar `destination`.
3. Editar `readme.yaml` si referencia PARA.
4. Verificar con grep que no queden referencias operativas a `01-Projects`, `02-Areas`, `03-Resources`, `tenant`, `subpath`, `destination`.
5. Ejecutar validaciones del skill (si existen scripts/tests) y pruebas manuales de los flujos INVESTIGAR, BROWSE, promoción, regresión y archivado.
6. Rollback: `git revert` del commit del cambio; el modelo anterior queda restaurado.

## Open Questions

Ninguna — el alcance está completamente definido por el usuario (secciones 1-21 de la solicitud).