## Purpose

Define el comportamiento del skill de captura de investigación: almacenamiento por estados basado en `RESEARCH_ROOT`, transiciones de estado (promoción, regresión, archivado), modo BROWSE agrupado por estado y el contrato downstream para consumo de investigaciones validadas.

## ADDED Requirements

### Requirement: Almacenamiento por estados en RESEARCH_ROOT

El skill SHALL almacenar toda investigación dentro de `$RESEARCH_ROOT` (`.codi/inbox/research`), donde el directorio físico representa el estado del documento. Los únicos estados válidos SHALL ser `draft`, `researched`, `validated` y `archived`, y cada uno corresponde a un subdirectorio de `$RESEARCH_ROOT`.

El skill SHALL garantizar que los directorios `draft/`, `researched/`, `validated/` y `archived/` existan bajo `$RESEARCH_ROOT` antes de escribir o mover archivos.

El skill MUST NOT escribir archivos fuera de `$RESEARCH_ROOT` durante ninguna operación normal del flujo.

#### Scenario: Directorios de estado asegurados antes de escribir
- **WHEN** el skill va a guardar una investigación en estado `researched`
- **THEN** el directorio `$RESEARCH_ROOT/researched/` existe (creado si no existía) y el archivo se escribe dentro de él

#### Scenario: Escritura fuera de RESEARCH_ROOT rechazada
- **WHEN** una operación del flujo intentaría escribir fuera de `$RESEARCH_ROOT`
- **THEN** el skill no ejecuta la escritura y reporta el error

### Requirement: Captura de investigación con estado seleccionado

Cuando el skill recibe input (tema, URL, texto o idea conceptual), SHALL ejecutar el flujo INVESTIGAR: detectar contenido existente con Graphify, investigar en paralelo (web search, GitHub Search, Codegraph, análisis de codebase, Graphify, Context7), mostrar hallazgos, preguntar el estado de guardado, mostrar preview, confirmar escritura, renderizar con gomplate y verificar el resultado.

El skill SHALL preguntar al usuario el estado de guardado ofreciendo `draft`, `researched` y `validated`, con `researched` como opción por defecto. El skill MUST NOT preguntar por categoría PARA, tenant, subpath ni destino final.

El archivo resultante SHALL seguir el patrón `<FECHA>-<SLUG>.md` y escribirse en `$RESEARCH_ROOT/<estado>/`.

#### Scenario: Investigación guardada en el estado elegido
- **WHEN** el usuario investiga un tema y elige estado `draft`
- **THEN** el archivo se escribe en `$RESEARCH_ROOT/draft/<FECHA>-<SLUG>.md` con `status: draft` en el frontmatter

#### Scenario: Estado por defecto researched
- **WHEN** el usuario investiga un tema y acepta el estado por defecto
- **THEN** el archivo se escribe en `$RESEARCH_ROOT/researched/<FECHA>-<SLUG>.md` con `status: researched` en el frontmatter

#### Scenario: Sin preguntas de destino
- **WHEN** el skill captura una investigación
- **THEN** no se pregunta por categoría PARA, tenant, subpath ni destino final

### Requirement: Normalización del nombre de archivo

El skill SHALL generar el slug del nombre de archivo convirtiendo el título a minúsculas, reemplazando espacios y caracteres no alfanuméricos por guiones, colapsando guiones duplicados y eliminando guiones iniciales y finales.

#### Scenario: Slug normalizado
- **WHEN** el título es "Vibe Coding Guide"
- **THEN** el slug resultante es `vibe-coding-guide` y el archivo se llama `<FECHA>-vibe-coding-guide.md`

### Requirement: Frontmatter sin campo destination

El frontmatter del documento SHALL contener `type`, `status`, `source`, `captured_at` y `tags`, y MUST NOT contener el campo `destination`. El estado SHALL ser la única información necesaria para determinar la ubicación del archivo.

Los campos condicionales `validated_at`, `validated_by`, `promoted_at`, `promoted_by` y `related_docs` SHALL mantenerse cuando corresponda a la transición realizada.

#### Scenario: Frontmatter de investigación nueva
- **WHEN** se guarda una investigación nueva en estado `researched`
- **THEN** el frontmatter contiene `type: research`, `status: researched`, `source`, `captured_at` y `tags`, y no contiene `destination`

### Requirement: Modo BROWSE agrupado por estado

Cuando el skill se invoca sin input, SHALL listar las investigaciones de `$RESEARCH_ROOT/draft/`, `$RESEARCH_ROOT/researched/` y `$RESEARCH_ROOT/validated/`, agrupadas por estado. El directorio `$RESEARCH_ROOT/archived/` MUST NOT aparecer en el browse normal.

#### Scenario: Listado agrupado por estado
- **WHEN** el usuario invoca el skill sin input y existen investigaciones en varios estados
- **THEN** el skill muestra los resultados agrupados bajo los encabezados DRAFT, RESEARCHED y VALIDATED

