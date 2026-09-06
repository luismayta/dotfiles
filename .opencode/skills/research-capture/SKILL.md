---
name: research-capture
description: Investigate a topic using web search, codegraph, and codebase analysis — shows findings, saves by state under RESEARCH_ROOT (draft/researched/validated/archived) with metadata for downstream consumption. When invoked without input, lists existing drafts for review and state promotion.
category: research
triggers:
  - investigar
  - research
  - buscar
  - investiga esto
  - buscar sobre
  - investigados
  - researched
  - listar investigados
  - mostrar investigados
  - drafts investigados
  - pick draft
  - elegir draft
  - promover draft
  - validar draft
mcp_dependencies: []
optional_mcp:
  - graphify
  - context7
  - codegraph
tags:
  - research
  - drafts
  - inbox
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.2.0"
  opencode:
    emoji: 🔍
what_i_do:
  - "Research topics using web search, GitHub, codegraph, and Context7 in parallel"
  - "Create structured drafts with findings and sources, stored by state under RESEARCH_ROOT"
  - "Browse and manage existing drafts across all status states"
  - "Promote drafts through states (draft → researched → validated) and archive"
  - "Detect existing content to avoid duplicate research"
usage_examples:
  - "Investigar sobre vibe coding y crear un draft"
  - "Buscar información sobre React Server Components"
  - "Mostrar todos los drafts investigados"
  - "Promover el draft de AI adoption a validated"
---

# research-capture

Skill responsable del ciclo de vida de una investigación:

```text
investigar
   ↓
capturar
   ↓
revisar
   ↓
validar
   ↓
consumir
   ↓
archivar
```

El skill separa dos conceptos:

```text
RESEARCH_ROOT → dónde pertenece la investigación
status        → en qué estado se encuentra
```

El usuario no selecciona manualmente el `RESEARCH_ROOT`.

---

# 1. Research Root

Al iniciar el skill, resolver el contexto actual:

```bash
ISSUE_KEY=$(codi commit issue-key)

if [ -n "$ISSUE_KEY" ]; then
  RESEARCH_ROOT=".codi/jira/$ISSUE_KEY/research"
else
  RESEARCH_ROOT=".codi/inbox/research"
fi
```

Si `codi commit issue-key` devuelve un valor:

```text
codi commit issue-key
→ RD-155
```

usar:

```text
.codi/jira/RD-155/research
```

Si no devuelve ningún valor:

```text
.codi/inbox/research
```

Una salida vacía es válida.

Si el comando falla realmente, detener la operación e informar el error.

A partir de este punto, **todas las operaciones deben utilizar exclusivamente `$RESEARCH_ROOT`**.

No solicitar al usuario el directorio de destino.

---

# 2. Estructura

Todos los `RESEARCH_ROOT` tienen la misma estructura:

```text
$RESEARCH_ROOT/
├── draft/
├── researched/
├── validated/
└── archived/
```

Ejemplo con Jira:

```text
.codi/jira/RD-155/research/
├── draft/
├── researched/
├── validated/
└── archived/
```

Ejemplo sin Jira:

```text
.codi/inbox/research/
├── draft/
├── researched/
├── validated/
└── archived/
```

El contexto no modifica el lifecycle.

---

# 3. Estados

Estados válidos:

```text
draft
researched
validated
archived
```

## Estado por defecto

Toda investigación nueva se guarda como:

```text
researched
```

salvo que el usuario indique explícitamente `draft`.

`validated` debe obtenerse mediante una transición explícita.

`archived` solo se alcanza archivando una investigación existente.

---

# 4. Invariante de estado

El directorio físico y el campo `status` del frontmatter deben coincidir.

Ejemplo válido:

```text
$RESEARCH_ROOT/researched/example.md
```

```yaml
status: researched
```

Ejemplo inválido:

```text
$RESEARCH_ROOT/validated/example.md
```

```yaml
status: researched
```

Esta condición debe verificarse después de cada escritura o transición.

---

# 5. Máquina de estados

Transiciones permitidas:

```text
draft ────────────► researched
                       │
                       ▼
                    validated
                       │
                       ▼
                    archived
```

Regresiones permitidas:

```text
researched ─────► draft
validated ──────► researched
```

Archivado:

```text
draft ──────────► archived
researched ─────► archived
validated ──────► archived
```

No existen otras transiciones.

`archived` es un estado terminal.

---

# 6. Reglas del workflow

