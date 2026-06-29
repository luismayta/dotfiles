## ADDED Requirements

### Requirement: ripgrep incluye archivos ocultos por defecto

El sistema SHALL configurar ripgrep para que incluya archivos ocultos (que inician con `.`) en todas las búsquedas, sin requerir el flag `--hidden` en cada invocación.

#### Scenario: Búsqueda incluye dotfiles
- **WHEN** se ejecuta `rg "pattern"` en un directorio con archivos `.stylua.toml`
- **THEN** los resultados incluyen coincidencias dentro de `.stylua.toml`

#### Scenario: Búsqueda excluye `.git/` por defecto
- **WHEN** se ejecuta `rg "pattern"` en un repositorio git
- **THEN** los archivos dentro de `.git/` NO aparecen en los resultados

#### Scenario: Config persistente entre sesiones
- **WHEN** se abre una nueva shell que carga el perfil zsh del dotfiles
- **THEN** `rg` SHALL respetar la configuración de archivos ocultos sin flags adicionales

### Requirement: Configuración trackeada en el repositorio

El sistema SHALL almacenar la configuración de ripgrep dentro del repositorio de dotfiles, no en archivos fuera del repo como `~/.ripgreprc`.

#### Scenario: Config versionada
- **WHEN** se clona el dotfiles en un nuevo entorno
- **THEN** la configuración de ripgrep SHALL estar disponible sin configuración manual adicional

#### Scenario: RUTA de config expuesta como env var
- **WHEN** se carga el perfil zsh del dotfiles
- **THEN** la variable `RIPGREP_CONFIG_PATH` SHALL estar exportada apuntando al archivo de configuración dentro del repo
