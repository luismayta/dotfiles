## Context

Se auditaron 67 archivos `.lua` del módulo nvim (`zsh/modules/nvim/data/lua/`). La configuración migró de LazyVim a NvChad v2.5, pero arrastra inconsistencias: opciones sin aplicar, plugins deprecados, configuraciones duplicadas, y código muerto. La configuración funciona parcialmente — bugs como `options.lua` comentado y `typescript.lua` con scope roto afectan la experiencia de desarrollo.

## Goals / Non-Goals

**Goals:**
- Activar todas las opciones de Neovim actualmente definidas pero no aplicadas
- Eliminar todas las configuraciones duplicadas de LSP servers
- Migrar todas las deprecaciones (tsserver → ts_ls, null-ls → conform, typescript.nvim → typescript-tools.nvim)
- Resolver todos los mappings duplicados y conflictivos
- Consolidar formatting en conform.nvim
- Limpiar código muerto y configs huérfanas

**Non-Goals:**
- NO cambiar la estructura del módulo zsh (config/, internal/, pkg/, plugin.zsh)
- NO agregar nuevas funcionalidades o plugins
- NO cambiar el tema o apariencia visual
- NO modificar la lógica de sincronización (rsync) del módulo

## Decisions

### 1. Estrategia de LSP: manual setup, no mason-lspconfig
**Decisión**: Usar configuración manual en `lspconfig.lua` con `setup_handlers` de mason-lspconfig como fallback, eliminando la lista `ensure_installed` duplicada de `mason-lspconfig.lua`.
**Rationale**: Las configs manuales permiten control granular (on_attach custom, deshabilitar formatting por server). `mason-lspconfig` handler genérico no soporta casos como tsserver/ts_ls donde necesitamos deshabilitar formatting.
**Alternativa considerada**: Usar solo mason-lspconfig handlers — descartado porque pierde las configs específicas por server.

### 2. Formatting: conform.nvim como único sistema
**Decisión**: Migrar todo formatting a conform.nvim. Eliminar `configs/null-ls.lua` y el bloque `null_ls.setup()` de `lspconfig.lua`.
**Rationale**: conform ya está configurado y activo. Tener 3 sistemas de formato (conform, null-ls, none-ls) causa race conditions y formato doble. conform es más rápido (async por defecto) y tiene mejor integración con lazy.nvim.
**Alternativa considerada**: Mantener none-ls — descartado porque el proyecto none-ls tiene mantenimiento incierto.

### 3. Deprecaciones se migran directamente
**Decisión**: `tsserver` → `ts_ls`, `typescript.nvim` → `typescript-tools.nvim`, null-ls → conform.
**Rationale**: Son reemplazos directos sin cambios en la API pública. Las migraciones son seguras y bien documentadas.

### 4. Arquitectura de configuración: cada cosa en su lugar
**Decisión**: Centralizar treesitter en `configs/overrides.lua`. Eliminar calls dispersas en specs.
**Rationale**: `configs/overrides.lua` ya es el lugar designado para overrides de plugins core.

### 5. Orden de aplicación de cambios
**Decisión**: Primero los fixes críticos (options, lsp, typescript), luego deprecaciones, luego limpieza.
**Rationale**: Los críticos afectan la funcionalidad actual. La limpieza es cosmetic y no urgente.

## Risks / Trade-offs

| Riesgo | Mitigación |
|--------|------------|
| Al activar options.lua, folds y scroll cambian comportamiento | Los valores actuales en el archivo son los deseados; es corregir un bug, no cambiar defaults |
| Migrar tsserver → ts_ls puede requerir reinstalar el server via Mason | ts_ls ya está disponible en Mason, solo cambiar el nombre |
| Reemplazar typescript.nvim requiere verificar compatibilidad con proyectos existentes | typescript-tools.nvim es compatible con la misma API de lspconfig |
| Eliminar null-ls puede romper ruff diagnostics si no se migra | ruff se migrará como linter a conform o neoconform |
| El cambio de Trouble v2 → v3 puede romper muscle memory | Los nuevos comandos son similares; documentar en el PR |