1. Nunca escribir fuera de `$RESEARCH_ROOT`.
2. Nunca crear estructura PARA.
3. Nunca solicitar `tenant`.
4. Nunca solicitar `subpath`.
5. Nunca solicitar `destination`.
6. Nunca solicitar al usuario el `RESEARCH_ROOT`.
7. Nunca sobrescribir silenciosamente un archivo existente.
8. Nunca mover silenciosamente una investigación.
9. Preservar el contenido existente durante las transiciones.
10. Mantener `status` sincronizado con el directorio.
11. `archived/` no participa en el browse normal.
12. Verificar el resultado después de cada escritura.
13. Si una operación falla, detener el workflow.
14. No inventar resultados de herramientas que no pudieron ejecutarse.
15. No utilizar `promoted_at` ni `promoted_by`.

---

# 7. Modos

La decisión inicial depende de si existe input:

```text
¿Existe input?

SÍ
 ↓
INVESTIGATE

NO
 ↓
BROWSE
```

Input válido:

* tema
* pregunta
* URL
* texto
* idea conceptual

---

# 8. INVESTIGATE

## Paso 1 — Resolver Research Root

Ejecutar:

```bash
codi commit issue-key
```

Resolver `$RESEARCH_ROOT`.

Esto debe ocurrir antes de crear o modificar archivos.

---

## Paso 2 — Buscar contenido relacionado

Buscar investigaciones relacionadas dentro del conocimiento disponible.

Las investigaciones activas del contexto actual se encuentran en:

```text
$RESEARCH_ROOT/draft/
$RESEARCH_ROOT/researched/
$RESEARCH_ROOT/validated/
```

No incluir:

```text
$RESEARCH_ROOT/archived/
```

Si Graphify está disponible, utilizarlo para encontrar conocimiento relacionado.

Graphify puede consultar el vault completo.

`RESEARCH_ROOT` determina dónde guardar el resultado, no necesariamente el universo de búsqueda.

---

## Paso 3 — Detectar duplicados

Si existe contenido claramente relacionado, no crear automáticamente una investigación nueva.

Mostrar:

```text
📁 Contenido relacionado encontrado:

- <path> (<status>)
- <path> (<status>)
```

Preguntar:

```text
Ya existe contenido relacionado con "<tema>".

¿Qué quieres hacer?

1. Enriquecer contenido existente
2. Crear una nueva investigación
3. Cancelar
```

### Enriquecer

Si el usuario selecciona enriquecer:

1. Seleccionar la investigación.
2. Leer el contenido existente.
3. Ejecutar la nueva investigación.
4. Identificar los nuevos hallazgos.
5. Incorporarlos al documento existente.
6. Preservar el contenido original.
7. Agregar nuevas fuentes.
8. Agregar tags cuando corresponda.
9. Mostrar preview.
10. Pedir confirmación.
11. Escribir.
12. Verificar.

### Nueva investigación

Continuar con el paso 4.

### Cancelar

No modificar ningún archivo.

---

# 9. Paso 4 — Investigar

Utilizar todas las fuentes relevantes disponibles.

## Web

Buscar información actual, relevante y verificable.

Priorizar:

* documentación oficial
* especificaciones
* repositorios oficiales
* artículos técnicos primarios

## GitHub

Buscar:

* repositorios
* implementaciones
* ejemplos
* código
* documentación

Utilizar las herramientas GitHub disponibles en el entorno.

## Codebase

Buscar:

* archivos relacionados
* implementaciones
* dependencias
* configuraciones
* patrones existentes

## Graphify

Si está disponible:

* relaciones
* conceptos relacionados
* arquitectura
* conocimiento existente
* dependencias conceptuales

## Codegraph

Si está disponible:

* símbolos
* referencias
* dependencias
* relaciones entre componentes

## Context7

Si está disponible:

* documentación oficial
* APIs
* configuración
* ejemplos

---

# 10. Disponibilidad de herramientas

Los MCP declarados como opcionales no son obligatorios.

Si una herramienta no está disponible:

```text
NO FALLAR
↓
continuar con las demás fuentes
```

Nunca inventar información atribuida a una herramienta que no pudo ejecutarse.

---

# 11. Paso 5 — Sintetizar

Antes de guardar, preparar:

```text
Título
Hallazgos
Fuentes
Conclusión
Tags
```

Cuando corresponda, incluir:

```text
Relación con el codebase
```

Los hallazgos deben distinguir entre:

* hechos
* evidencia
* inferencias
* recomendaciones

La investigación debe ser suficientemente autónoma para que otro usuario pueda entenderla sin conocer la conversación original.

---

# 12. Paso 6 — Estado inicial

Por defecto:

```yaml
status: researched
```

Si el usuario solicita explícitamente un borrador:

