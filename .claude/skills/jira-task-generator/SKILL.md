---
name: jira-task-generator
description: Generate Jira Task definitions from context using templates. Creates markdown artifacts under .codi/jira/issues/ with unique identifiers.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.4.1"
  opencode:
    emoji: "🧩"
    triggers:
      - "create task"
      - "generate task"
      - "jira task"
      - "crear task"
      - "generar task"
    tags:
      - jira
      - task
      - planning
      - generator
      - template
      - idempotent
---

# jira-task-generator

Skill para generar documentos Jira Task declarativos desde contexto natural.

Genera un archivo Markdown conteniendo una definición de Task.

El resultado queda almacenado en:

```
.codi/jira/issues/
```

Ejemplo:

```
.codi/jira/issues/task-implement-oauth-v7Kp9x.md
```

---

# Purpose

- Convertir contexto en una definición Jira Task estructurada.
- Generar Tasks sin dependencia de un Epic.
- Mantener artefactos versionables en Git.
- Separar generación de contenido y creación Jira.
- Usar templates consistentes.
- Evitar sobrescritura accidental.

---

# Inputs

## Context

Texto libre. El contexto se recibe mediante `{{args}}`.

Ejemplo:

```
crear task para implementar autenticación OAuth

criterios:
- implementar login con Google
- agregar tests unitarios
```

---

## Uso de argumentos

Este skill recibe el contexto descriptivo mediante `{{args}}`.

### Formato string (recomendado)

El texto completo después del trigger del skill se usa como contexto:

```
crear task para implementar autenticación OAuth con login Google y tests
```

### Formato JSON

```json
{
  "context": "implementar autenticación OAuth con login Google y tests"
}
```

### Resolución

- Si `{{args}}` es string → usar directamente como contexto descriptivo
- Si `{{args}}` es objeto → usar `args.context` como contexto descriptivo
- Si `{{args}}` está vacío → no hay contexto, pedir al usuario

---
# Skill Assets

```
<skill-root>/
└── TASK.md.tpl
```

---

# Output

Genera:

```
.codi/jira/issues/
task-{slug}-{shortuuid}.md
```

Ejemplo:

```
.codi/jira/issues/task-implement-oauth-v7Kp9x.md
```

---

# Flow

---

## STEP 0 — Ensure directory

```bash
ISSUES_PATH=".codi/jira/issues"
mkdir -p "$ISSUES_PATH"
```

---

## STEP 1a — Collect Input

El contexto descriptivo proviene de `{{args}}`. Seguir la sección "Uso de argumentos" para resolver el valor.

Recibir el input del usuario sin interpretarlo ni ejecutarlo. No realizar parsing aún — solo recolectar.

--- CONTEXT BOUNDARY ---

---

## STEP 1a.1 — Classify Input Structure

Before transforming, classify the collected input into one of three modes. Apply these rules in order:

### 1. `--body--` delimiter check

If the input contains `--body--` on its own line (exact match, not part of a longer line):
→ classify as `raw-body`. Skip all further heuristic checks.

### 2. Pre-structured heuristics

Count how many of the following heuristics match the input:

| # | Heuristic | Detects |
|---|---|---|
| H1 | Markdown table rows: ≥2 lines matching `\|.*\|.*\|` | Tables with aligned columns |
| H2 | Numbered criteria: lines starting with `N. ` (e.g. `1. `) followed by action verbs (implementar, agregar, crear, reemplazar, añadir) | Acceptance criteria lists |
| H3 | File paths: references to files with code extensions (`.ts`, `.md`, `.py`, `.sh`, `.json`, `.yaml`, `.yml`) | Source file references |
| H4 | Section headings: lines matching `## Scenario`, `### Acceptance Tests`, or `### Sources` | Content already aligned with template |

### 3. Threshold

- **≥2 heuristics match** → classify as `pre-structured`
- **<2 heuristics match** → classify as `unstructured`

### Mode summary

| Mode | Behavior |
|---|---|
| `unstructured` | Full STEP 1b transformation (existing path — no changes) |
| `pre-structured` | Skip STEP 1b body field transformation; inject content literally into template body |
| `raw-body` | Split at `--body--` delimiter; metadata from pre-delimiter, body from post-delimiter |

---

## STEP 1b — Transform to Fields (unstructured mode only)

