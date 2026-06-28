---
name: jira-epic-generator
description: Generate Jira Epic and Task definitions from context using templates. Creates markdown artifacts under .codi/jira/issues/ with unique identifiers.
license: Proprietary
triggers:
  - "create epic"
  - "generate epic"
  - "jira epic"
  - "crear epic"
  - "generar epic"
metadata:
  author: "codiplab"
  version: "0.4.1"
  opencode:
    emoji: "🧩"
    tags:
      - jira
      - epic
      - task
      - planning
      - generator
      - template
      - idempotent
---

# jira-epic-generator

Skill para generar documentos Jira declarativos desde contexto natural.

Genera un archivo Markdown conteniendo:

- Un Epic
- Sus Tasks relacionadas

El resultado queda almacenado en:

```
.codi/jira/issues/
```

Ejemplo:

```
.codi/jira/issues/epic-migrate-to-rust-v7Kp9x.md
```

---

# Purpose

- Convertir contexto en una definición Jira estructurada.
- Generar Epics con Tasks asociadas.
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
crear un epic para migrar a rust

tareas:

- crear repositorio
- implementar test automation
- crear un mcp con rust
```

---

# Skill Assets

```
<skill-root>/
├── EPIC.md.tpl
└── TASK.md.tpl
```

---

# Output

Genera:

```
.codi/jira/issues/
epic-{slug}-{shortuuid}.md
```

Ejemplo:

```
.codi/jira/issues/epic-migrate-to-rust-v7Kp9x.md
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
epic:
  title:
  summary:
  scenario:

tasks:
  - title:
    summary:
    scenario:
```

Ejemplo:

Input:

```
crear epic migrar a rust

tasks:
- crear repositorio
- crear mcp rust
```

Resultado:

```yaml
epic:
  title: Migrate to Rust

tasks:
  - Crear repositorio
  - Crear MCP Rust
```

---

## STEP 1.5 — Resolve PROJECT_KEY

Usar `getVisibleJiraProjects` del MCP de Jira.

1. Obtener el cloudId vía `getAccessibleAtlassianResources`
2. Llamar `getVisibleJiraProjects(cloudId)`
3. Filtrar projects que tengan `"Epic"` en `issueTypes[].name`
4. Si hay exactamente uno → usar su `key` como PROJECT_KEY
5. Si hay múltiples → preguntar al usuario cuál usar (mostrar lista con keys y names)
6. Si hay cero → error: no hay proyectos Jira con issue type Epic disponible

> ⚠️ No leer PROJECT_KEY de `codi.toml`. La fuente de verdad es Jira.

---

## STEP 2 — Generate slug

Convertir:

```
Migrate to Rust
```

a:

```
migrate-to-rust
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
TARGET=".codi/jira/issues/epic-${SLUG}-${ID}.md"
```

Ejemplo:

```
.codi/jira/issues/epic-migrate-to-rust-v7Kp9x.md
```

Validar:

```bash
if [ -f "$TARGET" ]; then
  ID=$(codi util short-uuid --length 6)
  TARGET=".codi/jira/issues/epic-${SLUG}-${ID}.md"
fi
```

---

## STEP 5 — Render Epic

Usar:

```
EPIC.md.tpl
```

Variables:

```
{{EPIC_TITLE}}
{{PROJECT_KEY}}
{{SUMMARY}}
{{COMPONENT}}
{{LABELS}}
{{ISSUE_KEY}}
{{SCENARIO}}
{{ACCEPTANCE_TESTS}}
{{SOURCES}}
{{TASKS}}
```

---

## STEP 6 — Render Tasks

Por cada task:

usar:

```
TASK.md.tpl
```

Variables:

```
{{TASK_TITLE}}
{{TASK_SUMMARY}}
{{TASK_SCENARIO}}
{{TASK_ACCEPTANCE_TESTS}}
{{TASK_SOURCES}}
```

---

## STEP 7 — Write file

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
