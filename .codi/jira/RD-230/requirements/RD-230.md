# Task: Renombrar TMUX_SOCKET a HERDR_WORKSPACE en emuladores de terminal

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Sustituir TMUX_SOCKET por HERDR_WORKSPACE en la configuración de Ghostty, WezTerm y Alacritty
- component: DevOps
- labels: []
- parentEpic: 
- issueKey: RD-230
- jpdSource: 

## Scenario

Los emuladores de terminal (Ghostty, WezTerm y Alacritty) definían la variable
TMUX_SOCKET para enrutar el socket de tmux según el emulador activo. Con la
migración de tmux hacia herdr como gestor de sesiones y workspaces, esa variable
debe renombrarse a HERDR_WORKSPACE para que el routing de workspaces en herdr
funcione igual que antes. La variable se inyecta desde la configuración de cada
emulador y se propaga a los procesos hijos del shell, por lo que el cambio afecta
a toda la infraestructura de terminal del equipo.

El renombrado, por sí solo, deja la variable como un productor colgante: los tres
emuladores la definen y ningún código la lee. Para que la migración tenga efecto
observable, la variable necesita un consumidor — una función de entrada que lance
herdr enrutada por el emulador activo, tal como el módulo tmux consumía
TMUX_SOCKET para enrutar por socket.

## Consumer gap

`HERDR_WORKSPACE` no tiene consumidor hoy:

- `zsh/modules/herdr/config/base.zsh:11` exporta `ZSH_HERDR_WORKSPACE_PREFIX`.
- `zsh/modules/herdr/config/base.zsh:34` expone el alias `HERDR_WORKSPACE_PREFIX`.
- Ninguna función lee `HERDR_WORKSPACE` con el nombre exacto, sin sufijo. Las
  únicas apariciones en código son las tres configs de emulador que la definen.

El seam previsto ya existe, documentado de forma incorrecta: el wrapper `_hrd()`
en `zsh/modules/herdr/pkg/helper.zsh:7-10` declara "with optional TMUX-like socket
support", pero su cuerpo es un passthrough vacío (`command herdr "$@"`). La lógica
de routing debe vivir ahí, no duplicada dentro de la función nueva.

## Implementation Contract

### Public function: `hrd::start`

Ubicación: `zsh/modules/herdr/pkg/helper.zsh`, junto a `hrd::project` (línea 83),
que es el entrypoint de facto más cercano y el template estructural a copiar.

Prefijo `hrd::`, no `herdr::`. La convención de facto del módulo es `hrd::` para
comandos interactivos de usuario (27 funciones) y `herdr::` para wrappers de ciclo
de vida sobre `herdr::internal::*` (24 funciones). `pkg/helper.zsh` no contiene
ninguna función `herdr::`.

Interfaz:

```
hrd::start
```

| Condición | Comportamiento |
|---|---|
| `HERDR_WORKSPACE` definida y no vacía | Ejecuta `herdr --session "${HERDR_WORKSPACE}"` |
| `HERDR_WORKSPACE` vacía o ausente | Invoca `herdr` sin `--session` e informa por `message_info` |
| `herdr` no está en PATH | `message_error` y `return 1` |

Código esperado:

```zsh
# hrd::start — launch herdr routed by the active terminal emulator.
# Without arguments: uses HERDR_WORKSPACE to select the per-emulator
# session passed to herdr through the --session flag.
function hrd::start {
  if ! core::exists herdr; then
    message_error "herdr is not installed."
    return 1
  fi

  if [[ -n "${HERDR_WORKSPACE:-}" ]]; then
    _hrd --session "${HERDR_WORKSPACE}"
  else
    message_info "HERDR_WORKSPACE is not set; starting herdr without routing."
    _hrd
  fi
}
```

### El routing pertenece a `_hrd()`

`_hrd()` (`pkg/helper.zsh:7-10`) debe seguir siendo el único punto que invoca el
binario `herdr`. Su comentario actual es incorrecto: la variante equivalente en el
módulo tmux (`zsh/modules/tmux/pkg/helper.zsh:47-51`) sí implementa el routing real.

Referencia del patrón a replicar — `zsh/system/core/pkg/helper/tmux.zsh:5-9,23`:

```zsh
# Use TMUX_SOCKET when outside tmux (e.g., ghostty/wezterm terminal-specific sockets)
if [[ -z "${TMUX}" && -n "${TMUX_SOCKET:-}" ]]; then
  command tmux -L "${TMUX_SOCKET}" "$@"
fi
```

### Flag verificado: `-s` no existe, corresponde `--session`

Verificado contra `herdr 0.9.1` (`/home/lucho/.local/bin/herdr`):

