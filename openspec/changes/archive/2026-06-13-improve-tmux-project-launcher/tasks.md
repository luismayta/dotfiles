## 1. Validación de directorio de templates

- [x] 1.1 Agregar verificación de `TMUXINATOR_TEMPLATE_PATH` al inicio de `tx::project`
- [x] 1.2 Mostrar mensaje de error con `message_error` si el directorio no existe y retornar 1

## 2. Template discovery con glob + fd

- [x] 2.1 Reemplazar `find + while read` por glob expansion nativa `"${TMUXINATOR_TEMPLATE_PATH}"/*.yml`
- [x] 2.2 Agregar fallback opcional a `fd -e yml . "${TMUXINATOR_TEMPLATE_PATH}"` cuando esté disponible

## 3. Preview en fzf

- [x] 3.1 Agregar `--preview` con `bat --language=yaml --color=always {}` y fallback a `cat -n {}`
- [x] 3.2 Verificar que el preview funcione con archivos YAML de los templates existentes

## 4. Sanitización del nombre del proyecto

- [x] 4.1 Implementar sanitización con `sed`: caracteres especiales → `_`, colapsar duplicados, limpiar bordes
- [x] 4.2 Usar el nombre sanitizado para todas las operaciones posteriores (verificación y start)

## 5. Detección de sesión duplicada

- [x] 5.1 Verificar con `tmux has-session -t "${project_name}" 2>/dev/null` antes de ejecutar `tmuxinator start`
- [x] 5.2 Si la sesión existe, mostrar advertencia y ofrecer attach (vía `tmux attach-session -t "${project_name}"`)

## 6. Manejo de errores de tmuxinator start

- [x] 6.1 Capturar código de salida de `tmuxinator start`
- [x] 6.2 Mostrar mensaje de error con `message_error` si falla, mensaje de éxito si completa