#### Scenario: Archivados excluidos del browse
- **WHEN** el usuario invoca el skill sin input
- **THEN** ninguna investigación en `$RESEARCH_ROOT/archived/` aparece en el listado

### Requirement: Acciones según estado

Después de seleccionar una investigación en modo BROWSE, el skill SHALL mostrar el contenido completo y ofrecer acciones válidas según el estado:

- `draft`: investigar nuevamente, promover a `researched`, archivar, salir
- `researched`: editar, promover a `validated`, volver a `draft`, archivar, salir
- `validated`: editar, volver a `researched`, archivar, salir

#### Scenario: Acciones para investigación en draft
- **WHEN** el usuario selecciona una investigación en estado `draft`
- **THEN** el skill ofrece investigar nuevamente, promover a `researched`, archivar y salir

#### Scenario: Acciones para investigación en validated
- **WHEN** el usuario selecciona una investigación en estado `validated`
- **THEN** el skill ofrece editar, volver a `researched`, archivar y salir, y no ofrece promover

### Requirement: Promoción como transición de estado

La promoción SHALL ser únicamente una transición de estado que mueve el archivo al directorio del nuevo estado y actualiza el frontmatter. Las transiciones permitidas SHALL ser `draft → researched` y `researched → validated`.

Al promover a `validated`, el skill SHALL actualizar `status: validated`, `validated_at` y `validated_by`. El skill MUST NOT preguntar por categoría PARA, tenant, subpath ni destino final durante la promoción.

#### Scenario: Promoción de researched a validated
- **WHEN** el usuario promueve una investigación de `researched` a `validated`
- **THEN** el archivo se mueve de `$RESEARCH_ROOT/researched/` a `$RESEARCH_ROOT/validated/` y el frontmatter se actualiza con `status: validated`, `validated_at` y `validated_by`

#### Scenario: Promoción sin preguntas de destino
- **WHEN** el usuario promueve una investigación
- **THEN** el skill no solicita categoría PARA, tenant, subpath ni destino final

### Requirement: Regresión de estado

El skill SHALL permitir regresiones `validated → researched` y `researched → draft`. Al regresar, SHALL mover físicamente el archivo al directorio del estado anterior y actualizar `status` en el frontmatter.

#### Scenario: Regresión de validated a researched
- **WHEN** el usuario regresa una investigación de `validated` a `researched`
- **THEN** el archivo se mueve de `$RESEARCH_ROOT/validated/` a `$RESEARCH_ROOT/researched/` y el frontmatter se actualiza con `status: researched`

#### Scenario: Regresión de researched a draft
- **WHEN** el usuario regresa una investigación de `researched` a `draft`
- **THEN** el archivo se mueve de `$RESEARCH_ROOT/researched/` a `$RESEARCH_ROOT/draft/` y el frontmatter se actualiza con `status: draft`

### Requirement: Archivado desde cualquier estado activo

El skill SHALL permitir archivar una investigación desde cualquier estado activo (`draft`, `researched`, `validated`). Al archivar, SHALL mover el archivo a `$RESEARCH_ROOT/archived/` y actualizar `status: archived` en el frontmatter.

#### Scenario: Archivado desde validated
- **WHEN** el usuario archiva una investigación en estado `validated`
- **THEN** el archivo se mueve a `$RESEARCH_ROOT/archived/` y el frontmatter se actualiza con `status: archived`

#### Scenario: Archivado desde draft
- **WHEN** el usuario archiva una investigación en estado `draft`
- **THEN** el archivo se mueve a `$RESEARCH_ROOT/archived/` y el frontmatter se actualiza con `status: archived`

### Requirement: Integridad de transiciones

Toda transición de estado SHALL preservar el contenido del archivo, actualizar el frontmatter de forma consistente con el nuevo estado y no sobrescribir accidentalmente una investigación existente en el directorio destino.

El directorio físico del archivo SHALL coincidir siempre con el valor de `status` en el frontmatter.

#### Scenario: Directorio físico coincide con status
- **WHEN** se inspecciona una investigación tras cualquier transición
- **THEN** el directorio donde vive el archivo corresponde al valor de `status` en su frontmatter

#### Scenario: Sin sobrescritura accidental
- **WHEN** una transición movería un archivo a un directorio donde ya existe un archivo con el mismo nombre
- **THEN** el skill no sobrescribe y solicita confirmación o resolución del conflicto

### Requirement: Contrato downstream basado en validated

El directorio `$RESEARCH_ROOT/validated/` SHALL contener las investigaciones listas para consumo por los skills downstream (`research-draft`, `idea-jpd-create`, `idea-jpd-import`, `jpd-epic-generator`, `markdown-to-jira`). El skill SHALL mantener la compatibilidad de formato de los documentos validados con esos consumidores.

#### Scenario: Investigación validada consumible downstream
- **WHEN** una investigación alcanza el estado `validated`
- **THEN** el documento conserva la estructura (frontmatter, hallazgos, fuentes) que los skills downstream esperan para su consumo