| Prueba | Resultado |
|---|---|
| `herdr -s ghostty` | exit 0, sin error; `Logs:` queda en `~/.config/herdr/herdr.log` → flag **ignorado** |
| `herdr --session ghostty` | `Logs:` se mueve a `~/.config/herdr/sessions/ghostty/herdr.log` → **aplicado** |
| `herdr --definitely-not-a-flag` | exit 0, sin error |
| `herdr -Z` | exit 0, sin error |

**El parser de herdr descarta silenciosamente cualquier flag desconocido.** Un
`hrd::start` escrito con `-s` no habría fallado: se habría conectado a la sesión
`default` sin emitir error ni aviso. Este es el motivo por el que `-s` queda
registrado aquí como descartado, y no borrado.

Flags cortos reales, extraídos de los 124 bloques `opts=` de `herdr completion
bash`: `-h` y `-V` globales, `-v` en `herdr agent explain`, `-y` en
`herdr integration plugin install`. No existe forma larga equivalente a `-s`.

El equivalente de `-L` de tmux es `--session <name>`, disponible solo en forma
larga. No existen `--socket` ni `--instance`; `--server` es un verbo, no un flag de
nombre.

Nota de diseño: herdr define `HERDR_ENV=1` y `HERDR_PANE_ID` dentro de sus panes y
el binario ya auto-apunta a la sesión actual sin recibir ningún flag. Aun así se
mantiene `--session "${HERDR_WORKSPACE}"` porque replica la intención original de
`TMUX_SOCKET`: un workspace persistente por emulador.

## Acceptance Tests

- Ghostty define HERDR_WORKSPACE=ghostty y ya no define TMUX_SOCKET
- WezTerm define HERDR_WORKSPACE=wezterm y ya no define TMUX_SOCKET
- Alacritty define HERDR_WORKSPACE=alacritty y ya no define TMUX_SOCKET
- Ningún archivo bajo zsh/modules/ghostty/ contiene la cadena TMUX_SOCKET ni referencia a tmux
- Los comentarios de wezterm.lua que describían el propósito de TMUX_SOCKET se actualizan para describir HERDR_WORKSPACE
- HERDR_WORKSPACE conserva el valor identificador del emulador en los tres archivos de configuración
- `hrd::start` existe en `zsh/modules/herdr/pkg/helper.zsh` y usa el prefijo `hrd::`
- Con `HERDR_WORKSPACE` definida, `hrd::start` invoca `herdr --session` con ese valor y **no** invoca `herdr -s`
- Sin `HERDR_WORKSPACE`, `hrd::start` invoca `herdr` sin `--session`, informa al usuario y no falla
- El routing se resuelve en `_hrd()` y no está duplicado dentro de `hrd::start`
- `_hrd()` mantiene su comentario sobre socket support solo si el routing queda implementado en él
- Regresión: `herdr --session ghostty` desplaza el estado a `~/.config/herdr/sessions/ghostty/`, confirmando que `--session` sí se aplica
- Regresión: ninguna invocación del módulo usa `-s`, dado que herdr la descarta en silencio
- `docs/env-vars.md` documenta `HERDR_WORKSPACE` por emulador y ya no presenta `TMUX_SOCKET` como vigente

## Dependencies

| Dependency | Use |
|------------|-----|
| `herdr` CLI | Binario lanzado por `hrd::start` vía `_hrd()` |
| `core::exists` | Detección de `herdr` en PATH |
| `message_error` / `message_info` | Salida al usuario ante variable ausente o CLI faltante |
| `HERDR_WORKSPACE` | Variable de entorno inyectada por Ghostty, WezTerm y Alacritty |

## Sources

- `docs/env-vars.md` (documenta TMUX_SOCKET por emulador; queda desactualizado tras este cambio)
- `herdr 0.9.1` (`/home/lucho/.local/bin/herdr`) — `--session` verificado funcionalmente; `-s` descartado
- `zsh/modules/herdr/pkg/helper.zsh:7-10` (`_hrd()`, seam de routing; comentario actual incorrecto)
- `zsh/modules/herdr/pkg/helper.zsh:83` (`hrd::project`, template estructural)
- `zsh/modules/herdr/config/base.zsh:11,34` (`ZSH_HERDR_WORKSPACE_PREFIX` y su alias)
- `zsh/modules/tmux/pkg/helper.zsh:47-51` (implementación de referencia del routing por socket)
- `zsh/system/core/pkg/helper/tmux.zsh:5-9,23` (consumo de TMUX_SOCKET por emulador)
- https://github.com/luismayta/dotfiles.git
