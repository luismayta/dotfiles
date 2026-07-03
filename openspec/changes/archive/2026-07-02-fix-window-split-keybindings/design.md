## Context

Actualmente en la configuración de Neovim (`zsh/modules/nvim/data/`):

- El `<C-x>` en insert mode está mapeado a `codeium#Clear()` (en `lua/plugins/ai/ai.lua`)
- No existe ningún mapping con `<C-x>` como prefijo en normal mode
- Los splits de ventana se manejan exclusivamente mediante el prefijo por defecto `<C-w>` (viene de Vim/LazyVim)
- La navegación entre ventanas usa `<C-{h,j,k,l}>` → `<C-w>{h,j,k,l}`
- El resize usa `<C-A-{h,j,k,l}>`
- El leader es `,`

El usuario reporta que `Ctrl+X + 1`, `Ctrl+X + 2`, `Ctrl+X + 3` para splits dejaron de funcionar. No hay evidencia de que hayan estado configurados previamente en los archivos actuales — es posible que vinieran de una configuración anterior o de LazyVim por defecto, y se hayan perdido durante una migración.

## Goals / Non-Goals

**Goals:**
- Restaurar `<C-x>` como prefijo en normal mode para operaciones de split de ventanas
- `Ctrl+X + 1` → cerrar otras ventanas (`<C-w>o`)
- `Ctrl+X + 2` → split vertical (`:vsplit` o `:vnew`)
- `Ctrl+X + 3` → split horizontal (`:split` o `:new`)
- No interferir con el mapping insert-mode de `<C-x>` para Codeium
- Los mappings deben funcionar con LazyVim y todos los plugins actuales

**Non-Goals:**
- No modificar los mappings existentes de `<C-w>` (se mantienen como alternativa)
- No modificar la navegación `<C-{h,j,k,l}>`
- No migrar a un sistema diferente de window management
- No agregar funcionalidades nuevas más allá del prefijo `<C-x>`

## Decisions

### 1. Usar `vim.keymap.set` con `desc` descriptivo
**Decisión**: Los mappings usarán `vim.keymap.set("n", ...)` con el atributo `desc` para autodocumentación.
**Rationale**: Consistente con el estilo existente en `keymaps.lua`. El `desc` permite identificar el propósito con `which-key` y otros visualizadores.
**Alternativa considerada**: Usar `nmap` — se descarta por inconsistencia con el estilo actual.

### 2. Namespace `CTRL+X` solo en normal mode
**Decisión**: Los mappings se definen únicamente en normal mode (`"n"`).
**Rationale**: No hay conflicto con el mapping insert-mode de Codeium. El prefijo `CTRL+X` en otros modos (insert, visual) podría interferir con autocompletado nativo de Vim.

### 3. Ubicación: `lua/config/keymaps.lua`
**Decisión**: Los mappings se agregan en `lua/config/keymaps.lua`, al final, con un comentario de sección `-- Window splits (Ctrl-X prefix)`.
**Rationale**: Todos los keymaps personalizados están en ese archivo. Es el lugar esperado y fácil de mantener.

### 4. Comportamiento de `CTRL+X + 1` (cerrar otras ventanas)
**Decisión**: `CTRL+X + 1` ejecutará `<C-w>o` (cerrar todas las ventanas excepto la actual) si hay más de una ventana; si solo hay una, no hace nada (comportamiento nativo de `<C-w>o`).
**Rationale**: Sigue la convención que el usuario tenía previamente. El `1` es fácil de alcanzar y tiene sentido como "keep only one window".

## Risks / Trade-offs

- **[Conflicto con `<C-x>` en otros modos]** El mapping solo aplica en normal mode. En insert mode `<C-x>` sigue siendo Codeium; en visual mode no está mapeado. Sin riesgo real.
- **[Comportamiento inesperado si hay plugins que usen `<C-x>` como prefijo]** Ningún plugin conocido en la configuración actual usa `<C-x>` como líder. LazyVim no lo usa. Riesgo bajo.
- **[Músculo memorizado]** El usuario ya tenía estos mappings en su configuración anterior. La corrección los alinea con lo que esperaba.
