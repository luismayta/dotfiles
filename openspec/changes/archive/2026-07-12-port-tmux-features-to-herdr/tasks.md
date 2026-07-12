## 1. Config & Infrastructure

- [x] 1.1 Add variables a `config/base.zsh` para `HERDR_WORKSPACE_PREFIX`, `HRD_PROJECT_TEMPLATE_PATH`, `ZSH_HRD_ENABLED`
- [x] 1.2 Poblar `config/linux.zsh` con defaults de herramientas Linux (xclip, wl-clipboard)
- [x] 1.3 Poblar `config/osx.zsh` con defaults de herramientas macOS (reattach-to-user-namespace)

## 2. Internal Helpers — FZF Workspace Picker

- [x] 2.1 Crear `internal/base.zsh`: implementar `hrd::internal::list_workspaces` (lista workspaces de herdr via CLI o parsing)
- [x] 2.2 Implementar `hrd::internal::workspace_exists` (verifica si un workspace existe por nombre)
- [x] 2.3 Implementar `hrd::internal::switch_workspace` (cambia a un workspace por nombre)
- [x] 2.4 Implementar `hrd::internal::kill_workspace` (mata un workspace por nombre)
- [x] 2.5 Implementar `hrd::internal::fzf_select` (wrapper fzf con preview, adaptado de `tx::internal::select_template`)

## 3. Public API — FZF Workspace Picker

- [x] 3.1 Crear `pkg/helper.zsh`: implementar `hrd` (switch workspace vía fzf, port de `ftm`)
- [x] 3.2 Implementar `hrdk` (kill workspace vía fzf, port de `ftmk`)
- [x] 3.3 Implementar `_hrd` (wrapper interno del comando herdr, similar a `_tmux`)

## 4. Internal Helpers — Project Launcher

- [x] 4.1 Crear `internal/base.zsh`: implementar `hrd::internal::derive_project_name` (port de `tx::internal::derive_project_name`)
- [x] 4.2 Implementar `hrd::internal::list_templates` (lista templates de `data/projects/`, port de `tx::internal::list_templates`)
- [x] 4.3 Implementar `hrd::internal::select_template` (selector fzf con preview, port de `tx::internal::select_template`)
- [x] 4.4 Implementar `hrd::internal::workspace_attach_or_create` (verifica si existe, attach o crea, port de `tx::internal::attach_if_exists`)

## 5. Public API — Project Launcher

- [x] 5.1 En `pkg/helper.zsh`: implementar `hrd::project` (lanzador interactivo de proyectos, port de `tx::project`)

## 6. Project Templates (herdr-plus Projects)

- [x] 6.1 Crear `data/plugins/config/cloudmanic.herdr-plus/projects/` directorio
- [x] 6.2 Crear template `projects/default.toml` (layout: editor + opencode + shell)
- [x] 6.3 Crear template `projects/android.toml`
- [x] 6.4 Crear template `projects/cloud.toml`
- [x] 6.5 Crear template `projects/docker.toml`
- [x] 6.6 Crear template `projects/go.toml` (4 panes: editor + app + opencode + shell)
- [x] 6.7 Crear template `projects/java.toml`
- [x] 6.8 Crear template `projects/nodejs.toml`
- [x] 6.9 Crear template `projects/python.toml`
- [x] 6.10 Crear template `projects/rust.toml`

## 7. Config Editor

- [x] 7.1 En `pkg/helper.zsh`: implementar `edit-herdr-config` (abre `$HERDR_CONFIG_PATH/config.toml` en `$EDITOR`)
- [x] 7.2 Implementar `edit-herdr-plugins` (abre directorio de plugins en `$EDITOR`)

## 8. OS-Specific Helpers

- [x] 8.1 Poblar `internal/linux.zsh`: instalación de xclip (X11) y wl-copy (Wayland)
- [x] 8.2 Poblar `internal/osx.zsh`: instalación de reattach-to-user-namespace
- [x] 8.3 Poblar `pkg/linux.zsh`: stub vacío (no hay funciones públicas Linux — coincide con tmux module)
- [x] 8.4 Poblar `pkg/osx.zsh`: stub vacío (no hay funciones públicas macOS — coincide con tmux module)

## 9. Aliases

- [x] 9.1 Poblar `pkg/alias.zsh`: alias `hrd` para comando herdr (similar a `tx=tmuxinator`)

## 10. Module Integration

- [x] 10.1 Actualizar `plugin.zsh`: agregar guard de auto-instalación para fzf (similar al patrón tmux)
- [x] 10.2 OS-specific tools auto-instalación manejada lazy via `hrd::internal::ensure_clipboard` (no requiere guard eager en plugin.zsh)
- [x] 10.3 Verificar que `internal/main.zsh` carga OS-specific internal stubs
- [x] 10.4 Verificar que `pkg/main.zsh` carga helper.zsh y alias.zsh
- [x] 10.5 Ejecutar `lsp_diagnostics` en todos los archivos modificados
