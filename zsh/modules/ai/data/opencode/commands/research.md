---
description: Investiga un tema usando MCP tools y genera un archivo de links curados en ./00-Inbox/<topic-slug>/links.md
---

1. Load skill: mcp-knowledge-orchestrator
2. Usa `$1` como el tema a investigar.
3. Si `$1` esta vacio, solicita el tema al usuario con: "Cual es el tema que deseas investigar?"
4. Ejecuta el skill con el tema proporcionado.
5. Devuelve la ruta del archivo generado: `./00-Inbox/<topic-slug>/links.md`

(End of file - total 9 lines)