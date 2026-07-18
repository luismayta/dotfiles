---
name: jpd-epic-generator
description: Generar artefactos Epic + Tasks en 10-Projects/{PROJECT}/jira/{jpd_issue_key}/draft/ desde una idea existente en Jira Product Discovery.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.1.0"
  opencode:
    emoji: 📋
    triggers:
      - "generar epic desde jpd"
      - "jpd epic"
      - "epic spec"
    tags:
      - jira-product-discovery
      - epic
      - spec
    mcp:
      preferredServer: [jira, filesystem]
---

# jpd-epic-generator

Skill para generar 1 artefacto Epic con Tasks inline desde una idea de Jira Product Discovery (JPD), usando los templates locales `EPIC.md.tpl` y `TASK.md.tpl`. El artefacto único se escribe en `10-Projects/{PROJECT}/jira/{jpd_issue_key}/draft/`.

---

## Overview

```
[Archivo] jpd/ideas/{key}-{slug}.md
  → [STEP 0] Validar archivo + frontmatter
  → [STEP 1] Leer frontmatter + secciones (Descripción, Tareas, Valor, ROI)
  → [STEP 2] Derivar {PROJECT} + {key} del path
  → [STEP 3] Crear directorio 10-Projects/{PROJECT}/jira/{key}/draft/
  → [STEP 4-6] Renderizar Epic + Tasks inline via templates
  → [STEP 7] Escribir archivo único en draft/
```

---

## Input

- **Archivo de la idea** (obligatorio): path al archivo en `jpd/ideas/{key}-{slug}.md`.

## Output

```
10-Projects/{PROJECT}/jira/{key}/draft/
└── epic-{slug}-{shortuuid}.md      # 1 archivo: Epic + Tasks inline
```

---

## Flow

### STEP 0 — Recibir archivo de idea

1. El usuario pasa el path al archivo en `jpd/ideas/{key}-{slug}.md`.
2. Validar que el archivo existe.
3. Validar que el frontmatter contiene `jpd_issue_key`.

### STEP 1 — Leer y parsear la idea JPD

1. Leer el archivo completo.
2. Extraer del frontmatter todos los campos disponibles:

   ```yaml
   type: jpd-draft
   status: created
   created: 2026-07-09
   finalized_at: "2026-07-09 16:45"
   finalized_by: idea-jpd-draft
   source_draft: 00-Inbox/drafts/CodipAI/validated/...md
   jpd_issue_key: "NIP-25"                # → {key} para el path
   jpd_url: "https://..."                 # → link a la idea en JPD
   created_at: "2026-07-09 17:45"
   ```

3. Extraer secciones del body:
   - Título (H1 del body)
   - `## Idea` o `## Descripción` → descripción principal
   - `## Insights clave` → contexto técnico
   - `## Valor para el equipo` → business value
   - `## ROI estimado` → métricas
   - `## Tareas potenciales` → lista de tasks derivadas
   - `## Segmento objetivo`, `## Posibles riesgos` → contexto adicional

### STEP 2 — Derivar PROJECT + key del path

Del path `10-Projects/{PROJECT}/jpd/ideas/{key}-{slug}.md` extraer `{PROJECT}` y `{key}` automáticamente. Validar que `{key}` coincida con el `jpd_issue_key` del frontmatter.

### STEP 2.5 — Resolver PROJECT_KEY (preguntar al usuario)

El `projectKey` del Epic NO se deriva del JPD issue key. Preguntar al usuario:

```
¿A qué proyecto de Jira Software va este Epic? (ej. PE, RD)
```

Validar que el proyecto existe en Jira usando `getVisibleJiraProjects` del MCP de Jira:
1. Obtener el cloudId vía `getAccessibleAtlassianResources`
2. Llamar `getVisibleJiraProjects(cloudId)`
3. Si el proyecto ingresado existe → usarlo como PROJECT_KEY
4. Si no existe → mostrar error y pedir un proyecto válido de la lista

> La JPD issue key (ej. NIP-25) se preserva en el campo `jpdSource` de la metadata, no en `projectKey`.

### STEP 3 — Crear directorio de salida

```bash
mkdir -p "10-Projects/${PROJECT}/jira/${KEY}/draft"
```

### STEP 4 — Generar slug + shortuuid

```bash
EPIC_SLUG=$(echo "$EPIC_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
ID=$(codi util short-uuid)
```

### STEP 5 — Renderizar cada Task con gomplate

