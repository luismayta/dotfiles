## Why

`tx::project` en `zsh/modules/tmux/pkg/helper.zsh` es el lanzador interactivo de proyectos tmuxinator, pero tiene carencias: no valida que el directorio de templates exista, no ofrece preview del template seleccionado, no verifica si la sesión ya existe para re-attach, no sanitiza el nombre del proyecto, y no maneja errores de `tmuxinator start`. Esto causa fricción al crear proyectos tmuxinator.

## What Changes

- **Validación de directorio**: Verificar que `TMUXINATOR_TEMPLATE_PATH` existe antes de buscar templates, con mensaje claro si falta
- **Preview en fzf**: Agregar `--preview` para mostrar el contenido del template YAML seleccionado
- **Verificación de sesión existente**: Antes de lanzar `tmuxinator start`, verificar si ya existe una sesión con ese nombre y ofrecer attach
- **Sanitización del nombre del proyecto**: Limpiar el nombre derivado de `$(basename "$PWD")` (reemplazar espacios, caracteres especiales)
- **Manejo de errores**: Capturar el código de salida de `tmuxinator start` y mostrar mensaje apropiado
- **Template discovery**: Reemplazar `while read + find` con glob expansion directa (`${TMUXINATOR_TEMPLATE_PATH}/*.yml`) y opcionalmente usar `fd` si está disponible para mejor performance

## Capabilities

### New Capabilities
- `tmux-project-launcher`: Comportamiento mejorado de `tx::project` con validación, preview, re-attach, sanitización y manejo de errores

### Modified Capabilities
*(None — no existing tmux specs)*

## Impact

- **Archivo afectado**: `zsh/modules/tmux/pkg/helper.zsh` (solo función `tx::project`)
- **Alcance**: Solo el flujo interactivo de lanzamiento de proyectos tmuxinator
- **Riesgo**: Bajo — cambios encapsulados en una sola función; la API pública (`tx::project [name]`) no cambia
- **Compatibilidad**: Total — argumentos de entrada y comportamiento esperado se mantienen
