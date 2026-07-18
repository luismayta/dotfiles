---
name: markdown-to-jira
description: Skill para crear issues de tipo epic y/o task en Jira Cloud a partir de un archivo Markdown, luego completar componentes, labels, issue keys, y opcionalmente establecer link de trazabilidad hacia Jira Product Discovery.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.5.0"
  opencode:
    emoji: 🧩
    tags:
      - jira-cloud
      - markdown
      - mcp
      - workflow
    mcp:
      preferredServer: jira
---

# Markdown to Jira

Usa este skill cuando tengas un archivo Markdown con bloques de `Epic` y/o `Task` y quieras crear esas issues en Jira Cloud usando MCP.

## Objetivo

Convertir un archivo Markdown estructurado en:

- un Epic en Jira cuando exista un bloque `Epic`
- una o varias Task en Jira cuando existan bloques `Task`
- labels y components aplicados despues de la creacion
- issue keys y parentEpic reales escritos de vuelta en el documento

## Formato esperado del Markdown

Cada bloque debe incluir:

- encabezado `# Epic:` o `# Task:`
- seccion `## Issue Metadata`
- `## Scenario`
- `### Acceptance Tests`
- `### Sources:`

Opcional:
- `### Context Queries`: seccion cuyo texto se appende al description solo cuando existe en el markdown

### Metadatos requeridos por tipo de bloque

Para cualquier bloque:

- `projectKey`
- `issueType`
- `summary`
- `description` (extraido de Scenario + Acceptance Tests + Sources)
- `component`
- `labels`

Solo para bloques `Task`:

- `parentEpic` cuando la task deba quedar vinculada a un epic

Solo para bloques `Epic` (opcional):
- `jpdSource`: issue key de la idea JPD de origen (ej. NIP-25). Si está presente, después de crear el Epic se establecerá un link de trazabilidad via `Polaris work item link`.

Notas:

- Un documento puede tener solo bloques `Task`.
- Un documento puede tener un bloque `Epic` y uno o mas bloques `Task`.
- Si existe `Epic` y `Task`, el orden de creacion debe ser `Epic` y luego `Task`.

## Flujo operativo

1. Leer el archivo Markdown indicado por el usuario.
2. Identificar si hay bloques `Epic`, bloques `Task` o ambos.
3. Validar cada bloque segun su tipo:
   - `Epic`: debe incluir `Issue Metadata`, `Scenario`, `Acceptance Tests` y `Sources`, con sus metadatos requeridos.
   - `Task`: debe incluir `Issue Metadata`, `Scenario`, `Acceptance Tests` y `Sources`, con sus metadatos requeridos.
4. **Extraer contenido para description**: Para cada bloque, extraer las secciones:
   - `## Scenario`: texto principal del escenario
   - `### Acceptance Tests`: lista de tests
   - `### Sources`: links o referencias
   - `### Context Queries`: texto opcional (solo si existe en el bloque)
     - Formato: cada linea `mcp <source>: <query>` se preserva como texto raw
     - Si la seccion NO existe → no appendear nada (comportamiento original)
     - Si la seccion SI existe → appendear el texto bajo ese heading al description
   Combinar en un description string: Scenario + Acceptance Tests + Sources [+ Context Queries]
5. Si existe un bloque `Epic`, crearlo primero con Jira MCP, incluyendo el `description` del paso 4.
5.5. Si el bloque `Epic` tiene `jpdSource` en su metadata, establecer link de trazabilidad:
   a. Verificar el estado del parámetro `jpdSource` extraido del markdown.
    b. Llamar `jira_createIssueLink` con:
       - outwardIssue: valor de `jpdSource` (la JPD Idea, ej. NIP-25)
       - inwardIssue: key real del Epic creado (ej. PE-201)
       - type: "Polaris work item link"
       - **Razon**: El link type `Polaris work item link` tiene semantica outward="implements", inward="is implemented by". JPD espera la Idea en el lado outward ("implements") y el Software issue en el lado inward ("is implemented by") para que aparezca en la seccion Delivery de JPD.
   c. Si el link ya existe (error de duplicado), omitir silenciosamente.
   d. Si la JPD idea no existe o el link falla, informar al usuario pero NO bloquear el resto del flujo.
6. Guardar el `issueKey` real del epic si fue creado.
7. Crear cada `Task`:
   - incluyendo el `description` del paso 4
   - si el documento tambien define un `Epic`, usar el key real del epic creado como `parent`
   - si el documento no define un `Epic`, usar el `parentEpic` del Markdown solo si viene informado
8. Ejecutar `jira_editJiraIssue` para aplicar:
   - `labels`
   - `components`
9. Actualizar siempre el Markdown con:
   - `issueKey` del epic
   - `issueKey` de cada task
   - `parentEpic` con el key real cuando corresponda

## Reglas de comportamiento

- No inventes `projectKey`, `component` ni `labels`.
- Usa exactamente los valores escritos en el Markdown.
- **Extraccion de description**: Para cada bloque, construye el description concatenando:
  1. `## Scenario` (todo el texto bajo este heading)
  2. `### Acceptance Tests` (items de la lista)
  3. `### Sources` (links o texto bajo este heading)
  4. `### Context Queries` (texto opcional bajo este heading, solo si existe)
     - El texto se appende tal cual, preservando lineas `mcp <source>: <query>` como raw text
     - Si la seccion NO existe en el markdown, no appendear nada
  El resultado se pasa en el campo `description` de `jira_createJiraIssue`.
- Valida los metadatos requeridos segun el tipo de bloque antes de crear issues.
- Si el documento tiene `Epic` y `Task`, crea primero el `Epic` y luego las `Task`.
- Si el documento tiene solo `Task`, no exijas un bloque `Epic`.
- Si una `Task` referencia un `parentEpic` nominal y el documento incluye un `Epic`, sustituyelo por el key real del epic creado.
- Si Jira acepta la creacion pero deja vacios `components` o `labels`, completa esos campos con `jira_editJiraIssue`.
- Despues de crear las issues, actualiza siempre el Markdown con los `issueKey` y `parentEpic` reales que correspondan.
- Si el Markdown ya contiene `issueKey`, no recrees la issue sin confirmacion explicita del usuario.
- Si el archivo no tiene estructura valida, detente y explica que falta.
- `jpdSource` es un campo opcional en bloques `Epic`. Si no está presente, no se ejecuta linking.
- Si `jpdSource` está presente pero el link falla (idea JPD inexistente, permiso denegado), informar al usuario y continuar — no bloquear la creación del Epic ni de las Tasks.
- El link se crea con tipo `Polaris work item link` (id: 10037), semántica `implements` / `is implemented by`.
- No modificar el `jpdSource` en el markdown — se preserva como metadata local de trazabilidad.

## Payload de actualizacion validado

```json
{
  "fields": {
    "labels": ["ai-enablement"],
    "components": [{ "name": "I+D" }]
  }
}
```

## Tu humano puede pedirte

- "Usa el skill `markdown-to-jira` con este archivo"
- "Crea en Jira las issues descritas en este markdown"
- "Sincroniza este backlog markdown con Jira y actualiza los issue keys"

## STEP 10 — Move to archived

Después de crear las issues en Jira y actualizar el markdown con los issue keys:

```bash
ARCHIVED_DIR="$(dirname "$INPUT_FILE")/../archived"
mkdir -p "$ARCHIVED_DIR"
mv "$INPUT_FILE" "$ARCHIVED_DIR/"
```

Informar al usuario:
```
✅ Archivo movido a: {ARCHIVED_DIR}/{filename}
```
