## ADDED Requirements

### Requirement: Helper fgr incluye archivos ocultos

El helper `fgr` (grep via rg para fzf) SHALL incluir archivos ocultos en los resultados de búsqueda, consistente con los helpers `fo` y `fa`.

#### Scenario: fgr busca en dotfiles
- **WHEN** se ejecuta `fgr "pattern"` en un directorio con archivos `.stylua.toml`
- **THEN** los resultados incluyen coincidencias dentro de `.stylua.toml`

#### Scenario: fgr funcional sin RIPGREP_CONFIG_PATH
- **WHEN** `RIPGREP_CONFIG_PATH` no está configurada
- **THEN** `fgr` SHALL aún así incluir archivos ocultos mediante flag explícito

### Requirement: Consistencia entre helpers fzf

Todos los helpers de fzf que usen `rg` o `fd` SHALL tener comportamiento consistente respecto a archivos ocultos.

#### Scenario: Comportamiento uniforme
- **WHEN** se compara `fo` (fd), `fa` (fd) y `fgr` (rg)
- **THEN** todos los helpers SHALL incluir archivos ocultos en sus resultados
