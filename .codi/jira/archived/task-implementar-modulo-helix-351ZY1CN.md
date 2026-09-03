# Task: Implementar módulo Helix para dotfiles

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Crear módulo ZSH helix siguiendo la guía create-module, tomando como referencia el módulo nvim
- component: 
- labels: [helix, zsh, dotfiles, module]
- parentEpic: 
- issueKey: RD-151
- jpdSource: 

## Scenario

Como desarrollador de CodipLabs, necesito un módulo ZSH para gestionar el editor Helix en mis dotfiles, siguiendo la arquitectura de tres capas (config/internal/pkg) documentada en docs/guides/create-module.md y tomando como referencia el módulo existente zsh/modules/nvim/.

El módulo debe gestionar la instalación de Helix, la sincronización de su configuración (config.toml, languages.toml, themes/) desde data/ hacia ~/.config/helix/, y exponer comandos públicos (helix::install, helix::sync, helix::setup, etc.) siguiendo las convenciones de nomenclatura ZSH_<NAME>_ y las funciones core (message_*, core::exists, core::ensure).

Helix no tiene plugin manager (a diferencia de lazy.nvim en Neovim), por lo que el módulo se enfoca en: instalación del binario hx, sync de config.toml + languages.toml + themes/, y gestión del runtime (hx --grammar fetch/build).

### Acceptance Tests

- [ ] Scaffold completo del módulo en zsh/modules/helix/ con config/, internal/, pkg/, data/
- [ ] plugin.zsh con guard idempotente __ZSH_HELIX_LOADED y cadena config → internal → pkg
- [ ] config/base.zsh exporta ZSH_HELIX_ENABLED, ZSH_HELIX_PACKAGE_NAME, ZSH_HELIX_CONFIG_PATH, ZSH_HELIX_DATA_PATH
- [ ] internal/base.zsh implementa helix::internal::install y helix::internal::sync (rsync data/ → ~/.config/helix/)
- [ ] pkg/base.zsh expone helix::install, helix::sync, helix::post_install
- [ ] pkg/helper.zsh implementa helix::setup
- [ ] README.yaml + Taskfile.yml con tarea readme, registrado en Taskfile.yml raíz como module-helix
- [ ] data/ contiene config.toml, languages.toml y themes/ (configuración real de Helix)
- [ ] Usa message_*, core::exists, core::ensure (sin echo, sin which, sin command -v)
- [ ] Módulo carga: source zsh/system/core/main.zsh && source zsh/modules/helix/plugin.zsh
- [ ] Guard previene doble carga
- [ ] type helix::install y type helix::setup responden "function"

### Sources

- https://helix-editor.com/
- https://github.com/helix-editor/helix
- docs/guides/create-module.md
- zsh/modules/nvim/ (módulo de referencia)
- https://github.com/luismayta/dotfiles.git