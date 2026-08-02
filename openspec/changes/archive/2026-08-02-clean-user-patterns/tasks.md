## 1. Config layer

- [x] 1.1 En `zsh/modules/clean/config/base.zsh`, añadir unset anti-stale ANTES de las guardas: `unset ZSH_CLEAN_BASE_DIR_PATTERNS ZSH_CLEAN_BASE_FILE_PATTERNS ZSH_CLEAN_AGGRESSIVE_PATTERNS` (comentado: "re-derive defaults every load")
- [x] 1.2 Añadir `export ZSH_CLEAN_USER_DIR_PATTERNS="${ZSH_CLEAN_USER_DIR_PATTERNS:-}"` y `export ZSH_CLEAN_USER_FILE_PATTERNS="${ZSH_CLEAN_USER_FILE_PATTERNS:-}"` (default vacío, sin unset)
- [x] 1.3 Verificar que el unset NO toca `CLEAN_*` legacy ni `ZSH_CLEAN_BASE_CACHE_*` ni flags

## 2. Núcleo de limpieza

- [x] 2.1 En `_cleanup::unnecessary` (internal/base.zsh), fusionar defaults + user: dirs = `ZSH_CLEAN_BASE_DIR_PATTERNS|ZSH_CLEAN_AGGRESSIVE_PATTERNS|ZSH_CLEAN_USER_DIR_PATTERNS`; files = `ZSH_CLEAN_BASE_FILE_PATTERNS|ZSH_CLEAN_USER_FILE_PATTERNS` (filtro `[[ -n ]]` existente preservado)

## 3. Documentación

- [x] 3.1 En `cleanup::help` (pkg/base.zsh), documentar `ZSH_CLEAN_USER_DIR_PATTERNS`/`ZSH_CLEAN_USER_FILE_PATTERNS` con ejemplo, y nota de que los defaults se re-derivan en cada carga (anti-stale)

## 4. Verificación

- [x] 4.1 `zsh -n` en config/base.zsh, internal/base.zsh, pkg/base.zsh
- [x] 4.2 Dry-run en árbol de prueba sin user patterns: solo defaults del repo (45 dirs / 10 files)
- [x] 4.3 Dry-run con `ZSH_CLEAN_USER_DIR_PATTERNS="my_build|my_tmp"` seteadas: se listan los patrones user junto a los defaults, sin duplicados
- [x] 4.4 Simular stale: export `ZSH_CLEAN_BASE_DIR_PATTERNS` con valor viejo antes de cargar → tras cargar, la lista efectiva es la default del repo (la stale no persiste)
- [x] 4.5 `CLEAN_DRY_RUN=true` (legacy alias) sigue activando dry-run; `CLEAN_BASE_DIR_PATTERNS` legacy exportada sigue visible vía alias
- [x] 4.6 `cleanup::help` sale sin error y documenta `ZSH_CLEAN_USER_*`
