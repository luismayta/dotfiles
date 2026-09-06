## 1. Inspección y limpieza de referencias al modelo anterior

- [x] 1.1 Inspeccionar el skill completo `.opencode/skills/research-capture/` (SKILL.md, research-draft.md.tpl, readme.yaml, scripts/, templates/, references/) e identificar todas las referencias a `01-Projects`, `02-Areas`, `03-Resources`, `destination`, `tenant`, `subpath` y `PARA`
- [x] 1.2 Documentar en el SKILL.md la migración manual de investigaciones existentes bajo `$RESEARCH_ROOT/draft/01-Projects/**` y `$RESEARCH_ROOT/draft/03-Resources/**` hacia `$RESEARCH_ROOT/draft/` (o el estado correspondiente)

## 2. Template research-draft.md.tpl

- [x] 2.1 Eliminar el campo `destination` del frontmatter del template
- [x] 2.2 Verificar que el frontmatter conserva `type`, `status`, `source`, `captured_at`, `tags` y los campos condicionales `validated_at`, `validated_by`, `related_docs` (sin reintroducir campos PARA)
- [x] 2.3 Verificar que el cuerpo del template conserva `# {{ (ds "config").title }}`, `## Hallazgos` y `## Fuentes`

## 3. SKILL.md — Modo INVESTIGAR

- [x] 3.1 Actualizar el frontmatter del skill (description, what_i_do, tags) eliminando referencias a PARA y `destination`
- [x] 3.2 Reemplazar el paso "Definir destino final" por el paso "Definir estado" que pregunta solo `draft` / `researched` / `validated` (default `researched`), sin preguntar categoría, tenant, subpath ni destino
- [x] 3.3 Actualizar las variables YAML temporales para gomplate eliminando `destination`
- [x] 3.4 Actualizar el preview del draft para mostrar `$RESEARCH_ROOT/<estado>/` en lugar de destino final
- [x] 3.5 Actualizar el renderizado con gomplate: `mkdir -p "$RESEARCH_ROOT/${ESTADO}"` y escritura en `$RESEARCH_ROOT/${ESTADO}/${FECHA}-${SLUG}.md`
- [x] 3.6 Actualizar el resumen post-guardado para reflejar el directorio por estado

## 4. SKILL.md — Modo BROWSE

- [x] 4.1 Actualizar el escaneo para usar solo `$RESEARCH_ROOT/{draft,researched,validated}/*.md`, eliminando los globs PARA (`$RESEARCH_ROOT/draft/01-Projects/**`, `$RESEARCH_ROOT/draft/03-Resources/**`)
- [x] 4.2 Extraer del frontmatter `type`, `source`, `tags`, `captured_at`, `related_docs` (eliminar `destination`)
- [x] 4.3 Agrupar el listado por estado (DRAFT / RESEARCHED / VALIDATED) en lugar de por `destination`
- [x] 4.4 Actualizar las acciones ofrecidas según estado: draft (investigar nuevamente / promover a researched / archivar / salir), researched (editar / promover a validated / volver a draft / archivar / salir), validated (editar / volver a researched / archivar / salir)

## 5. SKILL.md — Promoción, regresión y archivado

- [x] 5.1 Reemplazar el sub-flujo de promoción a destino final por transición de estado: mover archivo a `$RESEARCH_ROOT/<nuevo-estado>/` y actualizar frontmatter (`status`, `validated_at`, `validated_by` al promover a validated)
- [x] 5.2 Implementar regresiones `validated → researched` y `researched → draft` (mv + actualización de `status`)
- [x] 5.3 Implementar archivado desde cualquier estado activo hacia `$RESEARCH_ROOT/archived/` con `status: archived`
- [x] 5.4 Actualizar la sección "Formato del draft promovido" eliminando `destination` y `promoted_at`/`promoted_by`
- [x] 5.5 Agregar chequeo de colisión de nombre antes de cada `mv` (no sobrescribir sin confirmación)

## 6. Validaciones y reglas

- [x] 6.1 Actualizar la sección "Reglas" del SKILL.md: eliminar la regla de preguntar destino, agregar reglas de estado (status ∈ {draft, researched, validated, archived}, directorio físico coincide con status, nunca escribir fuera de `$RESEARCH_ROOT`)
- [x] 6.2 Agregar validación post-transición: verificar existencia del archivo, consistencia directorio-status y ausencia de sobrescritura

## 7. readme.yaml y metadatos

- [x] 7.1 Actualizar `readme.yaml` eliminando referencias a PARA y `destination` si existen
- [x] 7.2 Verificar que no queden referencias operativas a `01-Projects`, `02-Areas`, `03-Resources`, `tenant`, `subpath`, `destination` en todo el skill

## 8. Verificación final

- [x] 8.1 Ejecutar grep de referencias residuales a `01-Projects`, `02-Areas`, `03-Resources`, `tenant`, `subpath`, `destination`, `PARA` en `.opencode/skills/research-capture/`
- [x] 8.2 Ejecutar las validaciones/tests disponibles del skill y reportar problemas
- [x] 8.3 Probar manualmente los flujos: INVESTIGAR (guardado por estado, default researched), BROWSE (agrupado por estado, sin archived), promoción `researched → validated`, regresión `validated → researched` y `researched → draft`, archivado desde cada estado activo
- [x] 8.4 Verificar que los documentos `validated` conservan la estructura consumible por los skills downstream (`research-draft`, `idea-jpd-create`, `idea-jpd-import`, `jpd-epic-generator`, `markdown-to-jira`)
