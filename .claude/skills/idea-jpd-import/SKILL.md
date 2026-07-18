---
name: idea-jpd-import
description: Listar ideas de JPD sin delivery y migrar su contenido a jpd/ideas/ del proyecto para que jpd-epic-generator las consuma
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.1.0"
  opencode:
    emoji: 🔗
    triggers:
      - "promover idea"
      - "listar ideas jpd"
      - "promote idea"
      - "ideas sin delivery"
    tags:
      - jira-product-discovery
      - bridge
      - ideas
    mcp:
      preferredServer: [jira]
---

# idea-jpd-import

Puente entre **Jira Product Discovery** (JPD) y la estructura local del proyecto. Lista ideas en JPD que aún no tienen delivery y migra su contenido a `jpd/ideas/` para que `jpd-epic-generator` y `jpd-task-generator` las consuman.

---

## Flujo general

```
JPD Ideas ──► Listar sin delivery ──► Seleccionar ──► Migrar a local
                   │                                     │
            Query JQL                          jpd/ideas/{key}-{slug}.md
            status=Validated                          ↓
            sin link a Epic                    jpd-epic-generator
```

---

## STEP 1 — Listar ideas sin delivery

### 1.1 — Obtener cloudId

```text
getAccessibleAtlassianResources
→ cloudId
```

### 1.2 — Consultar JPD por ideas sin delivery

Usar `jira_searchJiraIssuesUsingJql` con el siguiente JQL:

```sql
project = {JPD_PROJECT_KEY}
AND status = "Parking lot"
AND issueType = "Idea"
ORDER BY created DESC
```

> **Nota**: El `JPD_PROJECT_KEY` se obtiene del `codi.toml` (`jpd.projectKey`). Si no está configurado, preguntar al usuario.

**Alternativa si el JQL anterior no funciona:**

```sql
project = {JPD_PROJECT_KEY}
AND status in ("Parking lot", "To Do")
AND issueType = "Idea"
AND labels not in ("epic-created")
ORDER BY created DESC
```

### 1.3 — Parsear resultados

Para cada idea encontrada, extraer:

| Campo | Descripción |
|-------|-------------|
| `key` | ID de la idea (ej. `NIP-25`) |
| `summary` | Título de la idea |
| `status` | Estado actual |
| `score` | Score JPD (customfield) |
| `description` | Descripción/problema |

### 1.4 — Mostrar tabla al usuario

```text
📋 Ideas en JPD sin delivery:

┌─────────┬────────────────────────────────────┬───────────┬─────────┐
│ Key     │ Título                             │ Score     │ Status  │
├─────────┼────────────────────────────────────┼───────────┼─────────┤
│ NIP-25  │ MCP Jira Propio                    │ 25        │ Validated│
│ NIP-27  │ MCP Graphify                       │ 22        │ Validated│
│ NIP-28  │ Integración CI/CD                  │ 30        │ Validated│
└─────────┴────────────────────────────────────┴───────────┴─────────┘

¿Qué idea quieres migrar? (selecciona por key o escribe "todas")
```

---

## STEP 2 — Seleccionar idea

### 2.1 — Si el usuario selecciona una idea

Validar que la idea existe y fue retornada en STEP 1.

### 2.2 — Si el usuario escribe "todas"

Migrar cada idea listada secuencialmente.

---

## STEP 3 — Obtener contenido completo de JPD

### 3.1 — Obtener la idea completa

```text
getJiraIssue(cloudId, issueIdOrKey: <IDEA_KEY>, fields: ["*all"])
```

### 3.2 — Extraer contenido

| Sección JPD | Sección en archivo local |
|-------------|-------------------------|
| `summary` | Título (H1) |
| `description` | `## Idea` + `## Descripción` |
| Custom fields (score, etc.) | Frontmatter |
| Comentarios / attachments | `## Insights clave` (si existen) |

### 3.3 — Construir frontmatter

```yaml
---
type: jpd-idea
status: created
created: <YYYY-MM-DD>
jpd_issue_key: <IDEA_KEY>
jpd_url: https://<site>.atlassian.net/jira/software/c/projects/<JPD_PROJECT>/ideas/<IDEA_KEY>
created_at: <ISO-8601>
score: <SCORE>
---

# <SUMMARY>

## Idea

<description from JPD>

## Descripción

<additional context from JPD fields>

## Insights clave

<extracted from comments or custom fields>

## Valor para el equipo

<from JPD scoring criteria>

## Segmento objetivo

<from JPD>

## Posibles riesgos

<from JPD>

## Tareas potenciales

<extracted from JPD subtasks or checklist items>
```

---

## STEP 4 — Derivar PROJECT del path actual

