## 1. Config layer

- [x] 1.1 En `zsh/modules/clean/config/base.zsh`, renombrar todas las exports a `ZSH_CLEAN_*` (ENABLED, BASE_DIR_PATTERNS, BASE_FILE_PATTERNS, AGGRESSIVE_PATTERNS, PACKAGE_NAME, MESSAGE_NOT_IMPLEMENTED, 10× BASE_CACHE_*)
- [x] 1.2 Añadir bloque de alias backward-compat tras cada export pública: `export CLEAN_X="${ZSH_CLEAN_X}"` con comentario "remove in next cleanup cycle" (patrón herdr)
- [x] 1.3 En `zsh/modules/clean/config/linux.zsh`, renombrar las 16 `CLEAN_LINUX_*` → `ZSH_CLEAN_LINUX_*` + alias
- [x] 1.4 En `zsh/modules/clean/config/osx.zsh`, renombrar las 9 `CLEAN_OSX_*` → `ZSH_CLEAN_OSX_*` + alias

## 2. Internal + entry point

- [x] 2.1 En `zsh/modules/clean/internal/base.zsh:5-8`, renombrar flags `CLEAN_DRY_RUN/CONFIRM/VERBOSE/FORCE` → `ZSH_CLEAN_*` + alias; actualizar TODOS los usos internos de `CLEAN_*` → `ZSH_CLEAN_*` (helpers y `_cleanup::unnecessary`)
- [x] 2.2 En `zsh/modules/clean/plugin.zsh`, renombrar `CLEAN_PATH` → `ZSH_CLEAN_PATH="${0:A:h}"` (sin alias, 0 refs externas) y actualizar los source paths

## 3. Public layer

- [x] 3.1 En `zsh/modules/clean/pkg/base.zsh`, actualizar todos los usos de `CLEAN_*` → `ZSH_CLEAN_*` (funciones de cache, `cleanup::all`, pyenv, `cleanup::help`)
- [x] 3.2 Verificar que `cleanup::help` documenta los nombres canónicos `ZSH_CLEAN_*` (y menciona el alias legacy `CLEAN_*` como fallback)

## 4. Specs del cambio

- [x] 4.1 Actualizar `openspec/specs/cleanup-configurability/spec.md` (activo): `CLEAN_*` → `ZSH_CLEAN_*` con nota de alias legacy (delta spec incluido en este change)
- [x] 4.2 NO tocar `openspec/changes/archive/` ni referencias históricas (convención)

## 5. Verificación

- [x] 5.1 `zsh -n` en los archivos tocados (config, internal, pkg, plugin)
- [x] 5.2 `CLEAN_DRY_RUN=true cleanup` en árbol de prueba: funciona con los nombres nuevos
- [x] 5.3 Confirmar que el patrón `unset CLEAN_BASE_DIR_PATTERNS CLEAN_BASE_FILE_PATTERNS && exec zsh` del historial sigue funcionando (alias re-exporta el default bajo `ZSH_CLEAN_*`)
- [x] 5.4 Confirmar que las 13 vars `CLEAN_*` del entorno siguen visibles tras reload vía alias, y que `CLEAN_DRY_RUN=true` (legacy) activa dry-run
- [x] 5.5 `cleanup::help` sale sin error
