## 1. Migrar ruta raíz en SKILL.md

- [x] 1.1 Definir variable `RESEARCH_ROOT=".codi/inbox/research"` al inicio del SKILL.md (sección de configuración/constantes)
- [x] 1.2 Reemplazar las 12 referencias hardcodeadas a `00-Inbox/research/` por `$RESEARCH_ROOT` (líneas 55, 140, 221, 241, 252, 261, 270, 325, 328, 334, 368, 388)
- [x] 1.3 Actualizar el comando gomplate (línea 241) para usar `$RESEARCH_ROOT/${ESTADO}/${FECHA}-${SLUG}.md`
- [x] 1.4 Actualizar el comando de promoción (línea 368) para usar `$RESEARCH_ROOT/validated/{FECHA}-{SLUG}.md`
- [x] 1.5 Actualizar los patrones de glob del modo BROWSE (línea 270) a `$RESEARCH_ROOT/{draft,researched,validated}/*.md` y subestructuras
- [x] 1.6 Agregar instrucción de crear la carpeta con `mkdir -p $RESEARCH_ROOT/<estado>/` antes de escribir o mover drafts (modo investigación y promoción)

## 2. Enriquecer template research-draft.md.tpl

- [x] 2.1 Renombrar variable `titulo` → `title` en el template
- [x] 2.2 Agregar campos opcionales `validated_at`, `validated_by`, `promoted_at`, `promoted_by`, `related_docs` al frontmatter del template, renderizados con condicionales gomplate (`{{ if ... }}`) solo si la variable está definida
- [x] 2.3 Verificar que el template sigue siendo YAML válido tras los cambios

## 3. Agregar regla de sanitización de slug

- [x] 3.1 Documentar en SKILL.md la regla de normalización de slug: minúsculas, espacios y no-alfanuméricos → guiones, colapso de guiones duplicados, trim de guiones
- [x] 3.2 Aplicar la sanitización al generar `<fecha>-<slug>.md` en el modo investigación

## 4. Verificar y actualizar downstream

- [x] 4.1 Buscar referencias a `00-Inbox/research` en skills downstream (`research-draft`, `idea-jpd-create`, `jpd-epic-generator`, `markdown-to-jira`) y actualizarlas a `.codi/inbox/research/`
- [x] 4.2 Documentar migración manual opcional de drafts existentes (`mv 00-Inbox/research/* .codi/inbox/research/`)

## 5. Validación

- [x] 5.1 Ejecutar `openspec validate --change relocate-research-capture-inbox` y confirmar que pasa
- [x] 5.2 Verificar que no quedan referencias a `00-Inbox/research` en el skill (grep)
- [x] 5.3 Confirmar que el template renderiza correctamente con gomplate (prueba con un draft de ejemplo)