### 4.1 — Buscar si ya existe un archivo para esta idea

```text
glob: 10-Projects/*/jpd/ideas/<IDEA_KEY>-*.md
```

### 4.2 — Si ya existe

```text
✅ La idea <IDEA_KEY> ya existe en: <path>
   ¿Quieres actualizarla con el contenido actual de JPD? (s/n)
```

Si el usuario dice "sí", actualizar el archivo existente.

### 4.3 — Si no existe

Usar el `PROJECT_KEY` del directorio actual o preguntar al usuario a qué proyecto pertenece.

**Opciones de PROJECT:**
1. Inferir del contexto (si hay archivos en `10-Projects/<PROJECT>/jpd/ideas/`)
2. Preguntar al usuario

---

## STEP 5 — Escribir archivo local

### 5.1 — Generar slug del título

```bash
SLUG=$(echo "$SUMMARY" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
```

### 5.2 — Determinar path de salida

```text
TARGET="10-Projects/${PROJECT}/jpd/ideas/${IDEA_KEY}-${SLUG}.md"
```

### 5.3 — Verificar si existe

Si ya existe un archivo con ese key pero diferente slug (ej. título fue editado en JPD):

```text
⚠️ Se encontró un archivo existente para <IDEA_KEY>:
   <path_existente>

   ¿Reemplazar o mantener? (reemplazar/mantener)
```

### 5.4 — Escribir archivo

```bash
mkdir -p "10-Projects/${PROJECT}/jpd/ideas"
cat > "$TARGET" << 'EOF'
<content from STEP 3>
EOF
```

---

## STEP 6 — Actualizar JPD (opcional)

Preguntar al usuario si quiere marcar la idea en JPD como "en proceso de delivery":

### 6.1 — Agregar label de tracking

```text
editJiraIssue(
  cloudId,
  issueIdOrKey: "<IDEA_KEY>",
  fields: {
    "labels": ["local-migrated", "<timestamp>"]
  }
)
```

### 6.2 — Agregar comentario

```text
addCommentToJiraIssue(
  cloudId,
  issueIdOrKey: "<IDEA_KEY>",
  commentBody: "📁 Migrado a estructura local: `10-Projects/{PROJECT}/jpd/ideas/<filename>`\n\nSiguiente paso: ejecutar \`jpd-epic-generator\` para generar el Epic."
)
```

---

## STEP 7 — Salida

```text
✅ Idea migrada:

   Idea:    <IDEA_KEY> — <SUMMARY>
   Archivo: 10-Projects/{PROJECT}/jpd/ideas/<IDEA_KEY>-<slug>.md
   JPD:     <jpd_url>

   Siguiente paso:
   1. Revisar el archivo generado
   2. Ejecutar: jpd-epic-generator <path-to-file>
   3. Ejecutar: markdown-to-jira para crear el Epic en Jira
```

---

## Data contract

```yaml
input:
  idea_id: string | null    # null = listar todas
  project_key: string | null
  force: boolean

jpd_query:
  cloud_id: string
  jpd_project_key: string
  ideas_found: number
  ideas: Array<{
    key: string
    summary: string
    score: number | null
    status: string
    description: string | null
  }>

migration:
  idea_key: string
  source: "jpd"
  target_path: string
  file_exists: boolean
  action: "created" | "updated" | "skipped"

output:
  status: "success" | "partial" | "skipped"
  migrated_count: number
  files: string[]
  message: string
```

---

## Reglas

- **NO crear Epics en Jira** — este skill solo migra contenido a `jpd/ideas/`
- **NO modificar el status en JPD** — solo agregar label de tracking (opcional)
- El archivo generado DEBE ser compatible con `jpd-epic-generator` (mismo formato que `jpd-create`)
- El frontmatter DEBE contener `jpd_issue_key` y `jpd_url`
- El slug del archivo DEBE ser derivado del título actual en JPD
- Si la idea ya existe localmente, preguntar antes de sobrescribir
- Usar `codi util short-uuid` solo si se necesita ID adicional

---

## Notas técnicas

| Aspecto | Detalle |
|---------|---------|
| **MCP preferido** | `[jira]` — consulta JPD vía API de Jira |
| **Query JQL** | `project = <JPD_KEY> AND status = "Parking lot" AND issueType = "Idea"` |
| **Campos JPD** | Los customfields varían por instancia. Usar `getJiraIssueTypeMetaWithFields` para descubrirlos |
| **Idempotencia** | Si el archivo ya existe con mismo key, preguntar antes de sobrescribir |
| **Output** | Archivo markdown en `jpd/ideas/` listo para `jpd-epic-generator` |