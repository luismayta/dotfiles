# Task: Implementar mise en el módulo devops

## Issue Metadata

- projectKey: PE
- issueType: Task
- summary: Implementar la integración de mise como tool en el módulo devops
- component: DevOps
- labels: [feature,devops]
- parentEpic: 
- issueKey: PE-661
- jpdSource: NIP-23

## Scenario

Integrar mise (https://mise.jdx.dev/) como tool del módulo `zsh/modules/devops/`, siguiendo la guía `docs/guides/implement-tool-in-module.md` y la arquitectura de tres capas del módulo (config → internal → pkg). mise es un gestor de versiones de herramientas (compatible con asdf) que aporta activation de shell (`mise activate zsh`), gestión de versiones por proyecto (.tool-versions / mise.toml) y aliases/tasks. Al proveer shell hooks, debe usar el patrón **Shell hooks** (estilo atuin: `eval "$(mise activate zsh ...)"` en `internal/`, con flags configurables vía `DEVOPS_MISE_*`). Instalación: nix preferido si aplica (`DEVOPS_MISE_NIX_PACKAGE="nixpkgs#mise"`) con fallback a `core::install`, según Step 2a de la guía. Referencias: `zsh/modules/devops/{config,internal,pkg}/atuin.zsh` (shell hooks) y `caddy.zsh` (native/nix install).

### Acceptance Tests

1. Crear `zsh/modules/devops/config/mise.zsh` con variables `DEVOPS_MISE_*` (PACKAGE_NAME, NIX_PACKAGE o INSTALL_*, CONFIG paths, INIT_FLAGS) y sin lógica de instalación.
2. Crear `zsh/modules/devops/internal/mise.zsh` con `devops::mise::internal::load`, `::install`, `::upgrade`, `::main::factory`, guard `core::exists mise` en load, y shell hook `eval "$(mise activate zsh ...)"` solo si el binario existe.
3. Crear `zsh/modules/devops/pkg/mise.zsh` con wrappers públicos `devops::mise::install`, `devops::mise::upgrade`, `devops::mise::post_install` (con guidance de primeros pasos, ej. `mise use node@latest`).
4. Registrar `mise` en el array `DEVOPS_TOOLS` de `zsh/modules/devops/config/base.zsh`.
5. Agregar las tres líneas `source` en `config/main.zsh`, `internal/main.zsh` y `pkg/main.zsh` del módulo — sin ellas el tool no carga.
6. Cumplir checklist de calidad: shebang `#!/usr/bin/env ksh`, prefijos `devops::mise::` / `devops::mise::internal::`, mensajes con `message_info`/`message_success`/`message_error` (nunca `echo`), sin rutas absolutas (usar `${HOME}`/`$DEVOPS_PATH`), sin hardcodear comandos de instalación.
7. Verificación funcional: `source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh` carga sin errores; `type devops::mise::install` devuelve `function`; si mise no está instalado, el factory lo instala automáticamente.

### Sources

- https://mise.jdx.dev/
- https://github.com/jdx/mise
- docs/guides/implement-tool-in-module.md
- zsh/modules/devops/config/atuin.zsh
- zsh/modules/devops/internal/atuin.zsh
- zsh/modules/devops/pkg/atuin.zsh
- zsh/modules/devops/config/caddy.zsh
- zsh/modules/devops/internal/caddy.zsh
- zsh/modules/devops/pkg/caddy.zsh
- https://github.com/luismayta/dotfiles.git