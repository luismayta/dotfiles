## Why

La configuración actual de tmux tiene un soporte limitado para copiar contenido de paneles, especialmente en Linux. En macOS existe una integración completa con `pbcopy`/`pbpaste` y OSC 52, mientras que Linux solo incluye bindings básicos con `xclip`/`wl-copy`. Esto hace que tareas frecuentes como copiar texto de la terminal, seleccionar con el mouse, o pegar desde el portapapeles del sistema sean tediosas. Además, faltan atajos para navegación rápida y gestión de sesiones que optimicen el día a día.

## What Changes

### Presente en macOS pero AUSENTE en Linux
- **OSC 52 clipboard passthrough**: Habilitar `set-clipboard external` para copiar desde sesiones SSH/remotas
- **Copy-mode mouse integration**: `MouseDragEnd1Pane` y `DoubleClick1Pane` para copiar con selección de mouse
- **Buffer-to-clipboard**: `prefix C-c` para copiar el buffer de tmux al portapapeles del sistema
- **System paste into tmux**: `prefix C-v` y `prefix P` para pegar desde clipboard del sistema
- **Enter key copy**: `Enter` en copy-mode también debe copiar al portapapeles

### Nuevas capacidades para AMBAS plataformas
- **Pane navigation improvements**: Atajos para moverse entre panes más rápido (ALT + arrows, números)
- **Quick copy shortcuts**: Copiar ruta actual del panel, copiar output seleccionado sin entrar a copy-mode
- **Session/window management**: Mejoras a `ftm`/`ftmk`, renombrar ventanas rápido, navegación numérica de ventanas
- **Resize mode**: Mejorar el resize interactivo de paneles

## Capabilities

### New Capabilities
- `clipboard-linux`: Integración completa de portapapeles del sistema para Linux (OSC 52, mouse, buffer copy/paste, atajos)
- `pane-navigation`: Atajos mejorados para navegar entre panes y ventanas (ALT+dirección, números, saltos rápidos)
- `quick-actions`: Acciones rápidas desde el panel sin entrar a copy-mode (copiar ruta, copiar output, toggle sincronización)
- `session-management`: Mejoras a la gestión de sesiones (ftm/ftmk inline, renombrar rápido, navegación de ventanas)

### Modified Capabilities
- *(Ninguna — no hay specs existentes en openspec/specs/)*

## Impact

- **Archivos afectados:**
  - `zsh/modules/tmux/data/sync/tmux/linux.conf` — clipboard overhaul
  - `zsh/modules/tmux/data/conf/.tmux.conf` — nuevos bindings y opciones
  - `zsh/modules/tmux/pkg/helper.zsh` — nuevas funciones helper
  - `zsh/modules/tmux/internal/base.zsh` — nuevas funciones internas (opcional)
- **Nuevos archivos:** Ninguno — todo es modificación de los existentes
- **Plugins:** Se mantienen los actuales. No se agregan ni quitan dependencias
- **Riesgo bajo:** Los cambios son aditivos (nuevos bindings/funciones), no rompen bindings existentes
- **Plataformas:** Linux como target principal; macOS mantiene su funcionalidad actual
