---
# Tasks — Migrate Antidote to zsh/system
---

## 1. Módulo zsh/system/antidote

- [x] 1.1 Crear la estructura `zsh/system/antidote/{config,internal,pkg}`
- [x] 1.2 Crear `plugin.zsh`: guard `__ZSH_ANTIDOTE_LOADED`, `ZSH_ANTIDOTE_PATH="${0:A:h}"`, `message_info "Loading module: antidote"`, source de `config/main.zsh`, `internal/main.zsh` y `pkg/main.zsh`, respetando `ZSH_ANTIDOTE_ENABLED`
- [x] 1.3 Crear `config/base.zsh`: exportar `ZSH_ANTIDOTE_ENABLED` (default true), `ANTIDOTE_PATH="${ANTIDOTE_PATH:-${ZDOTDIR:-${HOME}}/.antidote}"`, `ANTIDOTE_PLUGINS_FILE="${DOTFILES_ZSH_PATH}/zsh_plugins.txt"`, `ANTIDOTE_CUSTOM_PLUGINS_FILE="${HOME}/.custom_zsh_plugins.txt"`, `ANTIDOTE_BUNDLE_FILE="${HOME}/.zsh_plugins.txt"`
- [x] 1.4 Crear `config/main.zsh` (source base.zsh)
- [x] 1.5 Crear `internal/base.zsh` con `antidote::internal::antidote::install`: git clone `https://github.com/mattmc3/antidote.git` (depth 1) a `${ANTIDOTE_PATH}` solo si `[[ ! -f "${ANTIDOTE_PATH}/antidote.zsh" ]]`, con `message_info` de éxito/skip
- [x] 1.6 Crear `internal/main.zsh`: auto-install al cargar (si falta `antidote.zsh`, llamar install; guard de idempotencia)
- [x] 1.7 Crear `pkg/base.zsh` con `antidote::init`: source `${ANTIDOTE_PATH}/antidote.zsh`, `touch` de custom file, concat `zsh_plugins.txt` + custom a `${ANTIDOTE_BUNDLE_FILE}`, `antidote load "${ANTIDOTE_BUNDLE_FILE}"`
- [x] 1.8 Crear `pkg/main.zsh` (source base.zsh)

## 2. Integración zshrc

- [x] 2.1 Reemplazar el bloque inline L73-80 de `zsh/zshrc` por `antidote::init` en la misma posición (tras el loader de `zsh/modules`)
- [x] 2.2 Verificar el orden de carga: `source zshrc` → el módulo antidote carga una vez y los plugins se cargan tras los módulos user

## 3. Eliminar el mecanismo tools/

- [x] 3.1 Eliminar `tools/antidote/` y el directorio `tools/`
- [x] 3.2 Quitar `APPS=("antidote")` de `provision/script/config/base.sh` (y la declaración de APPS si queda vacía)
- [x] 3.3 Quitar `dotfiles_install_apps` y su llamada en `provision/script/functions.sh`
- [x] 3.4 Quitar `TOOLS_PATH` de `provision/script/bootstrap.sh` (verificar antes con grep que nada más lo usa; NO eliminar `SCRIPT_PATH`, que siguen usando otros scripts de provision)

## 4. Verificación

- [x] 4.1 `bash -n` + shellcheck limpio en: módulo nuevo, `zsh/zshrc`, `provision/script/{base.sh,functions.sh,bootstrap.sh}`
- [x] 4.2 Shell nueva: `source zshrc` → "Loading module: antidote" una sola vez y plugins de `zsh_plugins.txt` cargados
- [x] 4.3 Shell con `ZSH_DISABLED_MODULES=antidote` → el módulo no se carga (ni install ni init)
- [x] 4.4 Idempotencia: re-source del módulo → no-op; segunda shell nueva → install salta (skip message)
- [x] 4.5 `grep -rn "tools/antidote"` en código vivo (sin .git/openspec/graphify-out/.codi) → sin resultados; `grep -rn "TOOLS_PATH"` → sin resultados
