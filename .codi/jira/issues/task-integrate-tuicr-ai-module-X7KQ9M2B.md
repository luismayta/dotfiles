# Task: Integrar tuicr como tool en el módulo ai

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Integrar tuicr (code review TUI) como tool gestionada en el módulo ai
- component: DevOps
- labels: [ai-module, tuicr, tool-integration, code-review]
- parentEpic:
- issueKey: RD-179
- jpdSource:

## Scenario

El módulo ai gestiona herramientas AI con una arquitectura de 3 capas (config/internal/pkg). [tuicr](https://github.com/agavra/tuicr) es un code review TUI en Rust con vim keybindings que permite revisar diffs, comentar inline, y exportar reviews a GitHub/GitLab/Gitea/Bitbucket/Azure DevOps/Gerrit. Se necesita integrar tuicr siguiendo el patrón establecido por hunk y las demás tools del módulo.

### Acceptance Tests

1. **Config layer** — `zsh/modules/ai/config/tuicr.zsh`:
   - Shebang `#!/usr/bin/env ksh`
   - `ZSH_AI_TUICR_BIN_PATH` apunta a `${HOME}/.local/bin`
   - `ZSH_AI_TUICR_CONFIG_PATH` apunta a `${HOME}/.config/tuicr`
   - Todas las variables usan prefijo `ZSH_AI_TUICR_`

2. **Internal layer** — `zsh/modules/ai/internal/tuicr.zsh`:
   - Shebang `#!/usr/bin/env ksh`
   - `ai::internal::tuicr::load` verifica `core::exists tuicr` antes de añadir a PATH
   - `ai::internal::tuicr::install` instala tuicr via `cargo install tuicr`
   - Verifica que cargo esté disponible antes de instalar
   - Usa `message_info` / `message_success` para feedback
   - Namespace `ai::internal::tuicr::`
   - `load` se invoca al final del archivo

3. **Public layer** — `zsh/modules/ai/pkg/tuicr.zsh`:
   - Shebang `#!/usr/bin/env ksh`
   - `ai::tuicr::install` delega a `ai::internal::tuicr::install`
   - `ai::tuicr::review` ejecuta `tuicr "${@}"`
   - `ai::tuicr::pr` ejecuta `tuicr pr "${@}"`
   - `ai::tuicr::config::sync` copia `data/tuicr/config.toml` a `~/.config/tuicr/`
   - `ai::tuicr::post_install` muestra guidance post-instalación
   - Namespace `ai::tuicr::`

4. **Data layer** — `zsh/modules/ai/data/tuicr/config.toml`:
   - Directorio `data/tuicr/` existe
   - `config.toml` es TOML válido con theme (catppuccin-mocha) y keybindings vim

5. **Module registration**:
   - `config/base.zsh`: source de `config/tuicr.zsh` + `tuicr` en array `ZSH_AI_TOOLS`
   - `internal/main.zsh`: source de `internal/tuicr.zsh` + invocación `ai::internal::tuicr::load`
   - `pkg/main.zsh`: source de `pkg/tuicr.zsh`
   - Módulo carga sin errores: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh`

### Sources

- https://github.com/agavra/tuicr
- https://tuicr.dev
- https://github.com/agavra/tuicr/blob/main/docs/CONFIG.md
- `docs/guides/implement-tool-in-module.md`
- `zsh/modules/ai/config/hunk.zsh` / `internal/hunk.zsh` / `pkg/hunk.zsh` (referencia de patrón)
- `zsh/modules/ai/data/hunk/config.toml` (referencia de config)
- https://github.com/CodipLab/dotfiles.git
