# Task: Configurar modelo space-bunny-free en provider opencode-go

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Agregar opencode-go/space-bunny-free como modelo preferencial en codi-opencode.json, conservando fallback actual
- component: DevOps
- labels: [opencode, ai-tooling, config, provider]
- parentEpic: 
- issueKey: RD-223
- jpdSource: 

## Scenario

El plugin `@codiplab/codi-opencode` resuelve el modelo de cada agente mediante `modelSelect.byProvider` en `codi-opencode.json`, respetando el orden de `providerPriority`. Actualmente las 8 categorias de agente (orchestrator, oracle, librarian, explorer, designer, auditor, fixer, quick) apuntan a modelos `opencode-go` de terceros: `minimax-m2.7`, `minimax-m2.5`, `qwen3.6-plus` y `glm-5.1`.

Se requiere incorporar `opencode-go/space-bunny-free` como primera opcion para todas las categorias, manteniendo los modelos actuales como fallback para no perder cobertura si el modelo free no esta disponible o no cumple limites de contexto.

Archivo afectado: `zsh/modules/ai/data/opencode/codi-opencode.json`


### Acceptance Tests

1. Las 8 categorias en `modelSelect.byProvider.opencodeGo` (orchestrator, oracle, librarian, explorer, designer, auditor, fixer, quick) tienen `opencode-go/space-bunny-free` como primer elemento del array.
2. Los modelos previos de cada categoria se conservan como elementos posteriores del mismo array.
3. `explorer`, que hoy tiene dos entradas (`minimax-m2.7`, `glm-5.1`), queda con tres: `space-bunny-free` primero seguido de ambos.
4. No se modifica `providerPriority` ni ningun otro bloque de `codi-opencode.json`.
5. No se modifica `opencode.jsonc` (el provider `opencode-go` es interno de OpenCode y se expose via plugin, no requiere entrada en el bloque `provider`).
6. El JSON resultante es valido (parseable) y no contiene claves duplicadas.
7. OpenCode arranca sin errores de validacion de config y el orchestrator resuelve `opencode-go/space-bunny-free`.


### Sources

- zsh/modules/ai/data/opencode/codi-opencode.json
- zsh/modules/ai/data/opencode/opencode.jsonc
- Documentacion de OpenCode sobre providers custom y resolucion de modelos por agente
- https://github.com/luismayta/dotfiles.git