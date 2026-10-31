# Task: Implementar función zsh para validar, instalar y reinstalar MCPs de OpenCode

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Función zsh en el módulo ai para validar, instalar y reinstalar los MCPs de OpenCode desde una config central.
- component: 
- labels: [mcp, zsh, ai-tooling, opencode, dotfiles]
- parentEpic: 
- issueKey: RD-268
- jpdSource: NIP-17

## Scenario

Mantenemos múltiples servidores MCP configurados en ~/.config/opencode/opencode.jsonc dentro del bloque "mcp.servers". Cada servidor define su "type" (local/remote), un "command" (array), variables "environment" y un flag "disabled". Ejemplo del servidor aws-mcp:

  "aws-mcp": {
    "type": "local",
    "command": ["uvx", "mcp-proxy-for-aws@latest", "https://aws-mcp.us-east-1.api.aws/mcp", "--metadata", "INSTALL_SOURCE=aws-cli"]
  }

Cuando un MCP se rompe (instalación fallida, paquete desactualizado, variable de entorno faltante o caché del runner corrupta) no hay una forma rápida desde la terminal de verificarlo o reinstalarlo. Se necesita una función en el módulo zsh/modules/ai/ que reciba el "command" de un MCP y pueda ejecutarlo, instalarlo o reinstalarlo para confirmar que funciona, más un catálogo central de todos los MCPs y cómo deberían ejecutarse. Debe seguir la convención config/internal/pkg del módulo ai.

### Acceptance Tests

1. Nueva config central que lista todos los MCPs (nombre, type, command, environment) alineada con opencode.jsonc.
2. Función ai::opencode::mcp::validate <nombre> que lanza el comando del MCP y reporta si está funcionando.
3. Función ai::opencode::mcp::reinstall <nombre> que limpia la caché del runner (uvx/bunx/npx) y reinstala, luego re-valida.
4. Soporte de ejecución para los runners uvx, bunx, npx, docker run y binarios directos (p. ej. /home/lucho/.local/bin/workspace-mcp).
5. Respeta el flag "disabled": los MCPs deshabilitados no se validan por defecto.
6. API pública ai::opencode::mcp::* expuesta desde pkg/opencode.zsh, siguiendo la convención config/internal/pkg del módulo ai.
7. Mensajes claros con message_info/success/error y código de retorno != 0 ante fallos.

### Sources

- ~/.config/opencode/opencode.jsonc (bloque mcp.servers)
- zsh/modules/ai/config/opencode.zsh
- zsh/modules/ai/internal/opencode.zsh
- zsh/modules/ai/pkg/opencode.zsh
- zsh/modules/ai/plugin.zsh
- https://github.com/luismayta/dotfiles.git