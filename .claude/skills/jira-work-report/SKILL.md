---
name: jira-work-report
description: Skill para generar un reporte de implementacion para el issue de Jira derivado del branch actual usando un template y un resumen basado en commits, y publicarlo como comentario.
license: Proprietary
triggers:
  - "Usa el skill `jira-work-report`"
  - "Genera un reporte de implementacion para la tarea Jira actual y publcalo como comentario"
  - "Completa el template de reporte Jira usando los commits del branch y subelo al issue"
metadata:
  author: "hadenlabs"
  version: "0.0.0"
  opencode:
    emoji: "📝"
    tags:
      - jira-cloud
      - git
      - issue-comment
      - reporting
      - branch
    mcp:
      preferredServer: jira
---

# Jira Work Report

Usa este skill cuando quieras dejar un comentario estructurado en Jira con el resumen de lo implementado sin redactarlo manualmente. El skill detecta si el proyecto usa Jira desde `jasper.toml`, obtiene el `projectKey`, deriva el issue key desde el branch actual, toma como base el template `.jira/issue_templates/jira-work-report.md`, resume los commits recientes del branch y publica el resultado como comentario en el issue derivado.

Importante: para publicar en Jira, usa las tools del servidor MCP `jira` disponibles en la sesion. No uses CLI (`jira ...`) ni scripts locales de otros skills.

## Overview

1. Lee `jasper.toml` y valida que `issueTracking.provider = "jira"`.
2. Obtiene `issueTracking.projectKey` y las reglas de `[issueTracking.branch]`.
3. Lee el branch actual y deriva el issue key de Jira usando el `projectKey` o el regex override configurado.
4. Lee el template `.jira/issue_templates/jira-work-report.md`.
5. Inspecciona los commits recientes del branch actual para construir un resumen fiel de lo implementado.
6. Completa el template con la informacion derivada de los commits y cualquier evidencia verificable disponible.
7. Publica el reporte como comentario en Jira sobre el issue derivado del branch usando MCP `jira`.

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
- Lee el template en `.jira/issue_templates/jira-work-report.md`. Si no existe, detente y explicalo.
- Obtiene el contexto de commits del branch actual usando git. Prioriza commits que aun no estan en la rama base o, si eso no puede resolverse de forma confiable, usa los commits mas recientes del branch actual.
- Construye el comentario final usando el template como estructura obligatoria.
- Completa `## Cambios Implementados` con un resumen claro y corto del resultado final y de los cambios principales entregados:
  - elimina ruido repetitivo como el prefijo del issue key cuando corresponda;
  - resume en 2-5 lineas o bullets breves lo realizado;
  - menciona el issue derivado si ayuda a dar contexto.
- Completa `## Tipo de Cambio` marcando solo la opcion que pueda inferirse con seguridad desde los commits o desde una instruccion explicita del usuario. Si no puede inferirse con seguridad, deja todas las opciones sin marcar en lugar de inventar.
- Completa `## Checklist de Implementacion` marcando solamente items respaldados por evidencia verificable, por ejemplo:
  - commits que indiquen claramente cambios de documentacion;
  - validaciones o pruebas ejecutadas en la sesion actual;
  - confirmaciones explicitas del usuario.
- No marques `lint`, `pruebas unitarias`, `pruebas de integracion` o `documentacion actualizada` si no hay evidencia suficiente.
- Completa `## Notas Tecnicas` con decisiones tecnicas relevantes inferibles de los commits. Si no hay informacion util, usa una nota breve y explicita como `No se identificaron notas tecnicas explicitas en los commits revisados.`
- Completa `## Referencias` reemplazando `{{merge_request}}` con una URL de Merge Request o Pull Request solo si puede resolverse de forma confiable; en caso contrario usa `No disponible`.
- Si no hay commits utiles para construir un reporte fiel, informalo y pide al usuario un resumen manual en lugar de inventarlo.
- Publica el comentario en Jira usando una tool del servidor MCP `jira` (no CLI ni scripts locales) con:
  - `issueIdOrKey = <ISSUE-KEY>`
  - `commentBody = <reporte final basado en template y commits>`

## Reglas de comportamiento

- No inventes si el proyecto usa Jira; siempre validalo desde `jasper.toml`.
- No inventes el `projectKey`; siempre leelo desde `jasper.toml`.
- No inventes el issue key; siempre derivalo desde el branch actual o pide aclaracion si falla.
- No inventes el contenido del reporte si no hay commits suficientes para resumirlo; en ese caso pide un resumen manual.
- No marques checks del template sin evidencia verificable.
- No inventes una URL de Merge Request o Pull Request; si no puede resolverse, usa `No disponible`.
- Si la working tree tiene cambios sin commit, puedes advertirlo, pero igual usa los commits existentes para el resumen.
- Muestra al final el issue comentado y el contenido final publicado o una vista previa clara del comentario.
- Usa exclusivamente el servidor MCP `jira` para la publicacion del comentario; no uses CLI ni scripts locales.

## Tu humano puede pedirte

- "Usa el skill `jira-work-report`"
- "Genera un reporte de implementacion para la tarea Jira actual y publcalo como comentario"
- "Completa el template de reporte Jira usando los commits del branch y subelo al issue"