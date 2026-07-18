---
name: idea-capture
description: Investigate a topic using web search, codegraph, and codebase analysis — shows findings, classifies by PARA destination, saves with metadata for downstream consumption. When invoked without input, lists existing researched drafts for review and promotion.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.1.0"
  opencode:
    emoji: 🔍
    tags:
      - research
      - para
      - obsidian
      - knowledge
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
---

# idea-capture

Skill unificado para todo el ciclo de investigación. Si el usuario provee un tema, URL o texto → investiga y crea un draft. Si invoca sin input → lista los drafts existentes en estado `researched` para revisar, enriquecer o promover a `validated`.

**Input**: Tema a investigar, URL, texto, o idea conceptual (modo investigación). Nada (modo browse).
**Output**:
- Draft en `00-Inbox/drafts/<destino>/<estado>/<fecha>-<slug>.md` (modo investigación)
- Draft promovido a `00-Inbox/drafts/<destino>/validated/<archivo>` (modo browse)

**Template (modo investigación)**: `<skill_root>/research-draft.md.tpl`

---

## Branch determinista

Al recibir input:
- **Si hay input** (tema, URL, texto) → Modo INVESTIGAR
- **Si no hay input** → Modo BROWSE

---

## MODO 1 — INVESTIGAR (con input)

### 1. Recibir input

El usuario provee un tema, URL, texto, o idea. Si no provee nada → caer al Modo BROWSE.

### 2. Investigar

Buscar información relevante en paralelo:
- **Web search** — búsqueda del tema
- **GitHub Search** — ejemplos de código real en repositorios públicos vía `github_search_code` / `grep_searchGitHub`
- **Codegraph** — símbolos relacionados en el codebase
- **Codebase** — archivos y patrones existentes
- **Graphify** — arquitectura, god nodes, comunidades y relaciones del codebase
- **Context7** — documentación oficial de librerías y frameworks

### 3. Mostrar hallazgos

Presentar resumen estructurado:
- Hallazgos principales
- Fuentes consultadas
- Relación con el codebase (si aplica)

### 4. Clasificar destino

Preguntar al usuario:

```
¿Esto pertenece a?
1. 10-Projects/<proyecto>/
2. 20-Areas/<area>/
3. 30-Resources/<subdir>/
4. 00-Inbox/drafts/general/ (default)
```

Si el usuario elige 1-3 y la carpeta no existe, preguntar si crearla.

### 5. Definir estado

Preguntar:

```
¿Estado?
1. raw — información sin procesar
2. researched — información revisada (default)
3. validated — información confirmada
```

### 6. Preparar variables para template

Definir variables directamente para gomplate:

```bash
STATUS="<ESTADO>"
SOURCE="<SOURCE>"
CAPTURED_AT="<FECHA_HORA>"
DESTINO="<DESTINO>"
TITULO="<TITULO>"
TAGS="<TAGS_SEPARADOS_COMA>"
FINDINGS="<HALLAZGOS_RESUMEN>"
SOURCES="<FUENTES_CONSULTADAS>"
```

### 7. Preview del draft

ANTES de escribir, mostrar el contenido completo que se generará:

```text
📄 Preview del draft:

═══════════════════════════════════════════════════════════════
# <TITULO>

## Research
<FINDINGS_RESUMEN>

## Fuentes
<SOURCES_LIST>

## Tags
<TAGS>
═══════════════════════════════════════════════════════════════

📍 Destino: 00-Inbox/drafts/<DESTINO>/<ESTADO>/
📄 Archivo: <FECHA>-<SLUG>.md
```

Preguntar al usuario:

```
¿Confirmas la escritura? (s/n/editar)
```

- **s** → proceder a STEP 8 (gomplate)
- **n** → cancelar
- **editar** → permitir modificar título, tags, o findings antes de continuar

### 8. Renderizar con gomplate

```bash
gomplate \
  -f <skill_root>/research-draft.md.tpl \
  -o "00-Inbox/drafts/${DESTINO}/${ESTADO}/${FECHA}-${SLUG}.md" \
  --var status="${STATUS}" \
  --var source="${SOURCE}" \
  --var captured_at="${CAPTURED_AT}" \
  --var destination="${DESTINO}" \
  --var titulo="${TITULO}" \
  --var tags="${TAGS}" \
  --var findings="${FINDINGS}" \
  --var sources="${SOURCES}"
```

### 9. Confirmar y verificar

Mostrar resumen y confirmar antes de escribir:

```
📄 Resumen:
   Tema: <tema>
   Hallazgos: <resumen breve>
   Destino: 00-Inbox/drafts/<destino>/<estado>/
   Archivo: <fecha>-<slug>.md
   ¿Confirmas? (si/no)
```

