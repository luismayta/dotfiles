## 1. Quick Wins + Shared Library

- [ ] 1.1 Crear `lib/colors.sh` con constantes ANSI (`C_RESET`, `C_BLUE`, `C_GREEN`, `C_RED`, `C_YELLOW`)
- [ ] 1.2 Crear `lib/messages.sh` con `msg::info`, `msg::success`, `msg::error`, `msg::warn` (solo imprimen, no hacen exit)
- [ ] 1.3 Crear `lib/common.sh` con `detect::os`, `program_exists`, `change_shell`
- [ ] 1.4 Corregir `ZSH_PATH`: mover asignación a después de `setup::packages::common` en `install.sh`
- [ ] 1.5 Fix `printf` format strings en `install.sh` — usar `printf '%s\n' "${BLUE}[INFO]: ${1}${RESET}"` en lugar de `printf "${BLUE}%s${RESET}\n"`

## 2. Integrar Shared Library en install.sh

- [ ] 2.1 Sourcear `lib/common.sh`, `lib/messages.sh`, `lib/colors.sh` al inicio de `install.sh`
- [ ] 2.2 Remover definiciones duplicadas de `detect::os`, `program_exists`, `message::*` de `install.sh`
- [ ] 2.3 Extraer `setup::change_shell()` y reemplazar los dos `chsh` duplicados en `setup::mac` y `setup::linux`
- [ ] 2.4 Cambiar handoff a `exec bash` con `DOTFILES_ROOT` y `DOTFILES_OS` exportados

## 3. Integrar Shared Library en provision/script/

- [ ] 3.1 Sourcear `lib/messages.sh` y `lib/common.sh` desde `provision/script/bootstrap.sh`
- [ ] 3.2 Remover `provision/script/messages.sh` (reemplazado por `lib/messages.sh`)
- [ ] 3.3 Remover `program_exists` de `provision/script/functions.sh` y agregar `source lib/common.sh`
- [ ] 3.4 Remover `detect::os` de `provision/script/bootstrap.sh`
- [ ] 3.5 Remover `export HOME=~` redundante de `bootstrap.sh`
- [ ] 3.6 Remover `die()` (código muerto) de `functions.sh`
- [ ] 3.7 Fix `>>/dev/null` → `>/dev/null` en `functions.sh`

## 4. Robustecer bootstrap paths y sourcing

- [ ] 4.1 Reemplazar `ROOT_DIR=$(pwd)` por `ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"` en `bootstrap.sh`
- [ ] 4.2 Reemplazar sourcing condicional silencioso por fail loud en `bootstrap.sh` y `install.sh`
- [ ] 4.3 Fix `provision/script/test.sh` para usar `BASH_SOURCE[0]` en lugar de ruta relativa

## 5. Crear config/packages.sh declarativo

- [ ] 5.1 Crear `config/packages.sh` con `PACKAGES_COMMON`, `PACKAGES_MAC`, `PACKAGES_LINUX`
- [ ] 5.2 Sourcear `config/packages.sh` desde `install.sh`
- [ ] 5.3 Refactorizar `setup::mac` y `setup::linux` para iterar los arrays en lugar de tener paquetes hardcodeados

## 6. Split initialize() y cleanup

- [ ] 6.1 Dividir `initialize()` en `initialize_prereqs()`, `install_apps()`, `deploy_configs()`, `sync_extras()` en `functions.sh`
- [ ] 6.2 Unificar `DOTFILES_GIT_URI`/`GIT_URI` naming (usar `GIT_URI` de `config/base.sh` como fuente de verdad)

## 7. Validación

- [ ] 7.1 Ejecutar `bash -n install.sh && bash -n provision/script/*.sh` para verificar sintaxis en todos los archivos modificados
- [ ] 7.2 Ejecutar shellcheck en todos los archivos modificados
- [ ] 7.3 Ejecutar `task validate` para pasar pre-commit hooks
- [ ] 7.4 Commit del cambio
