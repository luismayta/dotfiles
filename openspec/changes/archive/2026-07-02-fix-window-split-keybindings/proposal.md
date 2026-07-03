## Why

Las combinaciones `CTRL+X + 1/2/3` para dividir ventanas (splits) en Neovim han dejado de funcionar. Actualmente `<C-x>` está secuestrado en insert mode por Codeium (`codeium#Clear`), y no existe ningún mapping que use `CTRL+X` como prefijo para operaciones de ventana. Esto rompe el flujo de trabajo de división de buffers que el usuario tenía configurado previamente.

## What Changes

1. **Restaurar `CTRL+X` como prefijo para operaciones de split de ventanas** en normal mode:
   - `CTRL+X + 1` → split horizontal (`:split`)
   - `CTRL+X + 2` → split vertical (`:vsplit`)
   - `CTRL+X + 3` → dividir ambos ejes o cerrar ventanas (definir comportamiento exacto)
2. **Preservar el mapping insert-mode de `<C-x>` para Codeium** — el cambio solo aplica en normal mode, por lo que no hay conflicto.
3. **Analizar si hay mappings de LazyVim que interfieran** con el prefijo `CTRL+X`.
4. **(Opcional)** Agregar mappings adicionales útiles bajo el mismo prefijo (e.g., `CTRL+X + 0` para cerrar ventana, `CTRL+X + o` para mantener solo la actual).

## Capabilities

### New Capabilities
- `ctrl-x-splits`: Sistema de mappings con `CTRL+X` como prefijo para operaciones de división y manejo de ventanas en Neovim, compatible con LazyVim y Codeium.

### Modified Capabilities

*(Ninguna — no se modifican capacidades existentes, se agrega una nueva.)*

## Impact

- **Archivo afectado**: `zsh/modules/nvim/data/lua/config/keymaps.lua` — se agregan los nuevos mappings.
- **Sin breaking changes**: No se modifican mappings existentes de `<C-w>`, `<C-h/j/k/l>`, ni el `<C-x>` insert-mode de Codeium.
- **Plugins**: Sin impacto en plugins existentes.
- **Compatibilidad**: Debe funcionar con LazyVim y todas las configuraciones actuales.
