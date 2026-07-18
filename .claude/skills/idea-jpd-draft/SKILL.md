---
name: idea-jpd-draft
description: Tomar una idea validated en drafts/, estructurarla como JPD draft y guardar en 10-Projects/{PROJECT}/jpd/draft/, archivando el original.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.1.0"
  opencode:
    emoji: 📝
    triggers:
      - "enriquecer draft"
      - "madurar idea"
      - "estructurar idea"
      - "draft enrich"
      - "draft desde validated"
    tags:
      - drafts
      - jpd
      - enrichment
    mcp:
      preferredServer: [filesystem]
---

# idea-jpd-draft

Skill para tomar un draft en estado `validated` dentro de `00-Inbox/drafts/`, estructurarlo con el formato completo (insights, valor, riesgos, tareas potenciales), guardarlo como JPD draft en `10-Projects/{PROJECT}/jpd/draft/`, y archivar el original.

**Input**: Draft validated en `00-Inbox/drafts/<destino>/validated/<archivo>.md` (o `--path="/ruta/al/archivo.md"` para saltar el listado)
**Output**:
  - Documento JPD draft en `10-Projects/<proyecto>/jpd/draft/<slug>.md`
  - Original movido a `00-Inbox/drafts/<destino>/archived/<archivo>.md`

---

## Flujo general

```
drafts/**/validated/idea.md ──► idea-jpd-draft ──► 10-Projects/{PROJECT}/jpd/draft/<slug>.md
                                        │          drafts/**/archived/idea.md
                                    preguntar al usuario
                                    cada sección del template
```

---

## Template de idea (JPD Draft)

El documento enriquecido sigue esta estructura:

```markdown
---
type: jpd-draft
status: enriched
created: <YYYY-MM-DD>
source_draft: <nombre-del-archivo-original.md>
---

# <Título de la idea>

## Idea

<one-liner del concepto>

## Descripción

<problema que resuelve, contexto actual>

## Insights clave

### <Insight 1>
<detalle>

### <Insight 2>
<detalle>

...

## Valor para el equipo

| Antes | Después |
|---|---|
| <situación actual> | <situación deseada> |
| ... | ... |

## Segmento objetivo

- <a quién impacta>
- <quién se beneficia>

## Posibles riesgos

- <riesgo 1>
- <riesgo 2>

## Tareas potenciales

<contexto opcional: dónde se implementa>

### 1. <Título de la tarea>
<Descripción detallada>

### 2. <Título de la tarea>
<Descripción detallada>
```

---

## Flujo de ejecución

### Paso 1 — Identificar el draft validated

**Si recibió `--path`**:
1. Verificar que el path existe y corresponde a un draft validated
2. Si no existe → informar y caer al flujo de listado
3. Si existe → leer el contenido del draft seleccionado → ir al Paso 2
4. Derivar el `{PROJECT}` igual que abajo

**Si no recibió path**:
1. Listar archivos en `00-Inbox/drafts/**/validated/*.md`
2. **Guard clause**: si no hay resultados, informar al usuario:
   > "No encontré drafts en estado `validated`. Para promover uno desde `researched`, ejecuta `idea-research` (modo browse) primero."
3. Si hay resultados, mostrarlos al usuario organizados por destino
4. Preguntar al usuario cuál quiere convertir a JPD draft
5. Leer el contenido del draft seleccionado
6. Derivar el `{PROJECT}` del campo `destination` del frontmatter:
   - `10-Projects/CodipAI/` → `CodipAI`
   - Si no tiene destination → preguntar al usuario

### Paso 2 — Recolectar información sección por sección

Para cada sección del template, preguntar al usuario:

| Sección | Pregunta al usuario |
|---|---|
| **Idea** | "¿Cuál es el concepto en una línea?" |
| **Descripción** | "¿Qué problema resuelve? ¿Cuál es el contexto actual?" |
| **Insights clave** | "¿Qué hallazgos o investigaciones hay? (uno por uno)" |
| **Valor para el equipo** | "¿Cómo se ve el antes y después para el equipo?" |
| **Segmento objetivo** | "¿A quiénes impacta esta idea?" |
| **Posibles riesgos** | "¿Qué obstáculos ves?" |
| **Tareas potenciales** | "¿Qué tareas habría que hacer?" |

