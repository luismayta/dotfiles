---
name: idea-jpd-create
description: Crear ideas en Jira Product Discovery desde drafts en jpd/validated/, moviendo el archivo a jpd/ideas/ con el jpd_issue_key.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.1.0"
  opencode:
    emoji: 💡
    triggers:
      - "crear idea jpd"
      - "jpd create"
      - "publicar idea"
      - "idea a jpd"
    tags:
      - jira-product-discovery
      - ideas
      - create
    mcp:
      preferredServer: [jira]
---

# idea-jpd-create

Skill para crear ideas en Jira Product Discovery (JPD) desde un draft en `jpd/{PROJECT}/validated/`. Lee el archivo, crea la idea en JPD, y mueve el archivo a `jpd/{PROJECT}/ideas/` con el `jpd_issue_key` en el frontmatter. El archivo movido se nombra con el formato `<jpd_issue_key>-<slug>.md` para facilitar la trazabilidad.

---

## Overview

```
jpd/{PROJECT}/validated/<slug>.md
  → Leer frontmatter + secciones
  → Crear idea en JPD (createJiraIssue)
  → Actualizar frontmatter: agregar jpd_issue_key + jpd_url
  → Mover a jpd/{PROJECT}/ideas/<jpd_issue_key>-<slug>.md
```

---

## Flujo de ejecución

### 1. Identificar el draft listo

1. Listar archivos en `10-Projects/**/jpd/validated/*.md`
2. Si no hay resultados: "No encontré drafts listos en `jpd/validated/`. Ejecuta `idea-jpd-draft` primero."
3. Mostrar drafts disponibles con su `title` del frontmatter
4. Preguntar al usuario cuál quiere crear en JPD

### 2. Leer el draft

1. Leer el archivo seleccionado
2. Extraer frontmatter y secciones
3. Derivar `{PROJECT}` del path: `10-Projects/{PROJECT}/jpd/validated/`

### 3. Determinar proyecto JPD

1. Preguntar al usuario por el project key de Jira Product Discovery
2. Si el usuario lo sabe → usar ese project key
3. Si no → llamar `getVisibleJiraProjects` para mostrar proyectos disponibles y pedir confirmación

> **Nota:** El `projectKey` de `codi.toml` es para Jira general, no para JPD. Jira Product Discovery usa un project key separado.

### 4. Resolver custom fields de JPD

Usar `getJiraIssueTypeMetaWithFields(projectIdOrKey=PROJECT_KEY, issueTypeId="Idea")` para descubrir los `customfield_*` IDs de Problem, Hypothesis, etc.

**Mapeo esperado:**

| Campo semántico | Campo Jira esperado |
|---|---|
| Problem | `customfield_<problem_id>` |
| Hypothesis | `customfield_<hypothesis_id>` |
| Tags | `labels` o `customfield_<tags_id>` |
| Type | `customfield_<type_id>` |

### 5. Crear idea en JPD

Usar `createJiraIssue` del MCP de Jira:

```
cloudId:       <del cloudId resuelto>
projectKey:    <PROJECT_KEY>
issueTypeName: "Idea"
summary:       <title del frontmatter>
description:   <Descripción + Insights + Valor>
```

Tomar los campos del draft:
- `title` → `summary`
- `Descripción` + `Insights` + `Valor` → `description`
- `Tareas potenciales` → pueden ir en description o como subtareas

### 6. Actualizar archivo y mover a ideas

```bash
mkdir -p "10-Projects/${PROJECT}/jpd/ideas"
```

Actualizar frontmatter del archivo:
- `status: ready` → `status: created`
- Agregar `jpd_issue_key: "<ID>"`
- Agregar `jpd_url: "<url>"`
- Agregar `created_at: "<YYYY-MM-DD HH:mm>"`

Mover:
```bash
mv "10-Projects/${PROJECT}/jpd/validated/<slug>.md" "10-Projects/${PROJECT}/jpd/ideas/<jpd_issue_key>-<slug>.md"
```

### 7. Retornar resultado

```
✅ Idea creada en Jira Product Discovery

ID:     <jpd_issue_key>
Título: <title>
URL:    <jpd_url>
Local:  10-Projects/${PROJECT}/jpd/ideas/<jpd_issue_key>-<slug>.md
```

---

## Reglas

- No inventar valores para campos que el draft no tenga
- Si `createJiraIssue` falla, mostrar el error y no mover el archivo
- Si el archivo ya existe en `jpd/ideas/`, preguntar si sobrescribir
- El `type` por defecto es `feature` si el draft no especifica uno
- La `jpd_url` se construye como: `https://<site>.atlassian.net/jira/software/c/projects/<PROJECT_KEY>/ideas/<ID>`
- El nombre del archivo en `jpd/ideas/` usa el formato `<jpd_issue_key>-<slug>.md` para facilitar la trazabilidad

---

## Dependencias

- **Upstream**: `idea-jpd-draft` — produce drafts en `jpd/{PROJECT}/validated/`
- **Requiere**: Atlassian MCP (`jira` server) para `createJiraIssue`, `getJiraIssueTypeMetaWithFields`, `getVisibleJiraProjects`