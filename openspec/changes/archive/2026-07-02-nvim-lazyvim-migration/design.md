## Context

La configuración actual de Neovim reside en `zsh/modules/nvim/data/` y está basada en NvChad v2.5. Tiene tres fuentes de complejidad innecesaria:

1. **Build step manual**: `scripts/auto-import.lua` escanea `plugins/spec/` y genera `plugins/init.lua`, ejecutado vía `task build`. lazy.nvim ya descubre archivos automáticamente con import estático.
2. **Tres capas de configuración que se solapan**: `lua/jasper/` (capa personal) + `lua/configs/` (overrides de NvChad) + `lua/plugins/spec/` (specs de plugins) + `lua/plugins/override/` (segunda capa de overrides).
3. **Plugins muertos**: 6 plugins deshabilitados (avante, codecompanion, neocomposer, auto-session, dressing, nvim-colorizer) y plugins de UI de dudosa utilidad activa (screenkey, tabby-ml, dropbar).

El repo de comparación omerxx/dotfiles usa LazyVim con ~15 archivos y zero build step, demostrando que es posible tener una configuración moderna con mucho menos código.

## Goals / Non-Goals

**Goals:**
- Migrar de NvChad v2.5 a LazyVim como framework base
- Eliminar `scripts/auto-import.lua` y el build step (`task build`)
- Versionar plugins via `lazy-lock.json` para reproducibilidad
- Reducir de ~70 archivos a ~15 archivos de configuración
- Cambiar leader key a `<Space>` (estándar de la industria)
- Preservar todos los plugins funcionales actuales
- Mantener compatibilidad con el módulo zsh existente

**Non-Goals:**
- No cambiar LSP servers, formatters, o linters (se mantienen vía mason)
- No modificar `zsh/modules/nvim/` — solo el contenido de `data/`
- No agregar nuevos plugins que no existan actualmente
- No cambiar la experiencia de usuario más allá del leader key

## Decisions

### Decisión 1: Migración por fases vs big-bang
**Opción elegida: Faseada (4 fases)**
- Fase 0: Limpieza dentro de NvChad (eliminar build step, plugins muertos) — válida incluso si no se completa la migración
- Fase 1: Bootstrap LazyVim (init.lua, lazy.lua, options.lua, keymaps.lua, autocmds.lua, lazyvim.json)
- Fase 2: Portar plugins custom a archivos planos de lazy.nvim
- Fase 3: Migrar capa `jasper/` y eliminar directorios legacy
- **Alternativa rechazada**: Big-bang (todo en un commit) — riesgo alto de regresión, difícil de debuggear

### Decisión 2: Output adicional al flake vs flake separado
**Opción elegida: Output adicional**
- Se agrega `darwinConfigurations` como output adicional al `flake.nix` existente
- `devShells` se mantiene intacto
- **Alternativa rechazada**: Flake separado en `nix-darwin/` — duplica inputs, dos flake.lock que divergen

### Decisión 3: LazyVim extras en `lazyvim.json`
**Opción elegida: Extras declarativos**
- Los extras se declaran en `lazyvim.json` (formato estándar de LazyVim)
- Plugins muy custom (codeium, codesnap, etc.) van en `lua/plugins/*.lua`
- **Alternativa rechazada**: Configurar cada extra manualmente — más código, menos mantenibilidad

### Decisión 4: Leader key `,` vs cambiar a `<Space>`
**Opción elegida: `,` (mantener)**
- Preferencia personal del usuario — evitar cambio de muscle memory
- LazyVim soporta `vim.g.mapleader = ","` en keymaps.lua sin problemas
- Todos los bindings custom se re-mapean contra `,` en lugar de `<Space>`
- **Alternativa rechazada**: `<Space>` — requeriría periodo de adaptación, fricción innecesaria

### Decisión 5: home-manager como complemento vs reemplazo del módulo zsh
**Opción elegida: home-manager como complemento**
- home-manager gestiona solo `initExtra` (daemon sourcing), session vars, direnv
- El módulo zsh existente sigue siendo la fuente de verdad para toda la configuración de shell
- **Alternativa rechazada**: home-manager gestionando todo el zsh — crearía dos fuentes de verdad en conflicto

## Risks / Trade-offs

| Riesgo | Severidad | Mitigación |
|--------|-----------|------------|
| Cambio de leader key causa fricción | Media | Documentar el cambio, periodo de adaptación de 1-2 semanas. Coincide con el cambio de framework, es el momento óptimo. |
| Plugin custom sin equivalente en LazyVim | Media | Cada plugin custom se porta individualmente en Fase 2. Si no hay reemplazo, se mantiene como spec file propio. |
| Regresión en flujo de trabajo diario | Media | Fase 0 es segura y válida por sí sola. Fases 1-4 se hacen en rama separada con testing en máquina limpia. |
| `eachDefaultSystem` + `darwinConfigurations` generan attrset inválido | Baja | Testear con `nix flake show` en Linux antes de commit. El operador `//` mergea attrsets con keys disjuntos — no colisionan. |
| Hostname macOS incorrecto | Media | Usar `scutil --get ComputerName` en la Mac real antes del primer rebuild. Configurable en `default.nix`. |