1. Leer `TASK.md.tpl` del directorio del skill.
2. Por cada ítem en `## Tareas potenciales`, extraer: title, summary, scenario, acceptance_tests, sources.
3. Para cada task, generar un data file YAML temporal con las variables:

   | Variable | Valor |
   |---|---|
   | `TASK_TITLE` | title de la task |
   | `PROJECT_KEY` | preguntado al usuario en STEP 2.5 |
   | `TASK_SUMMARY` | summary de la task |
   | `COMPONENT` | del frontmatter o inferido |
   | `LABELS` | del frontmatter |
    | `PARENT_EPIC` | `SUMMARY` del Epic (máx. 120 chars, verbo de acción) |
   | `JPD_ISSUE_KEY` | del frontmatter |
   | `TASK_SCENARIO` | scenario de la task |
   | `TASK_ACCEPTANCE_TESTS` | acceptance_tests de la task |
   | `TASK_SOURCES` | sources de la task |

4. Renderizar cada task:

   ```bash
   gomplate -f /path/to/TASK.md.tpl -d /tmp/task-vars.yaml
   ```

5. Si `gomplate` falla (ej. TASK_SUMMARY > 120 caracteres), mostrar el error de validación y detener.
6. Acumular todas las tasks renderizadas en una variable `TASKS_RENDERED`, separadas por `\n\n---\n\n`.

> Los templates usan sintaxis gomplate (`{{.VAR}}`). La validación de longitud máxima (120 caracteres para summary) está definida en los propios templates.

### STEP 6 — Renderizar Epic con gomplate

1. Leer `EPIC.md.tpl` del directorio del skill.
2. Generar un data file YAML temporal con todas las variables del Epic, incluyendo `TASKS` con el contenido de `TASKS_RENDERED` del STEP 5.
3. Renderizar:

   ```bash
   gomplate -f /path/to/EPIC.md.tpl -d /tmp/epic-vars.yaml > /tmp/epic-rendered.md
   ```

4. Si `gomplate` falla (ej. SUMMARY > 120 caracteres), mostrar el error de validación y pedir al usuario que acorte el summary.
5. Si pasa, leer `/tmp/epic-rendered.md` para obtener el contenido final.
6. Verificar que todas las variables `{{.VAR}}` fueron resueltas (no debe quedar ninguna sin sustituir).

### STEP 7 — Escribir archivo único

```bash
TARGET="10-Projects/${PROJECT}/jira/${KEY}/draft/epic-${EPIC_SLUG}-${ID}.md"
```

Escribir el contenido renderizado en `$TARGET`. Verificar:

```bash
wc -l "$TARGET"
```

---

## Reglas

- El archivo de entrada DEBE estar en `jpd/ideas/`. Si no está ahí, error: "La idea no está en el directorio jpd/ideas/. Muévela con `idea-jpd-create`."
- El frontmatter DEBE contener `jpd_issue_key` y `jpd_url`. Si falta alguno, error: "La idea no está creada en JPD. Ejecuta `idea-jpd-create` primero."
- El `jpd_issue_key` del frontmatter DEBE coincidir con el `{key}` del path del archivo. Si no, error y pedir corrección.
- Si ya existe un archivo en `10-Projects/{PROJECT}/jira/{KEY}/draft/`, preguntar si sobrescribir o generar con nuevo shortuuid.
- Si se necesita generar una Task standalone (fuera de un Epic), usar `jpd-task-generator` en lugar de este skill.
- Los templates `EPIC.md.tpl` y `TASK.md.tpl` se leen de `<skill_root>/`. Si alguno falta, error: "Template faltante en el skill. Reinstala jpd-epic-generator."
- No crear issues en Jira — solo generar artefactos markdown compatibles con `markdown-to-jira`.
- El summary del Epic DEBE ser una frase corta con verbo de acción (ej. "Implementar...", "Construir...", "Crear..."), máximo 120 caracteres. NO copiar textualmente párrafos largos de la descripción.

---

## Dependencias

- **Upstream**: `idea-jpd-create` — produce ideas en `jpd/ideas/` con `jpd_issue_key`
- **Sibling**: `jpd-task-generator` — para generar Tasks standalone
- **Downstream**: `markdown-to-jira` — consume los artefactos de `draft/` para crear issues en Jira Software
- **Templates**: `<skill_root>/EPIC.md.tpl`, `<skill_root>/TASK.md.tpl`