```yaml
status: draft
```

No crear directamente como `validated`.

---

# 13. Paso 7 — Metadata

Preparar:

```text
/tmp/research-capture-vars.yaml
```

Ejemplo:

```yaml
status: researched
source: web
captured_at: "2026-09-06T14:00:00Z"
title: "Vibe Coding"
tags: "ai, development, coding"
findings: |
  ...
sources: |
  ...
```

Utilizar `|` para contenido multilínea.

---

# 14. Paso 8 — Slug

Generar un slug a partir del título.

Reglas:

1. lowercase
2. espacios → `-`
3. caracteres especiales → `-`
4. colapsar guiones consecutivos
5. eliminar guiones iniciales y finales

Ejemplo:

```text
Vibe Coding Guide
```

produce:

```text
vibe-coding-guide
```

Filename:

```text
2026-09-06-vibe-coding-guide.md
```

---

# 15. Paso 9 — Preview

Antes de escribir, mostrar el preview completo.

Ejemplo:

```text
📄 Preview

# Vibe Coding

## Hallazgos

...

## Fuentes

...

────────────────────────────────────────

Estado:
researched

Archivo:
$RESEARCH_ROOT/researched/2026-09-06-vibe-coding.md
```

Preguntar:

```text
¿Confirmas la escritura? (s/n/editar)
```

### `s`

Escribir.

### `n`

Cancelar.

### `editar`

Permitir modificar:

* título
* tags
* hallazgos
* fuentes

Después de editar:

```text
preview → confirmación
```

---

# 16. Paso 10 — Escribir

Crear el directorio:

```bash
mkdir -p "$RESEARCH_ROOT/$STATUS"
```

Antes de escribir:

```text
$RESEARCH_ROOT/$STATUS/$FILENAME
```

comprobar si existe.

Si no existe, renderizar con:

```bash
gomplate \
  --missing-key zero \
  -d config=/tmp/research-capture-vars.yaml \
  -f <skill_root>/research-draft.md.tpl \
  -o "$RESEARCH_ROOT/$STATUS/$FILENAME"
```

Si existe:

```text
NO sobrescribir automáticamente
```

Preguntar:

```text
1. Sobrescribir
2. Elegir otro nombre
3. Cancelar
```

---

# 17. Paso 11 — Verificar

Después de escribir:

1. Confirmar que el archivo existe.
2. Leer el frontmatter.
3. Verificar `status`.
4. Verificar que `status` coincide con el directorio.
5. Verificar título.
6. Verificar hallazgos.
7. Verificar fuentes.

Resultado:

```text
✅ Investigación guardada

Archivo:
$RESEARCH_ROOT/researched/2026-09-06-vibe-coding.md

Estado:
researched
```

---

# 18. BROWSE

Cuando el skill se ejecuta sin input, listar investigaciones activas.

Buscar únicamente:

```text
$RESEARCH_ROOT/draft/
$RESEARCH_ROOT/researched/
$RESEARCH_ROOT/validated/
```

No incluir:

```text
$RESEARCH_ROOT/archived/
```

Mostrar:

```text
DRAFT

1. <title>
   <file>

RESEARCHED

2. <title>
   <file>

VALIDATED

3. <title>
   <file>
```

Para cada documento puede mostrarse:

* título
* estado
* archivo
* tags
* fecha

No mostrar estados vacíos.

---

# 19. Seleccionar investigación

Permitir seleccionar mediante:

```text
número
```

o:

```text
nombre
```

Ejemplo:

```text
¿Qué investigación deseas revisar?

1. vibe-coding-guide
2. mcp-memory
3. rust-ai-platform
```

---

# 20. Acciones por estado

## draft

```text
¿Qué deseas hacer?

1. Agregar contenido
2. Promover a researched
3. Archivar
4. Salir
```

## researched

```text
¿Qué deseas hacer?

1. Agregar contenido
2. Promover a validated
3. Volver a draft
4. Archivar
5. Salir
```

## validated

```text
¿Qué deseas hacer?

1. Agregar contenido
2. Volver a researched
3. Archivar
4. Salir
```

---

# 21. Agregar contenido

Cuando se solicita enriquecer una investigación:

1. Leer el documento.
2. Investigar el nuevo tema.
3. Identificar nuevos hallazgos.
4. Preguntar dónde incorporarlos:

   * inicio
   * final
   * sección específica
5. Integrar el contenido.
6. Preservar el contenido existente.
7. Actualizar fuentes.
8. Actualizar tags si corresponde.
9. Mostrar preview completo.
10. Pedir confirmación.
11. Escribir.
12. Verificar.

