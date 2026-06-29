## Context

El módulo `nvim` en `zsh/modules/nvim/data/` contiene archivos que inician con `.` (como `.stylua.toml`). Tanto `ripgrep` como `fd` ignoran archivos ocultos por defecto. Esto provoca que:

- Búsquedas con `rg` y `fd` no muestren estos archivos
- El helper `fgr` (grep via rg) omita contenido de dotfiles
- La experiencia de desarrollo sea inconsistente — el usuario asume que los archivos no existen o no están trackeados

Actualmente:
- `fo` (fd open) incluye `--hidden` → correcto
- `fa` (fd cd) incluye `--hidden` → correcto  
- `fgr` (rg grep) **no** incluye `--hidden` → incorrecto
- No existe `RIPGREP_CONFIG_PATH` ni `~/.ripgreprc`

## Goals / Non-Goals

**Goals:**
- Que `rg` incluya archivos ocultos por defecto en todas las invocaciones del dotfiles
- Que el helper `fgr` sea consistente con `fo`/`fa` respecto a archivos ocultos
- Que Telescope (Neovim) muestre archivos ocultos en todos los pickers — tanto `find_files` como `live_grep`
- Mantener la configuración dentro del repositorio git del dotfiles (trackeable)

**Non-Goals:**
- Modificar el comportamiento global de `rg` fuera del dotfiles (solo aplicar a shells que carguen este perfil)
- Cambiar el comportamiento de git (git funciona correctamente)

## Decisions

### 1. Usar `RIPGREP_CONFIG_PATH` + archivo en repo vs `~/.ripgreprc`

**Decisión:** Crear `zsh/core/config/ripgreprc` y exportar `RIPGREP_CONFIG_PATH` desde `env.zsh`.

**Razón:**
- El archivo queda versionado en el dotfiles, aplica automáticamente al clonar en un nuevo entorno
- `RIPGREP_CONFIG_PATH` es el mecanismo oficial de ripgrep para config persistente
- Consistente con el patrón existente de config en `zsh/core/config/` y env vars en `zsh/core/config/env.zsh`
- No contamina `~/.ripgreprc` (que podría ser sobrescrito por otras herramientas)

### 2. Agregar `--hidden` explícito en helper `fgr`

**Decisión:** Agregar `--hidden` al comando `rg` dentro del helper `fgr` en `zsh/core/pkg/helper/core.zsh`.

**Razón:**
- Aunque `RIPGREP_CONFIG_PATH` ya haría que `rg` incluya `--hidden`, tenerlo explícito hace que el helper sea autónomo y comprensible sin depender de config externa
- Consistencia con `fo` y `fa` que ya declaran `--hidden` explícitamente
- Sigue el principio de "explicitud sobre magia"

### 3. Configurar Telescope para mostrar archivos ocultos

**Decisión:** Agregar `hidden = true` y `no_ignore = true` a los `defaults` de Telescope en `ui.lua`, y agregar `"--hidden"` a `vimgrep_arguments`.

**Razón:**
- `defaults` aplica a TODOS los pickers de Telescope (`find_files`, `buffers`, `oldfiles`, etc.) — es la configuración más limpia y no requiere modificar cada wrapper en `jasper/telescope.lua`
- `vimgrep_arguments` controla los argumentos de `rg` en `live_grep` — sin `--hidden`, `live_grep` seguiría ignorando dotfiles
- `<leader>fa` ya tenía `hidden = true` explícito, pero los atajos principales (`<leader>ff`, `<leader>fg`) pasan por `jasper/telescope.lua` sin ese flag
- La alternativa (modificar cada wrapper en `telescope.lua`) es más frágil y verbosa

### 4. No crear configuración para `fd`

**Decisión:** No agregar un archivo de config global para `fd`.

**Razón:**
- `fd` no tiene un mecanismo de `FDFLAGS` o similar equivalente a `RIPGREP_CONFIG_PATH`
- Los helpers que usan `fd` (`fo`, `fa`) ya incluyen `--hidden` explícitamente
- No hay quejas de otros comandos que usen `fd`

## Risks / Trade-offs

- **[Bajo] RIPGREP_CONFIG_PATH afecta todos los proyectos**: Con `--hidden` global, `rg` buscará en `.git/` a menos que se excluya explícitamente. → Mitigación: incluir `!/.git/` en el ripgreprc y usar `.gitignore` de rg por defecto (rg ya respeta `.gitignore`).
- **[Bajo] Sobrecarga cognitiva**: Un archivo de config más en `zsh/core/config/`. → Mitigación: es un archivo de una línea, documentado.
