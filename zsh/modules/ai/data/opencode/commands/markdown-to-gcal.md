---
description: Crea o sincroniza eventos en Google Calendar desde un archivo Markdown estructurado
---

1. Load skill: markdown-to-gcal
2. Usa `{{args}}` como path del archivo Markdown fuente.
3. Pasa el archivo completo al skill `markdown-to-gcal` sin transformar su contenido.
4. Delega toda la lógica al skill, incluyendo:
   - parsing del Markdown
   - validación de metadata
   - normalización de fechas
   - lógica idempotente (create vs update usando `id`)
   - validación del `id` mediante MCP
   - persistencia del `id` en el archivo
5. Devuelve el resultado generado por el skill, incluyendo el resumen de eventos creados o actualizados.

(End of file - total 15 lines)