## ADDED Requirements

### Requirement: Templates sincronizadas al directorio de configuración de tmuxinator

Los archivos `*.yml` de template SHALL estar ubicados directamente en `~/.config/tmuxinator/`, no en un subdirectorio, para que `tmuxinator start <template>` los resuelva correctamente.

La estructura de source en el repo SHALL ser `data/sync/tmuxinator/*.yml` (sin subdirectorio `templates/`).

#### Scenario: Sync copia templates a ~/.config/tmuxinator/

- **WHEN** `tmux::sync` se ejecuta (manual o en install)
- **THEN** cada archivo `*.yml` desde `data/sync/tmuxinator/` SHALL estar presente en `~/.config/tmuxinator/`
- **AND** no SHALL haber un subdirectorio `templates/` intermedio

### Requirement: Manual sync siempre funciona

La función `tmux::sync` SHALL permanecer invocable como API pública y SHALL ejecutarse incondicionalmente cuando se llama directamente.

#### Scenario: Manual sync

- **WHEN** un usuario ejecuta `tmux::sync` directamente
- **THEN** el sync completo (conf + sync) SHALL ejecutarse
- **AND** las templates SHALL estar en `~/.config/tmuxinator/` (path correcto)

### Requirement: TMUXINATOR_TEMPLATE_PATH apunta a la nueva ubicación

La variable `TMUXINATOR_TEMPLATE_PATH` SHALL ser `${HOME_CONFIG_PATH}/tmuxinator` para que `tx::internal::list_templates` liste las templates desde el directorio correcto.

#### Scenario: TMUXINATOR_TEMPLATE_PATH actualizado

- **WHEN** el módulo tmux carga
- **THEN** `TMUXINATOR_TEMPLATE_PATH` SHALL ser `~/.config/tmuxinator`
- **AND** `tx::internal::list_templates` SHALL listar los archivos `*.yml` de ese directorio
