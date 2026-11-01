# Task: Estandarizar código shell portable para bash 3.2 (macOS) en archivos .sh y .bats

## Issue Metadata

- projectKey: PE
- issueType: Task
- summary: Reemplazar constructos bash >= 4.2 por alternativas portátiles compatibles con bash 3.2 en los scripts bash del repo.
- component: 
- labels: [shell, portability, bash32, dotfiles]
- parentEpic: 
- issueKey: PE-524
- jpdSource: 

## Scenario

En macOS el bash de sistema es 3.2. El guard de idempotencia de common/colors.sh usa `[[ -v C_RED ]]`,
que requiere bash >= 4.2, por lo que el script falla al hacer bootstrap en macOS u otros entornos con
bash antiguo. El patrón estándar portable es un test de variable con expansión por defecto:
`[ -n "${C_RED:-}" ]`. Se debe corregir este y todos los constructos no portables equivalentes en el repo.


### Acceptance Tests

1. En common/colors.sh:7 reemplazar `if [[ -v C_RED ]]; then` por `if [ -n "${C_RED:-}" ]; then`
2. En install.sh:135 reemplazar `if [[ ! -v PACKAGES_COMMON ]]; then` por `if [ -z "${PACKAGES_COMMON:-}" ]; then`
3. En install.sh:232 aplicar el mismo reemplazo que en el punto 2
4. En zsh/modules/herdr/tests/hrd_project_exit_codes.bats:70 reemplazar `${raw,,}` (requiere bash >= 4.0)
   por una alternativa portable p.ej. `$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]')`
5. Ejecutar `shellcheck` sobre los archivos modificados sin errores nuevos
6. Ejecutar la suite bats afectada para verificar que los tests siguen pasando
7. Documentar el estándar bash-3.2-portable (test de variable con `${VAR:-}`, sin `[[ -v ]]`,
   sin `${var,,}`, sin arrays asociativos) en la documentación de contribución del repo
NOTA: no tocar archivos .zsh (corren bajo zsh, sus idiomatismos son válidos) ni .direnv/ (generado)


### Sources

Escaneo del repo (2026-11-01):
- common/colors.sh:7 -> `[[ -v C_RED ]]`
- install.sh:135 -> `[[ ! -v PACKAGES_COMMON ]]`
- install.sh:232 -> `[[ ! -v PACKAGES_COMMON ]]`
- zsh/modules/herdr/tests/hrd_project_exit_codes.bats:70 -> `${raw,,}`
Shebangs afectados: `#!/usr/bin/env bash` y `#!/usr/bin/env bats`.

- https://github.com/luismayta/dotfiles.git