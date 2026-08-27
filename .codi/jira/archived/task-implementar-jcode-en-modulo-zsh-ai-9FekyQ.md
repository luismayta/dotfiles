# Task: Implementar jcode en módulo zsh ai

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Agregar jcode como herramienta AI en el módulo zsh/modules/ai/
- component:
- labels: [jcode, ai, zsh, dotfiles]
- parentEpic: RD-30
- issueKey: RD-133
- jpdSource:

## Scenario

El módulo `zsh/modules/ai/` actualmente soporta herramientas AI como opencode, ollama, fabric, shimmy, hf, openclaw, tmuxai, entre otras. Se necesita agregar soporte para **jcode** (https://github.com/1jehuang/jcode), un harness de IA de alto rendimiento escrito en Rust, conocido por su eficiencia en RAM y features como memory system, swarm multi-agent, OAuth providers, y browser automation.

La implementación debe seguir el patrón establecido por las herramientas existentes en el módulo, creando los archivos de configuración, internal y pkg necesarios, y registrándolo en los archivos main.zsh correspondientes.

### Acceptance Tests

1. Crear `config/jcode.zsh` con variables de configuración (ROOT_PATH, BIN_PATH, CONFIG_PATH, INSTALL_URL)
2. Crear `internal/jcode.zsh` con funciones `ai::internal::jcode::load` (PATH), `ai::internal::jcode::install` (instalación via curl), `ai::internal::jcode::sync` (sincronización de config)
3. Crear `pkg/jcode.zsh` con funciones públicas `editjcode`, `ai::jcode::install`, `ai::jcode::sync`
4. Registrar jcode en `config/base.zsh`: agregar source de config/jcode.zsh y agregar `jcode` al array `ZSH_AI_TOOLS`
5. Registrar jcode en `internal/main.zsh`: agregar source de internal/jcode.zsh y llamada a `ai::internal::jcode::load`
6. Registrar jcode en `pkg/main.zsh`: agregar source de pkg/jcode.zsh
7. Verificar que el archivo plugin.zsh no requiere modificaciones (ya carga config/main.zsh → internal/main.zsh → pkg/main.zsh)
8. Los paths de jcode en Linux: `~/.jcode/bin` para el binario, `~/.jcode/` para config, `~/.config/jcode/` para config del sistema
9. El INSTALL_URL debe ser `https://jcode.sh/install`
10. La instalación debe usar `curl -fsSL https://jcode.sh/install | bash`

### Sources

- https://github.com/1jehuang/jcode
- https://jcode.sh/docs
- Estructura existente del módulo: zsh/modules/ai/config/, zsh/modules/ai/internal/, zsh/modules/ai/pkg/
- Patrón de referencia: config/opencode.zsh, internal/opencode.zsh, pkg/opencode.zsh

- https://github.com/luismayta/dotfiles.git