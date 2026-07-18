---
name: jpd-task-generator
description: Generar artefactos Task en 10-Projects/{PROJECT}/jira/{jpd_issue_key}/draft/ desde contexto natural, usando template TASK.md.tpl con substitución {{VAR}}.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.1.0"
  opencode:
    emoji: 🧩
    triggers:
      - "generar task desde jpd"
      - "jpd task"
      - "task spec"
      - "crear task jpd"
    tags:
      - jira-product-discovery
      - task
      - spec
      - generator
    mcp:
      preferredServer: [jira, filesystem]
---

# jpd-task-generator

Skill para generar documentos Jira Task declarativos desde contexto natural, usando el template local `TASK.md.tpl` con substitución de variables simple (`{{VAR}}`). Los artefactos se escriben en `10-Projects/{PROJECT}/jira/{jpd_issue_key}/draft/`, consistentes con `jpd-epic-generator`.

---

## Overview

```
[Contexto del usuario]
  → [STEP 1] Clasificar input (unstructured / pre-structured / raw-body)
  → [STEP 2] Transformar a campos estructurados
  → [STEP 3] Resolver PROJECT_KEY + JPD_ISSUE_KEY
  → [STEP 4] Generar slug + shortuuid
  → [STEP 5] Renderizar Task via string replacement + TASK.md.tpl
  → [STEP 6] Escribir archivo en draft/
```

---

## Input

El contexto descriptivo se recibe mediante `{{args}}`.

### Formato string (recomendado)

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

## Output

```
10-Projects/{PROJECT}/jira/{jpd_issue_key}/draft/
└── task-{slug}-{shortuuid}.md
```

---

## Flow

### STEP 0 — Ensure directory

```bash
mkdir -p "10-Projects/${PROJECT}/jira/${JPD_ISSUE_KEY}/draft"
```

---

### STEP 1 — Classify Input Structure

Before transforming, classify the collected input into one of three modes. Apply these rules in order:

#### 1. `--body--` delimiter check

If the input contains `--body--` on its own line (exact match, not part of a longer line):
→ classify as `raw-body`. Skip all further heuristic checks.

#### 2. Pre-structured heuristics

Count how many of the following heuristics match the input:

| # | Heuristic | Detects |
|---|---|---|
| H1 | Markdown table rows: ≥2 lines matching `\|.*\|.*\|` | Tables with aligned columns |
| H2 | Numbered criteria: lines starting with `N. ` (e.g. `1. `) followed by action verbs (implementar, agregar, crear, reemplazar, añadir) | Acceptance criteria lists |
| H3 | File paths: references to files with code extensions (`.ts`, `.md`, `.py`, `.sh`, `.json`, `.yaml`, `.yml`) | Source file references |
| H4 | Section headings: lines matching `## Scenario`, `### Acceptance Tests`, or `### Sources` | Content already aligned with template |

#### 3. Threshold

- **≥2 heuristics match** → classify as `pre-structured`
- **<2 heuristics match** → classify as `unstructured`

#### Mode summary

| Mode | Behavior |
|---|---|
| `unstructured` | Full STEP 2 transformation (existing path — no changes) |
| `pre-structured` | Skip STEP 2 body field transformation; inject content literally into template body |
| `raw-body` | Split at `--body--` delimiter; metadata from pre-delimiter, body from post-delimiter |

---

### STEP 2 — Transform to Fields (unstructured mode only)

**Applies ONLY when input is `unstructured`.** If `pre-structured` or `raw-body`, skip this entire step for body fields.

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

#### STEP 2 gating — behavior by mode

| Mode | STEP 2 body fields | Metadata extraction |
|---|---|---|
| `unstructured` | Full transformation (existing path) | Title + summary + scenario + tests + sources |
| `pre-structured` | **Skip entirely** — inject input literally into `{{TASK_SCENARIO}}`, `{{TASK_ACCEPTANCE_TESTS}}`, `{{TASK_SOURCES}}` | Extract title from first meaningful line of input, or prompt user if unclear |
| `raw-body` | **Skip body transformation** — post-delimiter content is the body | Extract title + summary from pre-delimiter content via STEP 2 rules (metadata only) |

---

### STEP 2.3 — Handle `--body--` Raw Mode

**Applies ONLY when input is classified as `raw-body`.** For other modes, skip this step.

#### 2.3.1 — Split at delimiter

Find the first line that is exactly `--body--` (standalone, no leading/trailing characters). Split the input into two parts:

- **Pre-delimiter**: everything before `--body--`
- **Post-delimiter**: everything after `--body--`

#### 2.3.2 — Metadata extraction (pre-delimiter)

Process pre-delimiter content through STEP 2 rules to extract `title` and `summary` only. Do NOT attempt to extract body fields (scenario, acceptance_tests, sources) from pre-delimiter content.

#### 2.3.3 — Edge case: no pre-delimiter content

If pre-delimiter content is empty or whitespace-only:

```
No se detectó título. Ingresa un título para la task:
```

Wait for user response before proceeding.

#### 2.3.4 — Body assignment

Post-delimiter content becomes the literal body:

- `{{TASK_SCENARIO}}` ← post-delimiter content
- `{{TASK_ACCEPTANCE_TESTS}}` ← post-delimiter content (same)
- `{{TASK_SOURCES}}` ← post-delimiter content (same)

The content is injected verbatim — no parsing, restructuring, or rewording.

---

