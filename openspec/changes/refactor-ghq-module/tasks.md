## 1. Rename de variables a ZSH_GHQ_

- [x] 1.1 Renombrar en `config/base.zsh` las variables legacy a canónicas `ZSH_GHQ_*` (PACKAGE_NAME, ROOT, FILE_COOKIECUTTER, CACHE_PATH, CACHE_NAME, CACHE_PROJECT, REGEX_IS_REPOSITORY, GITHUB_USER → ZSH_GHQ_GITHUB_USER), con alias backward-compat `GHQ_*="${ZSH_GHQ_*}"` y comentario "remove in next cleanup cycle"
- [x] 1.2 Añadir `ZSH_GHQ_DATA_PATH="${ZSH_GHQ_PATH}/data"` a `config/base.zsh`
- [x] 1.3 Actualizar todas las referencias internas (plugin.zsh, internal/, pkg/) al prefijo `ZSH_GHQ_*`
- [x] 1.4 Grep de verificación: ningún uso de `GHQ_*` sin el canónico `ZSH_GHQ_*` correspondiente (salvo aliases)

## 2. Delegar instalación al core

- [x] 2.1 Eliminar el dispatch manual brew/paru de `internal/base.zsh` y usar `core::install "${ZSH_GHQ_PACKAGE_NAME}"`
- [x] 2.2 Reemplazar en `internal/main.zsh` el patrón `if ! core::exists X; then core::install X; fi` por `core::ensure rsync` y `core::ensure "${ZSH_GHQ_PACKAGE_NAME}"`
- [x] 2.3 Renombrar `ghq::internal::ghq::install` → `ghq::internal::install` y actualizar su llamada en `pkg/base.zsh`

## 3. Migración de datos a data/

- [x] 3.1 Crear `data/` y mover `resources/data.json` → `data/data.json`
- [x] 3.2 Actualizar `ZSH_GHQ_FILE_COOKIECUTTER` para referenciar `data/data.json`
- [x] 3.3 Eliminar `resources/` y `cookiecutter/` (solo `.gitkeep`)
- [x] 3.4 Grep de verificación: sin refs a `resources/data.json` en el repo

## 4. Contrato público

- [x] 4.1 Implementar `ghq::setup` en `pkg/helper.zsh` (orchestrator: ensure → install si falta → mensajes message_*)
- [x] 4.2 Implementar `ghq::sync` en `pkg/base.zsh`
- [x] 4.3 Verificar `type ghq::install`, `type ghq::sync`, `type ghq::setup` → las tres responden `function`

## 5. Alineación del entry point

- [x] 5.1 Interpolar `${ZSH_GHQ_PACKAGE_NAME}` en `message_info "Loading module: ..."` de `plugin.zsh` (eliminar el literal "ghq")
- [x] 5.2 Cambiar `ZSH_GHQ_PATH="$(dirname "${0}")"` → `ZSH_GHQ_PATH="${0:A:h}"` en `plugin.zsh`
- [x] 5.3 Documentar `keybindings.zsh` como extensión opcional en comentario de cabecera
- [x] 5.4 `echo -e` → `printf '%b'` en `pkg/cookiecutter.zsh`

## 6. Validación final

- [x] 6.1 `bash -n` en todos los archivos modificados del módulo
- [x] 6.2 Carga del módulo: `source zsh/system/core/main.zsh && source zsh/modules/ghq/plugin.zsh` → emite "Loading module" una sola vez (guard idempotente)
- [x] 6.3 `task validate` (shellcheck + pre-commit) pasa
- [x] 6.4 Grep de verificación de naming: sin variables legacy sin alias en `config/base.zsh`
