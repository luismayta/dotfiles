## Context

El módulo AI de dotfiles sigue un patrón de 4 capas para cada herramienta:
1. **Config** (config/base.zsh) — Variables de entorno
2. **Internal** (internal/base.zsh) — Funciones de instalación y PATH loading
3. **Pkg** (pkg/helper.zsh) — Funciones públicas wrapper
4. **Data** (data/{tool}/) — Archivos de configuración

Actualmente no existen herramientas UV en el módulo — todas usan `curl | bash`, descarga de binarios, o `npm install -g`. Graphify será la primera herramienta instalada via `uv tool install`.

## Goals / Non-Goals

**Goals:**
- Integrar graphify siguiendo el patrón existente del módulo AI
- Instalar via `uv tool install "graphifyy[all]" --force` (con extras completas)
- Configurar PATH para que el comando `graphify` esté disponible
- Registrar el skill con OpenCode via `graphify install --platform opencode`
- Mantener idempotencia (skip si ya está instalado)

**Non-Goals:**
- Modificar la configuración de OpenCode (opencode.json) — graphify auto-genera sus archivos
- Configurar MCP server de graphify (se puede hacer después)
- Agregar graphify a la lista AI_TOOLS para batch install (es instalación manual por UV)

## Decisions

### 1. Instalación via UV en lugar de curl | bash
**Decisión**: Usar `uv tool install "graphifyy[all]" --force`
**Razón**: 
- Graphify es un paquete Python publicado en PyPI
- UV aísla el paquete en su propio entorno virtual
- El `--force` permite reinstalación limpia cuando se actualiza
- Es la forma recomendada por los mantenedores de graphify

**Alternativas consideradas**:
- `pipx install graphifyy` — Funcional pero UV es más rápido y ya está en el sistema
- `pip install graphifyy` — Requiere configuración manual de PATH

### 2. No agregar a AI_TOOLS para batch install
**Decisión**: No incluir graphify en el array AI_TOOLS
**Razón**:
- Las herramientas en AI_TOOLS se instalan via `ai::internal::packages::install`
- Graphify requiere UV que puede no estar presente en todas las máquinas
- Es más seguro tener una instalación explícita que falla claro si falta UV

**Alternativa considerada**:
- Agregar con guard `core::exists uv` — Complejidad innecesaria para una herramienta que se instala una vez

### 3. Skill registration post-install
**Decisión**: Ejecutar `graphify install --platform opencode` después de la instalación
**Razón**:
- Graphify detecta automáticamente el asistente de IA y crea archivos de configuración
- Para OpenCode, crea instrucciones en el directorio del proyecto
- Es el flujo estándar documentado por graphify

### 4. Sin data/ por ahora
**Decisión**: No crear directorio data/graphify/ inicialmente
**Razón**:
- Graphify genera su configuración via `graphify install`
- No hay archivos de configuración que sincronizar entre máquinas
- Se puede agregar después si se necesitan patrones personalizados

## Risks / Trade-offs

**[Risk]**: UV puede no estar instalado en el sistema target
→ **Mitigation**: La función de instalación verificará `core::exists uv` y fallará con mensaje claro

**[Risk]**: `graphify install` puede modificar archivos del proyecto
→ **Mitigation**: Es comportamiento esperado — crea archivos de skill que se pueden gitignorer si es necesario

**[Risk]**: El `--force` reinstala en cada ejecución
→ **Mitigation**: Se puede ajustar para solo forzar si hay una versión más nueva disponible

## Migration Plan

1. Ejecutar `source plugin.zsh` para cargar las nuevas funciones
2. Ejecutar `ai::graphify::install` para instalar graphify
3. Verificar con `graphify --version`
4. En cualquier proyecto, ejecutar `graphify install --platform opencode` para registrar el skill

**Rollback**: 
- `uv tool uninstall graphifyy` desinstala el paquete
- Eliminar archivos creados por `graphify install` en el proyecto

## Open Questions

- ¿Se debe agregar graphify al batch installer con un guard de UV?
- ¿Se necesita algún alias específico para graphify?
- ¿Se debe crear data/graphify/ para configuración personalizada?
