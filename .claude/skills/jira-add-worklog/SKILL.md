---
name: jira-add-worklog
description: Skill para registrar worklogs en Jira usando el issue key derivado del branch actual y una descripcion basada en los commits del branch.
license: Proprietary
triggers:
  - "Usa el skill `jira-add-worklog`"
  - "Registra tiempo en Jira usando el issue del branch actual"
  - "Agrega un worklog a la tarea de Jira actual tomando la descripcion de los commits"
metadata:
  author: "hadenlabs"
  version: "0.0.0"
  opencode:
    emoji: "🧾"
    tags:
      - jira-cloud
      - git
      - worklog
      - branch
    mcp:
      preferredServer: jira
---

# Jira Add Worklog

Usa este skill cuando quieras registrar tiempo en Jira sin escribir manualmente el issue key. El skill detecta si el proyecto usa Jira desde `jasper.toml`, obtiene el `projectKey`, deriva el issue key desde el branch actual, pide al usuario una duracion en minutos u horas y agrega un worklog con una descripcion resumida a partir de los commits recientes del branch.

## Overview

1. Lee `jasper.toml` y valida que `issueTracking.provider = "jira"`.
2. Obtiene `issueTracking.projectKey` y las reglas de `[issueTracking.branch]`.
3. Lee el branch actual y deriva el issue key de Jira usando el `projectKey` o el regex override configurado.
4. Pide al usuario el tiempo a registrar en un formato valido de Jira, por ejemplo `30m`, `2h` o `1h 30m`.
5. Inspecciona los commits recientes del branch actual para construir una descripcion breve de lo realizado.
6. Registra el worklog en Jira sobre el issue derivado del branch.

Ejemplo de branch:

```text
feature/AR-3589
```

Ejemplo de issue derivado:

```text
AR-3589
```

## Implementacion esperada

- Lee `jasper.toml` antes de cualquier otra accion. Si `issueTracking.provider` no es `jira`, detente y explicalo.
- Si falta `issueTracking.projectKey`, detente y explicalo.
- Usa el branch actual con una forma equivalente a:

```bash
git rev-parse --abbrev-ref HEAD
```

- Deriva el issue key de Jira desde el branch actual:
  - si `[issueTracking.branch].jiraKeyRegexOverride` existe, usalo;
  - en caso contrario, cuando `jiraKeyFromProjectKey = true`, deriva un patron equivalente a `<PROJECTKEY>-<numero>` usando `issueTracking.projectKey`.
- Si no puedes derivar el issue key desde el branch actual, detente y pide al usuario un branch valido o el issue key exacto.
- Pide al usuario el tiempo a registrar si no fue provisto todavia. Acepta formatos compatibles con Jira como `15m`, `45m`, `2h`, `1h 30m`.
- Obtiene el contexto de commits del branch actual usando git. Prioriza commits que aun no estan en la rama base o, si eso no puede resolverse de forma confiable, usa los commits mas recientes del branch actual.
- Construye una descripcion corta y clara basada en los commits recientes:
  - elimina ruido repetitivo como el prefijo del issue key cuando corresponda;
  - resume en 1-3 lineas lo realizado;
  - si no hay commits utiles para resumir, informalo y pide una descripcion manual en lugar de inventarla.
- Registra el worklog en Jira usando la tool de worklog con:
  - `issueIdOrKey = <ISSUE-KEY>`
  - `timeSpent = <duracion ingresada>`
  - `commentBody = <descripcion construida desde commits o ingresada manualmente>`

## Reglas de comportamiento

- No inventes si el proyecto usa Jira; siempre validalo desde `jasper.toml`.
- No inventes el `projectKey`; siempre leelo desde `jasper.toml`.
- No inventes el issue key; siempre derivalo desde el branch actual o pide aclaracion si falla.
- No registres un worklog sin una duracion confirmada por el usuario.
- No inventes la descripcion del trabajo si no hay commits suficientes para resumirla; en ese caso pide una descripcion manual.
- Si la working tree tiene cambios sin commit, puedes advertirlo, pero igual usa los commits existentes para el resumen.
- Muestra al final el issue, la duracion registrada y la descripcion enviada a Jira.

## Tu humano puede pedirte

- "Usa el skill `jira-add-worklog`"
- "Registra tiempo en Jira usando el issue del branch actual"
- "Agrega un worklog a la tarea de Jira actual tomando la descripcion de los commits"