## ADDED Requirements

### Requirement: Validar directorio de templates

El sistema SHALL validar que `TMUXINATOR_TEMPLATE_PATH` existe antes de listar templates. Si no existe, SHALL mostrar un mensaje de error y retornar 1.

#### Scenario: Directorio de templates no existe

- **WHEN** `TMUXINATOR_TEMPLATE_PATH` apunta a un directorio inexistente
- **THEN** la función muestra un mensaje de error claro indicando la ruta faltante y retorna 1

### Requirement: Preview del template en fzf

El sistema SHALL mostrar una vista previa del contenido YAML del template seleccionado durante la selección con fzf, usando `bat --language=yaml` si está disponible, con fallback a `cat -n`.

#### Scenario: Selección con preview

- **WHEN** el usuario navega por los templates en fzf
- **THEN** el panel de preview muestra el contenido del template YAML resaltado con sintaxis

#### Scenario: bat no instalado

- **WHEN** `bat` no está disponible en el sistema
- **THEN** el preview usa `cat -n` como fallback sin resaltado de sintaxis

### Requirement: Detectar sesión tmux duplicada

El sistema SHALL verificar si ya existe una sesión tmux con el nombre del proyecto antes de ejecutar `tmuxinator start`. Si existe, SHALL ofrecer al usuario la opción de attacharse a la sesión existente.

#### Scenario: Sesión ya existe

- **WHEN** una sesión tmux con el nombre del proyecto ya existe
- **THEN** la función muestra una advertencia y pregunta si quiere attacharse (vía fzf `--bind` o mensaje)

#### Scenario: Sesión no existe

- **WHEN** no existe una sesión tmux con el nombre del proyecto
- **THEN** la función procede normalmente con `tmuxinator start`

### Requirement: Sanitizar nombre del proyecto

El sistema SHALL sanitizar el nombre del proyecto derivado de `$(basename "$PWD")` reemplazando caracteres no alfanuméricos (excepto `-` y `_`) con `_`, colapsando múltiples `_` consecutivos y limpiando bordes.

#### Scenario: Nombre con espacios

- **WHEN** el directorio actual se llama "my project (2024)"
- **THEN** el nombre sanitizado es "my_project_2024"

#### Scenario: Nombre sin sanitización necesaria

- **WHEN** el directorio actual se llama "my-project"
- **THEN** el nombre se mantiene igual ("my-project")

### Requirement: Manejo de errores de tmuxinator start

El sistema SHALL capturar el código de salida de `tmuxinator start` y mostrar un mensaje de error si falla.

#### Scenario: tmuxinator start falla

- **WHEN** `tmuxinator start` retorna un código de salida distinto de 0
- **THEN** la función muestra un mensaje de error con el código de salida

#### Scenario: tmuxinator start exitoso

- **WHEN** `tmuxinator start` retorna 0
- **THEN** la función muestra un mensaje de éxito