### STEP 3 — Resolver PROJECT_KEY + JPD_ISSUE_KEY

#### 3.1 — Resolver PROJECT_KEY

Usar `getVisibleJiraProjects` del MCP de Jira.

1. Obtener el cloudId vía `getAccessibleAtlassianResources`
2. Llamar `getVisibleJiraProjects(cloudId)`
3. Filtrar projects que tengan `"Task"` en `issueTypes[].name`
4. Si hay exactamente uno → usar su `key` como PROJECT_KEY
5. Si hay múltiples → preguntar al usuario cuál usar (mostrar lista con keys y names)
6. Si hay cero → error: no hay proyectos Jira con issue type Task disponible

> ⚠️ No leer PROJECT_KEY de `codi.toml`. La fuente de verdad es Jira.

#### 3.2 — Resolver JPD_ISSUE_KEY

Preguntar al usuario:

```
¿Esta task pertenece a una idea de Jira Product Discovery? (si/no)
```

- Si **sí**: solicitar `Ingresa el JPD issue key (ej. NIP-25):` y validar formato `{PROJECT_KEY}-{number}`.
- Si **no**: continuar sin `jpd_issue_key`. El archivo se escribirá en `10-Projects/{PROJECT}/jira/standalone/draft/`.

---

### STEP 4 — Infer component from context

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

---

### STEP 5 — Resolve git remote URL

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

### STEP 6 — Generate slug

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

### STEP 7 — Generate shortuuid

```bash
ID=$(codi util short-uuid)
```

Ejemplo: `v7Kp9x`

---

### STEP 8 — Renderizar Task via string replacement

Usar el template `TASK.md.tpl` con substitución de variables simple (`{{VAR}}` — no gomplate):

1. Leer `TASK.md.tpl` del directorio del skill.
2. Construir el context de substitución:

   | Variable | Fuente |
   |---|---|
   | `{{TASK_TITLE}}` | title de la task |
   | `{{PROJECT_KEY}}` | del proyecto Jira |
   | `{{TASK_SUMMARY}}` | summary de la task |
   | `{{COMPONENT}}` | inferido en STEP 4 |
   | `{{LABELS}}` | labels de la task |
    | `{{PARENT_EPIC}}` | summary del Epic (máx. 120 chars, verbo de acción) |
   | `{{JPD_ISSUE_KEY}}` | JPD issue key |
   | `{{TASK_SCENARIO}}` | scenario de la task |
   | `{{TASK_ACCEPTANCE_TESTS}}` | acceptance_tests de la task |
   | `{{TASK_SOURCES}}` | sources de la task |
   | `{{GIT_REPO_URL}}` | remote origin URL |

3. Para cada variable en el template, substituir con el valor correspondiente.
4. El resultado es el contenido completo del archivo listo para escribir.

> Los templates usan `{{VAR}}` (sin punto, sin espacio). Es substitución literal de string, NO gomplate.

### STEP 9 — Resolve filename

```bash
TARGET="10-Projects/${PROJECT}/jira/${JPD_ISSUE_KEY}/draft/task-${SLUG}-${ID}.md"
```

Si no hay `jpd_issue_key`:

```bash
TARGET="10-Projects/${PROJECT}/jira/standalone/draft/task-${SLUG}-${ID}.md"
```

Validar:

```bash
if [ -f "$TARGET" ]; then
  ID=$(codi util short-uuid)
  TARGET="10-Projects/${PROJECT}/jira/${JPD_ISSUE_KEY}/draft/task-${SLUG}-${ID}.md"
fi
```

---

### STEP 10.1 — Validate body content (pre-structured and raw-body only)

**Applies ONLY when input is `pre-structured` or `raw-body`.** For `unstructured` mode, skip this step entirely and proceed directly to STEP 11.

#### 10.1.1 — Render preview

Render the body fields as they would appear in the final file:

```
{{TASK_SCENARIO}}

{{TASK_ACCEPTANCE_TESTS}}

{{TASK_SOURCES}}
```

#### 10.1.2 — Present to user

Show:

```
El body del template quedó así:
[rendered preview above]

¿Confirmas que este contenido es correcto? (si/no)
```

#### 10.1.3 — Handle response

- If user responds **"si"**: proceed to STEP 11 (write file).
- If user responds **"no"**: abort with message `Generación cancelada por el usuario.` Do NOT write any file.
- For any other response: repeat the question.

---

### STEP 11 — Write file

El archivo ya fue escrito usando string replacement. Verificar que existe:

```bash
ls -la "$TARGET"
```

---

## Reglas

- No crear issues en Jira — solo generar artefactos markdown compatibles con `markdown-to-jira`.
- El template `TASK.md.tpl` se lee de `<skill_root>/`. Si falta, error: "Template faltante en el skill. Reinstala jpd-task-generator."
- Si ya existe un archivo con el mismo slug, regenerar shortuuid hasta que sea único.
- Si no se proporciona `jpd_issue_key`, escribir en `10-Projects/{PROJECT}/jira/standalone/draft/`.

---

## Dependencias

- **Upstream**: `jpd-epic-generator` — genera Epic con tasks inline; este skill genera tasks standalone
- **Downstream**: `markdown-to-jira` — consume los artefactos de `draft/` para crear issues en Jira Software
- **Template**: `<skill_root>/TASK.md.tpl`
- **Requiere**: `codi util short-uuid` para generar IDs únicos
