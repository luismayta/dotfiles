## Context

El archivo `zsh/modules/nvim/data/lua/plugins/ai/ai.lua` declara avante.nvim como deshabilitado (`enabled = false`), pero su dependencia `MeanderingProgrammer/render-markdown.nvim` sigue activa porque lazy.nvim resuelve dependencias independientemente del plugin padre. Al tener `ft = { "markdown" }`, se carga cada vez que se abre un archivo .md usando la configuración por defecto, que es visualmente invasiva:

- Cabeceras con fondo de ancho completo (`width = "full"`)
- Signos en la columna de signos (`sign = true`)
- Posición overlay que oculta los `#`
- Enlaces con íconos grandes y rendering de footnote
- Checkboxes con rendering completo

Esto no solo es abrumador visualmente, sino que ciertos modos de rendering (especialmente overlay y signos) pueden interferir con la experiencia de escritura.

Por otro lado, `navigation/neo-tree.lua` tiene `<leader>e` como un remap a `<leader>fe`, ambos apuntando a `LazyVim.root()`. La intención original de LazyVim es que `<leader>e` abra neotree en el directorio del archivo actual, no en la raíz.

## Goals / Non-Goals

**Goals:**
- Configurar `render-markdown.nvim` con opciones limpias y minimalistas, manteniéndolo activo
- Extraerlo de las dependencias de avante (deshabilitado) para tener control explícito
- Que `<leader>e` abra neotree en el directorio del archivo actual
- Que `<leader>fe` mantenga su comportamiento actual (raíz del proyecto)

**Non-Goals:**
- No se deshabilita `render-markdown.nvim`
- No se cambia ningún otro keybinding de neotree
- No se modifica el comportamiento de avante.nvim (sigue deshabilitado)
- No se agregan nuevos plugins

## Decisions

### 1. Extraer `render-markdown.nvim` como plugin independiente con configuración limpia

**Opción elegida:** Mover `render-markdown.nvim` de las dependencias de avante a un archivo propio `text/render-markdown.lua` con configuración explícita minimalista.

**Alternativa considerada:** Dejarlo dentro de avante. Se descarta porque:
- Avante está deshabilitado, lo cual es confuso
- La configuración queda escondida dentro de un plugin muerto
- Es más mantenible tenerlo como plugin de primera clase

**Configuración limpia:**
```lua
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  opts = {
    heading = {
      sign = false,                -- sin signos en la columna de signos
      position = "inline",         -- íconos inline en lugar de overlay
      width = "block",             -- fondo solo del ancho del texto
    },
    link = {
      enabled = false,             -- sin rendering de enlaces (menos ruido)
    },
  },
}
```

**Racional de cada opción:**

| Opción | Valor | Efecto |
|---|---|---|
| `heading.sign` | `false` | Elimina signos en la columna lateral — menos clutter visual |
| `heading.position` | `"inline"` | En lugar de overlay (que oculta `#` y pinta fondo completo), mantiene los `#` visibles con el ícono al lado — más predecible para escribir |
| `heading.width` | `"block"` | Fondo coloreado solo detrás del texto, no en toda la ventana — más limpio |
| `link.enabled` | `false` | Desactiva rendering de enlaces (íconos grandes, footnotes) que distraen al escribir |

### 2. `<leader>e` con función directa a neotree

**Opción elegida:** Reemplazar el remap por una función que use `vim.fn.expand("%:p:h")`.

**Implementación:**
```lua
{
  "<leader>e",
  function()
    local dir = vim.fn.expand("%:p:h")
    if dir == "" then dir = LazyVim.root() end
    require("neo-tree.command").execute { toggle = true, dir = dir }
  end,
  desc = "Explorer NeoTree (File Dir)",
},
```

### 3. Ubicación de los cambios

- `ai/ai.lua`: remover el bloque `render-markdown.nvim` de las dependencias de avante
- `text/render-markdown.lua`: **nuevo archivo** con la configuración limpia
- `navigation/neo-tree.lua`: modificar el keybinding `<leader>e`

## Risks / Trade-offs

- [**Dependencia duplicada**] → Si lazy.nigms resuelve el plugin tanto desde avante como desde el nuevo archivo, puede crear conflictos. **Mitigación:** Se remueve explícitamente de avante.
- [**Rendering perdido**] → Si el usuario disfrutaba de alguna feature desactivada (como enlaces con íconos), es fácil re-activarla. **Mitigación:** Diseño minimalista pero no restrictivo.
- [**Directorio vacío**] → Si se abre `nvim` sin archivo, `expand("%:p:h")` retorna vacío. Se fallbackea a `LazyVim.root()`.
