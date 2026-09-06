## Purpose

Define el comportamiento del skill `research-capture` de CodipLabs: el ciclo completo de investigación (captura, browse, promoción) y el almacenamiento de drafts bajo `.codi/inbox/research/`.

## ADDED Requirements

### Requirement: Almacenamiento de drafts bajo .codi/inbox/research
El skill SHALL guardar todos los drafts de investigación bajo la raíz `.codi/inbox/research/`, organizados por estado (`draft/`, `researched/`, `validated/`), con el patrón de nombre `<fecha>-<slug>.md`.

#### Scenario: Guardar draft en modo investigación
- **WHEN** el usuario investiga un tema y confirma la escritura
- **THEN** el draft se guarda en `.codi/inbox/research/<estado>/<fecha>-<slug>.md`

#### Scenario: Ruta raíz centralizada
- **WHEN** el skill referencia la ruta de almacenamiento
- **THEN** usa una variable `RESEARCH_ROOT` definida al inicio, no rutas hardcodeadas dispersas

### Requirement: Sanitización de slug
El skill SHALL normalizar el slug del nombre de archivo: convertir a minúsculas, reemplazar espacios y caracteres no alfanuméricos por guiones, y eliminar guiones duplicados o iniciales/finales.

#### Scenario: Slug con espacios y mayúsculas
- **WHEN** el título del draft es "Vibe Coding Guide"
- **THEN** el slug generado es `vibe-coding-guide`

#### Scenario: Slug con caracteres especiales
- **WHEN** el título contiene caracteres como `:`, `/`, `?`
- **THEN** se reemplazan por guiones y se eliminan guiones duplicados

### Requirement: Template enriquecido con campos de promoción
El template `research-draft.md.tpl` SHALL soportar los campos opcionales `validated_at`, `validated_by`, `promoted_at`, `promoted_by` y `related_docs`, además de los campos base (`status`, `source`, `captured_at`, `destination`, `tags`, `title`, `findings`, `sources`).

#### Scenario: Draft promovido a validated
- **WHEN** un draft se promueve a `validated`
- **THEN** el frontmatter incluye `validated_at` y `validated_by`

#### Scenario: Draft promovido a destino final
- **WHEN** un draft validated se promueve a su destino PARA final
- **THEN** el frontmatter incluye `promoted_at` y `promoted_by`

### Requirement: Consistencia de idioma en el template
El template SHALL usar nombres de variables en inglés (`title`, no `titulo`) para consistencia con el resto del skill.

#### Scenario: Variable de título en inglés
- **WHEN** se renderiza el template
- **THEN** la variable de título se referencia como `title`

### Requirement: Modo browse escanea la nueva ruta
El modo BROWSE SHALL escanear los drafts bajo `.codi/inbox/research/{draft,researched,validated}/` y sus subestructuras, sin escanear `archived/`.

#### Scenario: Escaneo de drafts en browse
- **WHEN** el usuario invoca el skill sin input
- **THEN** se listan los drafts de `.codi/inbox/research/` en todos los estados activos

#### Scenario: Exclusión de archived
- **WHEN** se escanean drafts
- **THEN** los archivos bajo `archived/` no se incluyen

### Requirement: Creación automática de la carpeta de investigación
El skill SHALL crear la carpeta `.codi/inbox/research/` y sus subcarpetas de estado (`draft/`, `researched/`, `validated/`) con `mkdir -p` si no existen, antes de escribir o mover cualquier draft.

#### Scenario: Carpeta raíz inexistente
- **WHEN** el skill va a guardar un draft y `.codi/inbox/research/` no existe
- **THEN** crea la carpeta con `mkdir -p .codi/inbox/research/<estado>/` antes de escribir el archivo

#### Scenario: Carpeta de estado inexistente
- **WHEN** el skill va a mover un draft a un estado y la subcarpeta de ese estado no existe
- **THEN** crea la subcarpeta con `mkdir -p` antes de mover el archivo