Reglas:
- Usar datos ya presentes en la conversación para pre-llenar secciones
- Si el usuario no tiene respuesta para una sección, dejarla como `TBD` — no inventar
- Para Insights, permitir múltiples iteraciones (preguntar "¿algún otro insight?")

### Paso 3 — Generar el JPD draft (gomplate)

1. Generar slug: `echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//'`
2. Crear directorio: `mkdir -p "10-Projects/${PROJECT}/jpd/draft"`
3. Construir datasource YAML temporal con los datos recolectados en el Paso 2:

   ```yaml
   # /tmp/jpd-draft-data.yaml
   idea:
     title: "<TITULO>"
     one_liner: "<ONE_LINER>"
     description: "<DESCRIPCION>"
     insights:
       - title: "<INSIGHT_1>"
         detail: "<DETALLE_1>"
       - title: "<INSIGHT_2>"
         detail: "<DETALLE_2>"
     value:
       - before: "<ANTES_1>"
         after: "<DESPUES_1>"
     segments:
       - "<SEGMENTO_1>"
     risks:
       - "<RIESGO_1>"
     tasks_intro: "<CONTEXTO_OPCIONAL>"
     tasks:
       - title: "<TAREA_1>"
         detail: "<DESCRIPCION_DETALLADA>"
     created: "<YYYY-MM-DD>"
     source_draft: "<ARCHIVO_ORIGINAL>"
   ```

4. Renderizar con gomplate:

   ```bash
   gomplate --context idea=/tmp/jpd-draft-data.yaml#yaml \
     -f <skill_root>/jpd-draft.md.tpl \
     -o "10-Projects/${PROJECT}/jpd/draft/<YYYY-MM-DD>-<slug>.md"
   ```

5. Limpiar archivo temporal: `rm /tmp/jpd-draft-data.yaml`

### Paso 4 — Archivar el original

1. Determinar la carpeta `archived/` bajo el mismo destino: `00-Inbox/drafts/<destino>/archived/`
2. Crear si no existe: `mkdir -p "00-Inbox/drafts/${DESTINO}/archived"`
3. Mover el archivo validated original: `mv "drafts/${DESTINO}/validated/${ARCHIVO}" "drafts/${DESTINO}/archived/${ARCHIVO}"`
4. Actualizar su frontmatter: agregar `archived_at: "<YYYY-MM-DD HH:mm>"` y `archived_by: idea-jpd-draft`

### Paso 5 — Finalizar draft y promover a validated

Preguntar: "¿El draft está completo y listo para crear en Jira Product Discovery?"

- Si **sí**:
  1. Crear directorio: `mkdir -p "10-Projects/${PROJECT}/jpd/validated"`
  2. Mover archivo: `mv "10-Projects/${PROJECT}/jpd/draft/<slug>.md" "10-Projects/${PROJECT}/jpd/validated/<slug>.md"`
  3. Actualizar frontmatter: cambiar `status: enriched` → `status: ready`, agregar `finalized_at: "<YYYY-MM-DD HH:mm>"`, `finalized_by: idea-jpd-draft`
  4. Informar: "Draft finalizado en `10-Projects/${PROJECT}/jpd/validated/`. Está listo para `idea-jpd-create`."
- Si **no**: "OK, queda en `10-Projects/${PROJECT}/jpd/draft/` para seguir editando después. Cuando esté listo, ejecuta `idea-jpd-draft` sobre él otra vez."

---

## Reglas

1. Solo operar sobre drafts en estado `validated` — ignorar `researched` y `raw`
2. No inventar valores para secciones que el usuario no complete — usar `TBD`
3. No sobrescribir el draft original — archivarlo
4. Si el draft ya fue archivado, preguntar si quiere desarchivar o crear uno nuevo
5. Mostrar resumen antes de escribir el archivo
6. Confirmar con el usuario antes de crear el archivo
7. El proyecto se deriva del `destination` del frontmatter (prefijo `10-Projects/`)
8. Si el frontmatter ya tiene `status: ready`, preguntar si quiere actualizarlo o pasarlo directamente a `idea-jpd-create`

---

## Dependencias

- **Upstream**: `idea-research` (modo browse) — promueve drafts a `validated`
- **Downstream**: `idea-jpd-create` — crea la idea en Jira Product Discovery desde `jpd/{PROJECT}/validated/`