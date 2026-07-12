## Context

El módulo `herdr` sigue la misma arquitectura en capas que `tmux`: `config/` → `internal/` → `pkg/` → `data/`. Actualmente `herdr` tiene stubs vacíos en `pkg/alias.zsh`, `pkg/linux.zsh`, `pkg/osx.zsh`, `internal/linux.zsh`, `internal/osx.zsh`, `config/linux.zsh`, y `config/osx.zsh`. El módulo `tmux` tiene implementaciones completas de sesión interactiva (fzf), lanzador de proyectos, helpers de edición, y helpers OS-specific que siguen el mismo patrón arquitectónico.

Se portarán las funcionalidades relevantes de `tmux` a `herdr`, adaptando la semántica de tmux (sesiones, panes, tmuxinator) a la de herdr (workspaces, panes, proyectos).

## Goals / Non-Goals

**Goals:**
- Portar `ftm`/`ftmk` (session picker/killer) como `hrd`/`hrdk` para workspaces de herdr
- Portar `tx::project` (project launcher) como `hrd::project` para herdr
- Portar plantillas tmuxinator como configuraciones/proyectos de herdr
- Portar `edittmux` como helper de edición de config de herdr
- Activar stubs OS-specific con utilidades de clipboard y entorno
- Mantener compatibilidad total con API pública existente (`herdr::install`, `herdr::sync`, `herdr::setup`)

**Non-Goals:**
- Modificar el módulo `tmux` existente
- Cambiar el schema de datos de herdr (config.toml existente)
- Migrar datos de usuario entre tmux y herdr
- Soportar todos los comandos de tmux en herdr (solo los de productividad enumerados)

## Decisions

1. **Namespace `hrd::` para comandos equivalentes a `ftm`/`ftmk`**
   - *Por qué*: `ftm` es específico de tmux ("fuzzy tmux"). Para herdr usaremos `hrd` ("herdr fuzzy workspace" o simplemente "herrd"). Los comandos serán `hrd` (switch/create workspace) y `hrdk` (kill workspace).
   - *Alternativa considerada*: `hrdw` — demasiado críptico.

2. **Namespace `hrd::` para project launcher**
   - *Por qué*: Consistencia con el nuevo namespace. `hrd::project` sigue el mismo patrón que `tx::project`. Internamente usará `hrd::internal::*` heredado de `tx::internal::*`.

3. **Templates como directorios de proyecto herdr en `data/projects/`**
   - *Por qué*: herdr no usa tmuxinator. En lugar de YAML, crearemos configuraciones de workspace/proyecto que herdr pueda consumir. Siguiendo la [documentación de herdr](https://herdr.dev), los proyectos se definen como configuraciones de workspace.

4. **Helper `edit-herdr-config` como función pública**
   - *Por qué*: Sigue el patrón de `edittmux`. Abre `$HERDR_CONFIG_PATH/config.toml` en `$EDITOR`. Simple, directo, sin dependencias adicionales.

5. **OS-specific helpers en `internal/` y `pkg/`**
   - *Por qué*: Consistencia arquitectónica con el módulo tmux. `internal/osx.zsh` y `internal/linux.zsh` contendrán lógica de instalación de utilidades de clipboard/herramientas. `pkg/` tendrá funciones públicas OS-specific si es necesario.

6. **Alias `hrd` para herdr en `pkg/alias.zsh`**
   - *Por qué*: Similar a `tx=tmuxinator`. Proporciona un atajo ergonómico.

## Risks / Trade-offs

| Riesgo | Mitigación |
|--------|-----------|
| [Dependencia en fzf] Si fzf no está instalado, `hrd`/`hrdk`/`hrd::project` fallan | El módulo tmux ya auto-instala fzf via `core::install` en `plugin.zsh`. Repetir el mismo patrón en herdr. |
| [Comportamiento distinto de herdr vs tmux] herdr puede no exponer las mismas APIs internas para workspace management | Investigar API de herdr (`herdr list`, `herdr switch`, `herdr kill`) antes de implementar. Si no existe CLI, usar signals/herdr config files. |
| [Ruptura de consistencia] `hrd` podría confundirse con `herdr` command | Usar `hrd` solo como función zsh interna, no como binario. Documentar claramente. |
| [Tamaño de data/] 9 project templates incrementan el módulo | Templates son archivos pequeños (~500 bytes cada uno). Impacto mínimo. |
