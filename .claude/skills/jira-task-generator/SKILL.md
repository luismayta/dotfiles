---
name: jira-task-generator
description: Generate Jira Task definitions from context using templates. Creates markdown artifacts under .codi/jira/issues/ with unique identifiers.
license: Proprietary
triggers:
  - "create task"
  - "generate task"
  - "jira task"
  - "crear task"
  - "generar task"
metadata:
  author: "codiplab"
  version: "0.4.1"
  opencode:
    emoji: "🧩"
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

Texto libre.

Ejemplo:

```
crear task para implementar autenticación OAuth

criterios:
- implementar login con Google
- agregar tests unitarios
```

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

## STEP 1 — Parse context

Extraer:

```yaml
task:
  title:
  summary:
  scenario:
  acceptance_tests:
  sources:
```

Ejemplo:

Input:

```
crear task para implementar autenticación OAuth

criterios:
- implementar login con Google
- agregar tests
```

Resultado:

```yaml
task:
  title: Implementar autenticación OAuth
  summary: Implementar autenticación OAuth
  acceptance_tests:
    - implementar login con Google
    - agregar tests
```

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
ID=$(codi util short-uuid --length 6)
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
  ID=$(codi util short-uuid --length 6)
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
