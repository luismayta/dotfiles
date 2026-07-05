## Why

El módulo `herdr` es un gestor para el multiplexor de terminal [herdr](https://herdr.dev), pero actualmente carece de varias capacidades de productividad que ya existen en el módulo `tmux`: navegación interactiva de sesiones/workspaces vía fzf, lanzador de proyectos con templates, helpers rápidos de edición, y soporte OS-specific. Portar estas funcionalidades consolida la experiencia de usuario en el ecosistema dotfiles, reduce duplicación de lógica, y permite a los usuarios de herdr tener la misma fluidez que en tmux.

## What Changes

1. **Nuevo: fzf workspace picker** — Portar `ftm`/`ftmk` del módulo tmux como `hrd`/`hrdk`: navegación y eliminación interactiva de workspaces de herdr mediante fzf
2. **Nuevo: Project launcher** — Portar `tx::project` como `hrd::project`: lanzador interactivo de proyectos herdr usando fzf + templates
3. **Nuevo: Project templates** — Portar las 9 plantillas tmuxinator (android, cloud, default, docker, go, java, nodejs, python, rust) como configuraciones de workspace de herdr
4. **Nuevo: Config editor helper** — Portar `edittmux` como `edit-herdr-config`: atajo para editar la configuración de herdr
5. **Mejora: Helpers OS-specific** — Activar los stubs OS-specific (linux/macOS) con lógica de portapapeles y utilidades de terminal, siguiendo el patrón del módulo tmux
6. **Mejora: Aliases** — Poblar `pkg/alias.zsh` con aliases útiles (e.g., `hrd` para herdr, etc.)

## Capabilities

### New Capabilities
- `fzf-workspace-picker`: Navegación y eliminación interactiva de workspaces/panes de herdr mediante fzf
- `project-launcher`: Lanzador interactivo de proyectos con selección vía fzf y templates predefinidos
- `project-templates`: Colección de templates de workspace para entornos de desarrollo (android, cloud, docker, go, java, nodejs, python, rust)
- `config-editor`: Helper rápido para editar archivos de configuración de herdr
- `os-specific-helpers`: Utilidades OS-specific (clipboard Linux/macOS) siguiendo el patrón de arquitectura del módulo

### Modified Capabilities
- *(ninguna — es la primera vez que se definen specs para herdr)*

## Impact

- **Módulo `herdr`**: nuevos archivos en `pkg/` (helper functions), `internal/` (implementación), `data/` (templates), y `config/` (OS-specific)
- **Dependencias**: `fzf` (ya gestionado por el framework `core::install`), `rsync` (ya existente)
- **No breaking changes**: todo el API público existente (`herdr::install`, `herdr::sync`, `herdr::setup`) permanece igual
- **Sin cambios en `tmux`**: el módulo tmux no se modifica