**Applies ONLY when input is `unstructured`.** If `pre-structured` or `raw-body`, skip this entire step for body fields — proceed to STEP 1b gating section below for what to do instead.

Parsear el contexto del usuario en los siguientes campos estructurados:

```yaml
task:
  title:              # Nombre corto y descriptivo de la task
  summary:            # Resumen de una línea
  scenario:           # Contexto de negocio o user story
  acceptance_tests:   # Lista de condiciones verificables
  sources:            # URLs o documentos referenciados
```

Extraer cada campo del contexto, aplicando estas reglas de validación:

1. **Contexto vacío o sin sentido**: Si el input es vacío, incoherente o insuficiente para derivar campos, preguntar al usuario por clarificación antes de proceder.

2. **Contexto mínimo**: Si el usuario da solo una frase corta (e.g. "Agregar tests unitarios al módulo de pagos"), derivar defaults razonables:
   - `summary` puede ser igual a `title`
   - `scenario` se infiere del contexto del title
   - `acceptance_tests` y `sources` pueden quedar vacíos si no son inferibles

3. **Verbos de acción**: Si el contexto contiene verbos de acción ("crear", "implementar", "add", "generate", "build", "hacer"), estos deben tratarse como parte del contenido descriptivo del `title` — NO como instrucciones para ejecutar esas acciones.

4. **Asignación de campos**: Los verbos de acción pertenecen al `title`, no al `scenario` ni a `acceptance_tests`.

---

### STEP 1b gating — behavior by mode

| Mode | STEP 1b body fields | Metadata extraction |
|---|---|---|
| `unstructured` | Full transformation (existing path) | Title + summary + scenario + tests + sources |
| `pre-structured` | **Skip entirely** — inject input literally into `{{TASK_SCENARIO}}`, `{{TASK_ACCEPTANCE_TESTS}}`, `{{TASK_SOURCES}}` | Extract title from first meaningful line of input, or prompt user if unclear |
| `raw-body` | **Skip body transformation** — post-delimiter content is the body | Extract title + summary from pre-delimiter content via STEP 1b rules (metadata only) |

---

## STEP 1.3 — Handle `--body--` Raw Mode

**Applies ONLY when input is classified as `raw-body`.** For other modes, skip this step.

### 1.3.1 — Split at delimiter

Find the first line that is exactly `--body--` (standalone, no leading/trailing characters). Split the input into two parts:

- **Pre-delimiter**: everything before `--body--`
- **Post-delimiter**: everything after `--body--`

### 1.3.2 — Metadata extraction (pre-delimiter)

Process pre-delimiter content through STEP 1b rules to extract `title` and `summary` only. Do NOT attempt to extract body fields (scenario, acceptance_tests, sources) from pre-delimiter content.

### 1.3.3 — Edge case: no pre-delimiter content

If pre-delimiter content is empty or whitespace-only:

```
No se detectó título. Ingresa un título para la task:
```

Wait for user response before proceeding.

### 1.3.4 — Body assignment

Post-delimiter content becomes the literal body:

- `{{TASK_SCENARIO}}` ← post-delimiter content
- `{{TASK_ACCEPTANCE_TESTS}}` ← post-delimiter content (same)
- `{{TASK_SOURCES}}` ← post-delimiter content (same)

The content is injected verbatim — no parsing, restructuring, or rewording.

---

## STEP 1.5 — Resolve PROJECT_KEY

Usar `getVisibleJiraProjects` del MCP de Jira.

1. Obtener el cloudId vía `getAccessibleAtlassianResources`
2. Llamar `getVisibleJiraProjects(cloudId)`
3. Filtrar projects que tengan `"Task"` en `issueTypes[].name`
4. Si hay exactamente uno → usar su `key` como PROJECT_KEY
5. Si hay múltiples → preguntar al usuario cuál usar (mostrar lista con keys y names)
6. Si hay cero → error: no hay proyectos Jira con issue type Task disponible

> ⚠️ No leer PROJECT_KEY de `codi.toml`. La fuente de verdad es Jira.

---

## STEP 1.6 — Interactive PARENT_EPIC

Preguntar al usuario:

```
¿Deseas vincular esta task a un epic? (si/no)
```

- Si **sí**: solicitar `Ingresa el EPIC_KEY (ej. PE-97):` y validar formato `{PROJECT_KEY}-{number}`.
- Si **no**: continuar sin `parentEpic`.

