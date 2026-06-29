## ADDED Requirements

### Requirement: Telescope defaults incluyen archivos ocultos

Telescope SHALL tener `hidden = true` y `no_ignore = true` configurados en sus `defaults` para que todos los pickers basados en archivos muestren dotfiles sin necesidad de flags explícitos por atajo.

#### Scenario: find_files muestra dotfiles con <leader>ff
- **WHEN** se ejecuta `<leader>ff` (find_files) en un proyecto con `.pre-commit-config.yaml`
- **THEN** el archivo `.pre-commit-config.yaml` aparece en los resultados

#### Scenario: No se necesita flag explícito por picker
- **WHEN** se usa cualquier wrapper de `jasper/telescope.lua` que use `find_files`
- **THEN** los archivos ocultos SHALL ser visibles sin modificar los wrappers individuales

### Requirement: live_grep busca en archivos ocultos

Los argumentos de `rg` para `live_grep` SHALL incluir `--hidden` para que las búsquedas de texto atraviesen archivos ocultos.

#### Scenario: live_grep encuentra texto en dotfiles
- **WHEN** se ejecuta `<leader>fg` (live_grep) buscando un término presente en `.pre-commit-config.yaml`
- **THEN** los resultados incluyen coincidencias dentro de `.pre-commit-config.yaml`

#### Scenario: vimgrep_arguments configurado
- **WHEN** se inspecciona la configuración de Telescope
- **THEN** `vimgrep_arguments` SHALL contener `--hidden` además de los argumentos por defecto