No crear un segundo archivo si la intención es enriquecer el existente.

---

# 22. Transiciones

Todas las transiciones siguen el mismo procedimiento:

```text
1. Leer
2. Validar estado actual
3. Validar transición
4. Crear directorio destino
5. Verificar colisión
6. Actualizar frontmatter
7. Mostrar preview
8. Confirmar
9. Mover
10. Verificar
```

Nunca modificar solamente el `status` dejando el archivo en el directorio anterior.

---

# 23. draft → researched

Origen:

```text
$RESEARCH_ROOT/draft/<file>.md
```

Destino:

```text
$RESEARCH_ROOT/researched/<file>.md
```

Actualizar:

```yaml
status: researched
```

Preservar el resto del contenido.

---

# 24. researched → validated

Origen:

```text
$RESEARCH_ROOT/researched/<file>.md
```

Destino:

```text
$RESEARCH_ROOT/validated/<file>.md
```

Actualizar:

```yaml
status: validated
validated_at: "YYYY-MM-DDTHH:mm:ssZ"
validated_by: "Luchex"
```

---

# 25. validated → researched

Origen:

```text
$RESEARCH_ROOT/validated/<file>.md
```

Destino:

```text
$RESEARCH_ROOT/researched/<file>.md
```

Actualizar:

```yaml
status: researched
```

La información histórica de validación puede conservarse.

---

# 26. researched → draft

Origen:

```text
$RESEARCH_ROOT/researched/<file>.md
```

Destino:

```text
$RESEARCH_ROOT/draft/<file>.md
```

Actualizar:

```yaml
status: draft
```

---

# 27. Archivar

Puede archivarse desde:

```text
draft
researched
validated
```

Destino:

```text
$RESEARCH_ROOT/archived/<file>.md
```

Actualizar:

```yaml
status: archived
```

No eliminar el archivo.

Una investigación archivada:

* no aparece en browse normal
* no participa en detección normal de duplicados
* conserva su contenido
* conserva sus fuentes
* conserva su metadata

---

# 28. Verificación de transición

Después de cualquier transición verificar:

```text
archivo existe en destino
archivo no existe en origen
frontmatter.status == directorio destino
contenido preservado
```

Si alguna comprobación falla:

```text
NO informar éxito
```

Informar el error y detener el workflow.

---

# 29. Frontmatter

La investigación utiliza como mínimo:

```yaml
---
type: research
status: researched
source: web
captured_at: "2026-09-06T14:00:00Z"
tags:
  - ai
  - development
---
```

Opcionalmente:

```yaml
validated_at: "2026-09-06T15:00:00Z"
validated_by: "Luchex"
```

y:

```yaml
related_docs:
  - path/to/document.md
```

No utilizar:

```text
promoted_at
promoted_by
destination
tenant
subpath
```

---

# 30. Template

El archivo:

```text
<skill_root>/research-draft.md.tpl
```

debe generar:

```markdown
# {{ (ds "config").title }}

## Hallazgos

{{ (ds "config").findings }}

## Fuentes

{{ (ds "config").sources }}
```

Los tags pertenecen al frontmatter.

No crear una sección `## Tags`.

---

# 31. Contrato downstream

Una investigación está lista para consumo downstream cuando se encuentra en:

```text
$RESEARCH_ROOT/validated/
```

y tiene:

```yaml
status: validated
```

Consumidores actuales:

```text
research-draft
idea-jpd-create
idea-jpd-import
jpd-epic-generator
markdown-to-jira
```

El contrato es:

```text
research-capture
       │
       ▼
$RESEARCH_ROOT
       │
       ├── draft
       ├── researched
       ├── validated
       │       │
       │       └──► downstream
       │
       └── archived
```

---

# 32. Responsabilidad

`research-capture` es responsable de:

* investigar
* detectar contenido relacionado
* capturar
* estructurar
* persistir
* enriquecer
* revisar
* validar
* archivar

`research-capture` no es responsable de:

* clasificar mediante PARA
* elegir Projects / Areas / Resources
* elegir tenant
* crear issues Jira
* crear épicas
* importar ideas
* publicar documentación final

---

# 33. Principios

```text
RESEARCH_ROOT = contexto
status        = lifecycle
```

El contexto se resuelve automáticamente mediante:

```bash
codi commit issue-key
```

El lifecycle se administra mediante:

```text
draft
researched
validated
archived
```

Todo el almacenamiento se realiza bajo:

```text
$RESEARCH_ROOT
```

El skill no necesita conocer ninguna otra taxonomía de almacenamiento.