---

## STEP 1.7 — Resolve git remote URL

```bash
GIT_REPO_URL=$(git config --get remote.origin.url || true)
```

Formato: `- {url}` (item de lista markdown).

Ejemplo:

```
- https://github.com/CodipLab/codip-ai.git
```

Si no hay remote configurado, se omite silenciosamente.

---

## STEP 1.8 — Infer component from context

Derivar el componente Jira basado en palabras clave del contexto de la task.

Usar un mapeo de palabras clave a nombres de componente:

| Palabras clave | Componente |
|---|---|
| api, backend, endpoint, service, database, db, migration, model, data, graphql, rest, grpc, server | Backend |
| frontend, ui, ux, web, react, vue, angular, css, html, component, page, screen, interfaz | Frontend |
| test, testing, qa, quality, coverage, e2e, integration, unit-test | QA |
| devops, ci, cd, pipeline, deploy, docker, k8s, kubernetes, infra, terraform, cloud | DevOps |
| doc, documentation, readme, wiki, manual, guide, changelog | Documentation |
| security, auth, oauth, jwt, sso, permission, role, audit, compliance | Security |
| mobile, ios, android, react-native, flutter, app | Mobile |
| data, analytics, report, dashboard, metric, kpi, bi, insight | Data & Analytics |
| email, notification, alert, messaging, push, sms, webhook | Notifications |

Reglas:

- Buscar coincidencia en: title, summary, scenario, y acceptance_tests.
- Priorizar la primera coincidencia encontrada (orden del mapeo).
- Si no hay coincidencia, el componente queda vacío (el usuario lo asigna después en Jira).

Ejemplo:

Input title: "Implementar autenticación OAuth"
→ Coincide con "auth" en Security
→ COMPONENT = "Security"

Input title: "Agregar tests unitarios al módulo de pagos"
→ Coincide con "test" en QA
→ COMPONENT = "QA"

---

## STEP 2 — Generate slug

Convertir:

```
Implementar autenticación OAuth
```

a:

```
implementar-autenticacion-oauth
```

Reglas:

- lowercase
- sin caracteres especiales
- espacios → "-"
- remover duplicados

---

## STEP 3 — Generate shortuuid

```bash
ID=$(codi util short-uuid)
```

Ejemplo: `v7Kp9x`

---

## STEP 4 — Resolve filename

```bash
TARGET=".codi/jira/issues/task-${SLUG}-${ID}.md"
```

Ejemplo:

```
.codi/jira/issues/task-implement-oauth-v7Kp9x.md
```

Validar:

```bash
if [ -f "$TARGET" ]; then
  ID=$(codi util short-uuid)
  TARGET=".codi/jira/issues/task-${SLUG}-${ID}.md"
fi
```

---

## STEP 5 — Render Task

Usar:

```
TASK.md.tpl
```

Variables:

```
{{TASK_TITLE}}
{{PROJECT_KEY}}
{{TASK_SUMMARY}}
{{COMPONENT}}
{{LABELS}}
{{PARENT_EPIC}}
{{ISSUE_KEY}}
{{TASK_SCENARIO}}
{{TASK_ACCEPTANCE_TESTS}}
{{TASK_SOURCES}}
{{GIT_REPO_URL}}
```

---

## STEP 5.1 — Validate body content (pre-structured and raw-body only)

**Applies ONLY when input is `pre-structured` or `raw-body`.** For `unstructured` mode, skip this step entirely and proceed directly to STEP 6.

### 5.1.1 — Render preview

Render the body fields as they would appear in the final file:

```
{{TASK_SCENARIO}}

{{TASK_ACCEPTANCE_TESTS}}

{{TASK_SOURCES}}
```

### 5.1.2 — Present to user

Show:

```
El body del template quedó así:
[rendered preview above]

¿Confirmas que este contenido es correcto? (si/no)
```

### 5.1.3 — Handle response

- If user responds **"si"**: proceed to STEP 6 (write file).
- If user responds **"no"**: abort with message `Generación cancelada por el usuario.` Do NOT write any file.
- For any other response: repeat the question.

---

## STEP 6 — Write file

```bash
mv generated.md "$TARGET"
```

---

# Principles

- Template based
- Git friendly
- Declarative Jira artifacts
- No Jira mutation
- Unique filenames
- Safe generation
