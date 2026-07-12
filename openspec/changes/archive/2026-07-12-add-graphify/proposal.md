## Why

El módulo AI de dotfiles administra herramientas de IA (opencode, fabric, ollama, etc.) pero carece de graphify — una herramienta que convierte codebases en knowledge graphs consultables. Graphify permite a los asistentes de IA razonar sobre la estructura del código en lugar de depender de grep, mejorando la precisión y trazabilidad de las respuestas. Se necesita integrar graphify siguiendo los patrones existentes del módulo.

## What Changes

- Se agrega graphify como nueva herramienta en el módulo AI
- Instalación via `uv tool install "graphifyy[all]" --force` (primera herramienta UV en el módulo)
- Configuración de variables de entorno (AI_GRAPHIFY_*)
- Funciones de instalación, carga PATH y registro en el batch installer
- Registro del skill con `graphify install` para OpenCode
- Soporte para configuración y sincronización

## Capabilities

### New Capabilities
- `graphify-tool`: Integración completa de graphify en el módulo AI — instalación, configuración, PATH loading, y funciones públicas

### Modified Capabilities
- `plugin-ai`: Se extiende el spec existente para incluir graphify como herramienta soportada

## Impact

- **Archivos modificados**:
  - `config/base.zsh` — Variables de entorno AI_GRAPHIFY_*
  - `internal/base.zsh` — Función ai::internal::graphify::install + case en batch installer
  - `internal/main.zsh` — Llamada a ai::internal::graphify::load
  - `pkg/helper.zsh` — Funciones públicas ai::graphify::*
  - `pkg/alias.zsh` — Aliases opcionales para graphify
- **Nuevos archivos**:
  - `data/graphify/` — Directorio de configuración (si aplica)
- **Dependencias**: 
  - Requiere Python 3.10+ (ya presente en el sistema)
  - Requiere uv (ya instalado)
- **Sistemas afectados**: Shell environment, AI tooling ecosystem
