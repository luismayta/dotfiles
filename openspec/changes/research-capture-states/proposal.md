## Why

El skill `research-capture` mezcla dos modelos de almacenamiento: un flujo de estados basado en `RESEARCH_ROOT` (draft/researched/validated/archived) y una clasificación PARA (`01-Projects`, `02-Areas`, `03-Resources`) que obliga al usuario a responder categoría, tenant y subpath durante la promoción. Esto duplica la lógica de ubicación, hace el flujo lento y rompe el principio de que el estado del research determina dónde vive el documento.

## What Changes

- **BREAKING**: Eliminar la clasificación PARA (`01-Projects`, `02-Areas`, `03-Resources`) del flujo de `research-capture`.
- **BREAKING**: Eliminar las preguntas de `tenant`, `subpath` y `destination` durante captura y promoción.
- El directorio físico del documento pasa a ser la única representación de su estado: `$RESEARCH_ROOT/{draft,researched,validated,archived}/`.
- La promoción deja de ser "mover a destino final" y pasa a ser una transición de estado (`draft → researched → validated`), con regresiones permitidas (`validated → researched`, `researched → draft`) y archivado desde cualquier estado activo.
- El frontmatter elimina el campo `destination`; `status` es la única información de ubicación.
- El modo BROWSE agrupa por estado (`draft`, `researched`, `validated`) y excluye `archived/` del listado normal.
- Se mantienen intactas las capacidades de investigación (web search, GitHub Search, Codegraph, Graphify, Context7, análisis de codebase, gomplate, preview, validación) y el pipeline downstream.

## Capabilities

### New Capabilities
- `research-capture`: Comportamiento del skill de captura de investigación: estados de almacenamiento basados en `RESEARCH_ROOT`, transiciones de estado (promoción, regresión, archivado), modo BROWSE agrupado por estado, escritura con gomplate y contrato downstream basado en `validated/`.

### Modified Capabilities
<!-- Ninguna: no existe spec previo de research-capture en openspec/specs/. -->

## Impact

- `.opencode/skills/research-capture/SKILL.md` — flujo INVESTIGAR, BROWSE, promoción, regresión, archivado y validaciones.
- `.opencode/skills/research-capture/research-draft.md.tpl` — eliminación del campo `destination` del frontmatter.
- `.opencode/skills/research-capture/readme.yaml` — descripción y metadatos si referencian PARA.
- Skills downstream (`research-draft`, `idea-jpd-create`, `idea-jpd-import`, `jpd-epic-generator`, `markdown-to-jira`): sin cambios de código; el contrato pasa a ser que `validated/` contiene investigaciones listas para consumo.
- No se crean directorios PARA; ninguna operación normal escribe fuera de `$RESEARCH_ROOT`.