---
description: Crea issues epic y/o task en Jira desde un archivo Markdown estructurado
---

1. Load skill: markdown-to-jira
2. Usa `{{args}}` como path del archivo Markdown fuente.
3. Lee el archivo y valida cada bloque `Epic` y/o `Task` segun su tipo. Cada bloque debe tener `Issue Metadata`, `Scenario`, `Acceptance Tests` y `Sources`, mas los metadatos requeridos para ese tipo.
4. Si existe un bloque `Epic`, crealo primero en Jira usando los campos del bloque.
5. Crea las `Task` despues:
   - si existe un `Epic` en el documento, usa el key real del epic como `parent`
   - si no existe un `Epic`, crea solo las `Task` validas con la metadata disponible
6. Completa `labels` y `components` con `jira_editJiraIssue`.
7. Actualiza siempre el archivo Markdown con `issueKey` y `parentEpic` reales cuando corresponda.
8. Devuelve un resumen con los issue keys creados o actualizados.