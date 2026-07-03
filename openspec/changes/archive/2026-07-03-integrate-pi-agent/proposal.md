## Why

Pi (pi.dev) es un framework moderno de agentes de IA para terminal que complementa el ecosistema actual de herramientas AI del módulo `zsh/modules/ai/`. A diferencia de herramientas como opencode (enfocado en edición de código) o fabric (enfocado en patrones de prompting), Pi es un "agent harness" extensible que conecta LLMs con el sistema de archivos, la terminal y herramientas externas via MCP. Integrarlo permite automatizar tareas de desarrollo directamente desde la terminal con un agente configurable y extensible.

## What Changes

- **Nuevo tool `pi` en el módulo AI**: Instalación, PATH loading y actualización via el gestor unificado `ai::install` / `ai::sync`
- **URL de instalación**: `https://pi.dev/install.sh` integrada en el sistema batch del módulo
- **Wrapper público `ai::pi::install`**: Para instalación individual del agente Pi
- **Carga automática en PATH**: Si `~/.local/bin/pi` existe, se agrega al PATH al cargar el módulo
- **Soporte batch**: `pi` se incluye en el array `AI_TOOLS` para instalación junto con el resto de herramientas
- **Config sync**: Configuración base de Pi con OpenCode Zen como provider (`settings.json` + `models.json`) desplegable via `ai::sync`
- **OpenCode Zen como provider default**: Pi configurado para usar `opencode/big-pickle` y otros modelos OpenCode Zen

## Capabilities

### New Capabilities
- `pi-agent`: Instalación, configuración y carga en PATH del framework Pi AI Agent

### Modified Capabilities
- `plugin-ai`: Se agrega `pi` como una herramienta más del ecosistema AI, con soporte completo de instalación batch, PATH loading, configuración sincronizable y wrapper público

## Impact

- **Archivos modificados**: `zsh/modules/ai/config/base.zsh`, `zsh/modules/ai/internal/base.zsh`, `zsh/modules/ai/internal/main.zsh`, `zsh/modules/ai/pkg/helper.zsh`
- **Archivos nuevos**: `zsh/modules/ai/data/pi/settings.json`, `zsh/modules/ai/data/pi/models.json`
- **Dependencias**: `curl` y `bash` (ya requeridos por otras herramientas del módulo)
- **Nuevo binario**: `~/.local/bin/pi`
- **Nuevo directorio config**: `~/.pi/agent/` (creado por Pi al ejecutarse)
- **Sin breaking changes**: La integración es aditiva, no modifica el comportamiento existente
