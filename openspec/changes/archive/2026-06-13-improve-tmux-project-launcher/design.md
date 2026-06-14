## Context

`tx::project` en `zsh/modules/tmux/pkg/helper.zsh` (líneas 14-38) es el punto de entrada interactivo para crear proyectos tmuxinator. Actualmente:

- Usa `find` para listar templates (funcional pero más lento que glob)
- Sin preview del template durante la selección con fzf
- No verifica si el directorio de templates existe
- No verifica si la sesión tmux ya existe (crea duplicados)
- No sanitiza el nombre del proyecto
- No captura errores de `tmuxinator start`

## Goals / Non-Goals

**Goals:**
- Agregar `--preview` a fzf mostrando el contenido YAML del template seleccionado
- Validar que `TMUXINATOR_TEMPLATE_PATH` existe antes de buscar templates
- Detectar sesión tmux existente con el mismo nombre y ofrecer attach
- Sanitizar nombre del proyecto (reemplazar espacios y caracteres especiales)
- Capturar y mostrar código de error de `tmuxinator start`
- Usar glob expansion (`${TMUXINATOR_TEMPLATE_PATH}/*.yml` ) con fallback a `fd` cuando esté disponible

**Non-Goals:**
- No cambiar la firma de la función (`tx::project [name]`)
- No modificar otros helpers (ftm, ftmk, edittmux)
- No agregar nuevas dependencias externas
- No modificar el sistema de templates tmuxinator

## Decisions

| Decisión | Opción | Rationale |
|----------|--------|-----------|
| Template discovery | Glob `"${TMUXINATOR_TEMPLATE_PATH}"/*.yml` nativo | Más simple y rápido que `find`; no requiere sub-shell. Si `fd` está disponible, usar `fd -e yml . "${TMUXINATOR_TEMPLATE_PATH}"` para orden natural |
| Preview en fzf | `--preview 'bat -l yaml --color=always {}'` con fallback a `cat` | `bat` da resaltado de sintaxis YAML; si no existe, `cat -n` como fallback |
| Sesión duplicada | `tmux has-session -t "${project_name}" 2>/dev/null` | Comando nativo de tmux para verificar existencia; si existe, preguntar con `confirm` de fzf o mensaje para attach |
| Sanitización | `sed 's/[^a-zA-Z0-9_-]/_/g; s/__*/_/g; s/^_//; s/_$//'` | Reemplazar espacios y caracteres especiales con `_`; evitar duplicados; limpiar bordes |
| Manejo de errores | Capturar `$?` de `tmuxinator start` y mostrar mensaje según código | Usar `message_error` si falla, manteniendo consistencia con el módulo |

## Risks / Trade-offs

- **[Dependencia bat]**: `bat` puede no estar instalado — mitigación: fallback a `cat -n`
- **[fd no instalado]**: `fd` acelera la búsqueda pero no es crítico — mitigación: glob nativo como default
- **[Nombre sanitizado]**: La sanitización podría cambiar el nombre esperado — mitigación: mostrar el nombre sanitizado antes de crear
- **[tmuxinator start falla silenciosamente]**: Capturamos el código de error y mostramos mensaje — riesgo bajo