El archivo ya fue escrito por gomplate en STEP 8. Verificar que existe.

### 10. Post-guardado

- ✅ Investigación guardada en `00-Inbox/drafts/<destino>/<estado>/<archivo>`
- Consumible por: `idea-jpd-draft` → `idea-jpd-create` / `jpd-epic-generator`

---

## MODO 2 — BROWSE (sin input)

### 1. Escanear drafts researched

Buscar todos los archivos bajo `00-Inbox/drafts/**/researched/*.md`.

Para cada draft, extraer del frontmatter:
- `destination` — proyecto/área destino
- `type` — tipo de investigación
- `source` — fuentes consultadas
- `tags` — etiquetas
- `captured_at` — fecha de captura
- `related_docs` — docs relacionados (si aplica)

### 2. Mostrar resumen organizado

Presentar los drafts agrupados por `destination`:

```
📁 <destination>/
├── <archivo-1> — <título> (tags: ..., captured_at: ...)
├── <archivo-2> — <título> (tags: ..., captured_at: ...)
```

Si solo hay un destination, mostrar plano. Si hay varios, agrupar.

### 3. Seleccionar draft

Preguntar al usuario qué draft quiere revisar (por número o nombre).

### 4. Mostrar contenido del draft

Desplegar el contenido completo del draft seleccionado (o las secciones principales si es extenso) para que el usuario evalúe si:
- La información está completa
- Necesita agregar más contenido
- Está lista para promoverse a `validated`

### 5. Decidir acción

Preguntar al usuario:

```
¿Qué hacemos con <nombre-draft>?
1. Agregar más contenido — editar el draft existente
2. Promover a validated — mover a drafts/<destino>/validated/
3. Volver a raw — necesita más investigación, bajar a raw
4. Salir sin cambios
```

#### Opción 1: Agregar contenido
- Preguntar qué sección agregar o modificar
- Ofrecer búsqueda en GitHub (`grep_searchGitHub` / `github_search_code`) como fuente adicional si necesita más evidencia o ejemplos
- Editar el archivo directamente
- Mantener el estado `researched`

#### Opción 2: Promover a validated
1. Cambiar `status: researched` → `status: validated` en frontmatter
2. Agregar `validated_at: "YYYY-MM-DD HH:mm"` al frontmatter
3. Agregar `validated_by: Luchex` al frontmatter
4. Mover el archivo a `00-Inbox/drafts/<destino>/validated/<archivo>`
5. Confirmar que la carpeta `validated/` existe (crearla si no)

#### Opción 3: Volver a raw
1. Preguntar si desea buscar en GitHub (`grep_searchGitHub`) para encontrar más evidencia antes de degradar
2. Cambiar `status: researched` → `status: raw` en frontmatter
3. Agregar `notes: "Volvió a raw por: <razón>"` al frontmatter
4. Mover el archivo a `00-Inbox/drafts/<destino>/raw/<archivo>`
5. Confirmar que la carpeta `raw/` existe (crearla si no)

### 6. Post-acción

- **Si promovió a validated**: el draft está listo para `idea-jpd-draft` → `idea-jpd-create` → `idea-jpd-promote` / `jpd-epic-generator`
- **Si agregó contenido**: queda en researched, disponible para otro `idea-capture` (modo browse) después
- **Si volvió a raw**: necesita pasar por `idea-research` (modo investigación) de nuevo

---

## Formato del draft promovido

Al promover a `validated`, el frontmatter queda:

```yaml
---
type: research
status: validated
source: <original source>
captured_at: "<original date>"
validated_at: "<YYYY-MM-DD HH:mm>"
validated_by: Luchex
tags:
  - <tags>
destination: <destino>
related_docs:
  - <docs>
---
```

---

## Reglas

1. Si hay input → modo investigación; si no → modo browse
2. En modo investigación, siempre buscar en web + GitHub + codegraph + codebase + graphify + context7 en paralelo
3. En modo browse, siempre mostrar los drafts antes de pedir selección
4. En modo browse, siempre mostrar el contenido completo del draft seleccionado antes de decidir acción
5. Siempre preguntar destino y estado en modo investigación — no asumir sin preguntar
6. Siempre confirmar antes de escribir o mover archivos
7. No sobrescribir archivos sin confirmación
8. Si la carpeta destino no existe, preguntar si crearla
9. Al promover, preservar todo el contenido original del draft

## Dependencias

- **Upstream**: (ninguno — entry point del pipeline de investigación)
- **Downstream**: `idea-jpd-draft` → `idea-jpd-create` → `idea-jpd-import` / `jpd-epic-generator`