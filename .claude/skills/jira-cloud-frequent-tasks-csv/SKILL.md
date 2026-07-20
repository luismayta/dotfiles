---
name: jira-cloud-frequent-tasks-csv
description: Skill para consultar Jira Cloud mediante MCP y generar un archivo CSV con las tareas más frecuentes de un proyecto dado, sin filtrar por estado.
license: Proprietary
metadata:
  opencode:
    emoji: 📊
    tags:
      - jira-cloud
      - sre
      - reporting
      - csv
    mcp:
      preferredServer: atlassian-mcp-server
---

# Jira Cloud Frequent Tasks CSV

Usa este skill cuando quieras analizar las tareas más frecuentes de un proyecto de Jira Cloud y generar un archivo CSV con los resultados (para usarlo luego en Excel, BI, etc.). Este skill se apoya en el MCP de Jira (por ejemplo `atlassian-mcp-server` o un servidor `mcp-jira`) para ejecutar consultas JQL y obtener los issues del proyecto.[web:43][web:50][web:56][web:64]

## Alcance y comportamiento esperado

Cuando el humano pida usar este skill, debes:

1. Preguntar por:
   - Clave del proyecto (por ejemplo `SRE`, `OPS`, `PROJ`).
   - Ventana de tiempo relevante (por ejemplo, últimos 30/90 días).
   - Qué significa "tareas más frecuentes" en este contexto:
     - Tipos de issue más frecuentes (Bug, Task, Story).
     - Componentes más usados.
     - Etiquetas (labels) más repetidas.
2. Construir una consulta JQL para ese proyecto y ventana de tiempo **sin filtrar por estado**, por ejemplo: `project = PROJ AND created >= -30d ORDER BY created DESC`.
3. Llamar al MCP de Jira usando la tool de búsqueda (por ejemplo `jira_search` o la equivalente) para recuperar todas las issues relevantes del proyecto, independientemente de su estado.[web:43][web:64]
4. A partir de los datos devueltos, agrupar y contar las tareas por el criterio elegido (tipo, componente, etiqueta, etc.).
5. Generar un contenido CSV en texto con columnas claras, por ejemplo:
   - `task_key` (clave o nombre del "bucket" de tarea, p.ej. label o componente).
   - `count` (número de issues).
   - `sample_issues` (lista corta de claves de issues de ejemplo).
   - `project_key`.
   - `window` (rango de fechas usado).

6. Devolver el CSV en la respuesta, marcado explícitamente como bloque de código con tipo `csv`, para que el entorno lo pueda guardar fácilmente como archivo.

## Detalles de implementación esperada (para el agente)

- Usa la herramienta de búsqueda del MCP de Jira con JQL apropiado, siempre **sin condición de estado** (no uses `status = ...`)
- Extrae de cada issue campos como:
  - `key`
  - `issuetype.name`
  - `fields.labels`
  - `components`
  - `summary` (opcional, para ejemplos).
- El criterio “tareas más frecuentes” por defecto (si el humano no especifica) debe ser:
  - Agrupar por `issuetype.name` y contar issues por tipo.
- Si el humano pide otro criterio (por ejemplo por etiqueta o componente), adáptalo:
  - Agrupa por label o por nombre de componente.
- Ordena el resultado en el CSV de mayor a menor frecuencia.

## Formato de salida CSV

Cuando generes el CSV, usa el siguiente esquema:

```csv
project_key,window,task_key,metric,count,sample_issues
PROJ,last_30d,Bug,issue_type,123,"PROJ-1;PROJ-7;PROJ-42"
PROJ,last_30d,Task,issue_type,87,"PROJ-3;PROJ-11;PROJ-99"
```

O, para labels:

```csv
project_key,window,task_key,metric,count,sample_issues
PROJ,last_30d,infra,issue_label,45,"PROJ-10;PROJ-12;PROJ-18"
PROJ,last_30d,incident,issue_label,32,"PROJ-2;PROJ-8;PROJ-21"
```

Devuelve siempre el CSV dentro de:

```csv
...contenido...
```

## Tu humano puede pedirte

- "Usa el skill `jira-cloud-frequent-tasks-csv` para sacar un CSV con las tareas más frecuentes del proyecto SRE en los últimos 30 días, sin importar el estado."
- "Genera un CSV de las etiquetas más usadas en el proyecto OPS en los últimos 90 días."
- "Dame un CSV con los tipos de issue más frecuentes en el proyecto PROJ para este trimestre."
