---
name: jira-sync-components
description: Skill para sincronizar componentes de Jira con un archivo markdown. Crea, actualiza y reconcilia componentes (incluyendo description).
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
  opencode:
    emoji: "🔄"
    tags:
      - jira-cloud
      - components
      - sync
    mcp:
      preferredServer: jira
---

# Jira Sync Components

Sincroniza componentes de un archivo markdown con los componentes de Jira, incluyendo creación, actualización y reconciliación de descripciones.

El archivo markdown es el **source of truth**.

---

## Uso de argumentos

Este skill recibe argumentos mediante `{{args}}`.

Formatos soportados:

### 1. String (recomendado para CLI)

```bash
jira-sync-components ./docs/jira/components.md
```

### 2. JSON

```json
{
  "filePath": "./docs/jira/components.md"
}
```

### Resolución de `filePath`

- Si `{{args}}` es string → usar como `filePath`
- Si `{{args}}` es objeto → usar `args.filePath`
- Si no existe → error

---

## Estructura del archivo markdown

```markdown
## ComponentName
- projectKey: HAD
- name: ComponentName
- jiraId: 12345
- description: Description of the component
```

---

## Parámetros

- `filePath` (string, requerido):
  Ruta absoluta o relativa al archivo markdown de componentes.

---

## Overview

1. Resolver `filePath` desde `{{args}}`.
2. Validar acceso al archivo.
3. Leer el archivo markdown.
4. Obtener los componentes actuales de Jira.
5. Comparar estados (archivo vs Jira).
6. Ejecutar reconciliación:
   - Crear
   - Actualizar (incluyendo description)
   - Agregar desde Jira
7. Escribir el archivo actualizado.

---

## Implementación esperada

### Validación inicial

- Resolver `filePath` desde `{{args}}`.
- Verificar que `filePath` esté definido.
- Verificar que el archivo exista.
- Verificar permisos de lectura/escritura.
- Fallar inmediatamente si alguna validación no se cumple.

---

### Lectura y parsing

- Leer el archivo markdown desde `filePath`.
- Parsear todos los componentes.
- Validar que todos tengan el mismo `projectKey`.

---

### Obtener estado actual

- Obtener componentes de Jira usando:
  - `jira_list_components`

---

### Construcción de estructuras

- Crear mapas:
  - `fileComponentsById`
  - `fileComponentsByName`
  - `jiraComponentsById`
  - `jiraComponentsByName`

---

## Reglas de sincronización

### 1. Crear (Markdown → Jira)

- Componentes en archivo sin `jiraId`.

Acción:

- Ejecutar `jira_create_component` con:
  - name
  - description
  - projectKey

- Actualizar el archivo con el `jiraId` retornado.

---

### 2. Actualizar (Markdown → Jira)

- Componentes con `jiraId` que existen en Jira.

Comparar:

- `name`
- `description`

Si hay diferencias:

- Ejecutar `jira_update_component`
- Alinear Jira con el markdown

---

### 3. Agregar (Jira → Markdown)

- Componentes en Jira que no existen en el archivo.

Acción:

- Agregar al final del archivo markdown
- Incluir:
  - projectKey
  - name
  - jiraId
  - description (desde Jira)

---

### 4. Validar integridad

- Si un `jiraId` del archivo no existe en Jira:
  - Marcar como inconsistencia
  - No eliminar automáticamente
  - Registrar warning

---

## Escritura del archivo

- Mantener el orden original del archivo.
- Insertar nuevos componentes al final.
- Actualizar `jiraId` generados.
- Preservar formato markdown.

---

## Reglas de comportamiento

- `filePath` es obligatorio.
- No usar rutas por defecto.
- No inferir ubicación del archivo.
- Fallar si el archivo no existe.
- El markdown es el **source of truth**.
- No eliminar componentes automáticamente en Jira.
- Solo sincronizar:
  - name
  - description
- Evitar updates innecesarios (comparación previa).
- Normalizar strings (trim recomendado).
- La resolución del servidor MCP de Jira debe delegarse al runtime.
- No asumir instancias, tenants o configuraciones específicas.

---

## Logging esperado

El agente debe registrar acciones con claridad:

- CREATED: componente creado en Jira
- UPDATED: componente actualizado en Jira
- SYNCED: componente sin cambios
- ADDED_FROM_JIRA: agregado al archivo
- INCONSISTENT: jiraId inválido

---

## Tu humano puede pedirte

- "Usa el skill `jira-sync-components` con este archivo"
- "Sincroniza los componentes de este markdown con Jira"
- "Crea los componentes que faltan en Jira desde este archivo"
- "Actualiza las descripciones de los componentes en Jira usando este markdown"
- "Trae los componentes de Jira que no están en el archivo"
- "Mantén en sync este archivo de componentes con Jira"

---

## Cómo debes interpretar estas solicitudes

- Resolver siempre `filePath` desde `{{args}}`.
- Si el usuario no proporciona argumentos:
  - Solicitar `filePath`
  - No ejecutar
- Todas las solicitudes implican:
  - Sincronización completa (no parcial)

---

## Ejemplo de uso

### CLI

```bash
jira-sync-components ./docs/jira/components.md
```

### JSON

```json
{
  "filePath": "./docs/jira/components.md"
}
```

---

## Resultado esperado

- Jira alineado con el archivo markdown.
- Archivo markdown actualizado con:
  - nuevos `jiraId`
  - componentes faltantes de Jira