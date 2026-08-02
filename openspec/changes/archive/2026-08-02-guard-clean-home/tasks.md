## 1. Núcleo de limpieza

- [x] 1.1 En `zsh/modules/clean/internal/base.zsh`, añadir helper `_cleanup::guard_home`: aborta (return 1) si `$PWD == $HOME`, con warning claro; `CLEAN_FORCE=true` lo omite con warning prominente
- [x] 1.2 En `_cleanup::safe_find_delete`, añadir confirmación tras el dry-run: `needs_confirmation` → `_cleanup::confirm` con el patrón; declinado → `return 0` sin borrar

## 2. Orquestación

- [x] 2.1 En `zsh/modules/clean/pkg/base.zsh`, invocar `_cleanup::guard_home || return 1` al inicio de `cleanup`
- [x] 2.2 Invocar el guard también en `cleanup::all` (fase árbol) y en `cleanup::projects` tras `cd "${PROJECTS}"`
- [x] 2.3 Actualizar `cleanup::help`: documentar el guard de `$HOME`, el override `CLEAN_FORCE=true`, y que la limpieza de archivos por patrón confirma por defecto

## 3. Verificación

- [x] 3.1 `zsh -n` en `internal/base.zsh` y `pkg/base.zsh`
- [x] 3.2 Desde `$HOME` (dry-run): `cleanup` aborta con warning; `cleanup::all` omite la fase árbol; `CLEAN_FORCE=true cleanup` advierte y procede
- [x] 3.3 Desde directorio de proyecto (dry-run): `cleanup` listo los matches de árbol normalmente (archivos incluidos), sin tocar caches de `$HOME`
- [x] 3.4 Confirmar que archivos por patrón (`*.log`, `.DS_Store`) piden confirmación sin `CLEAN_FORCE` y se omiten al declinar
- [x] 3.5 `cleanup::help` sale sin error y documenta el guard
