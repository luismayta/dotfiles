## 1. Expresión combinada y helpers (internal/base.zsh)

- [x] 1.1 Refactorizar `_cleanup::safe_find_remove` para aceptar un array de patrones y construir la expresión `find` combinada con `-o` (array sin eval), con agrupación `\( ... \)` cuando hay más de un patrón, manteniendo `-type d` y `-exec rm -rf {} +`
- [x] 1.2 Refactorizar `_cleanup::safe_find_delete` de forma análoga para files, con `-delete` y sin `-type`
- [x] 1.3 Añadir helper interno de dedupe de patrones (preservando orden) para que la expresión no contenga términos duplicados
- [x] 1.4 Añadir helper que derive los grupos afectados desde el listado: basenames únicos y `[[ "${basenames[(I)${pattern}]}" -gt 0 ]]` para detectar qué patrones tienen matches

## 2. Orquestación consolidada (`_cleanup::unnecessary`)

- [x] 2.1 Unificar el merge de patrones de directorios (`ZSH_CLEAN_BASE_DIR_PATTERNS|ZSH_CLEAN_AGGRESSIVE_PATTERNS|ZSH_CLEAN_USER_DIR_PATTERNS`) con dedupe, en un solo paso
- [x] 2.2 Unificar el merge de patrones de archivos (`ZSH_CLEAN_BASE_FILE_PATTERNS|ZSH_CLEAN_USER_FILE_PATTERNS`) con dedupe
- [x] 2.3 Ejecutar una sola pasada de listado por sweep (dirs y files) que pueble un array zsh (`${(@f)...}`) y calcule el total
- [x] 2.4 Mostrar un único prompt consolidado por sweep con el total de items y los grupos afectados (ej. "Remove 37 items (dirs) matching: node_modules, .next, __pycache__?")
- [x] 2.5 Ejecutar el borrado con el `find` combinado (dirs: `-exec rm -rf {} +`; files: `-delete`) tras la confirmación
- [x] 2.6 Mantener el modo dry-run: listar los items que se borrarían agrupados por patrón, sin ejecutar ninguna acción destructiva
- [x] 2.7 Conservar los mensajes verbose de éxito y el comportamiento de `ZSH_CLEAN_FORCE` / `ZSH_CLEAN_CONFIRM=false` / `guard_home` intactos

## 3. Verificación y documentación

- [x] 3.1 Validar con fixtures (node_modules, .next, __pycache__, *.log, CMakeFiles, cmake-build-*) usando `ZSH_CLEAN_DRY_RUN=true zsh -c 'cleanup'` y comparar el conjunto de rutas contra el comportamiento actual
- [x] 3.2 Validar los modos `ZSH_CLEAN_FORCE=true`, `ZSH_CLEAN_CONFIRM=false` y el guard de `$HOME` (debe seguir abortando con mensaje)
- [x] 3.3 Actualizar `README.yaml` (y regenerar `README.md` con `task readme` si aplica) para describir el flujo de confirmación consolidada por sweep
- [x] 3.4 Ejecutar lint/shellcheck de los archivos modificados si la toolchain del repo lo tiene disponible
