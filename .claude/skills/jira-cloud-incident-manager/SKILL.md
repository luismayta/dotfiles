---
name: jira-cloud-incident-manager
description: Skill para gestionar incidentes en Jira Cloud usando el MCP de Atlassian (crear, buscar y actualizar issues).
license: Proprietary
metadata:
  opencode:
    emoji: 🚨
    tags:
      - jira-cloud
      - incident-management
    mcp:
      preferredServer: atlassian-mcp-server
---

# Jira Cloud Incident Manager

Usa este skill cuando necesites gestionar incidentes en **Jira Cloud** desde el agente. Este skill asume que el servidor MCP de Atlassian (Jira Cloud) ya está configurado y autenticado mediante OAuth en tu organización.

## Cómo usar este skill

1. Cuando detectes un problema de producción que impacta a usuarios o SLOs, crea un incidente en Jira Cloud usando las herramientas del MCP (por ejemplo, `createIssue` o la tool equivalente expuesta por tu MCP).
2. Incluye en el ticket: servicio afectado, impacto, síntomas, timeline inicial y owner SRE.
3. Mientras el incidente está activo, usa tools como `getIssuesByJQL`, `getIssue`, `addComment` y `transitionIssue` (según las tools que exponga tu MCP) para:
   - Ver estado actual.
   - Añadir actualizaciones en el timeline.
   - Cambiar el estado (p.ej. `Investigating`, `Mitigated`, `Resolved`).
4. Al cerrar el incidente, añade un comentario con resumen, causa raíz y acciones de follow-up, y marca el ticket como resuelto.

## Tu humano puede pedirte

- "Usa el skill `jira-cloud-incident-manager` para crear un incidente en Jira Cloud para este problema."
- "Actualiza el incidente de Jira Cloud con este nuevo timeline y marca el estado como 'Mitigated'."
- "Busca incidentes abiertos de severidad alta en Jira Cloud y dame un resumen."
- "Añade un comentario al ticket JIRA-1234 con la causa raíz provisional."
