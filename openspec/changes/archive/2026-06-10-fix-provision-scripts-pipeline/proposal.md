## Why

`install.sh` ejecuta `source provision/script/run.sh` como paso post-clone. Este pipeline tiene 8 bugs confirmados: llama a `setup::linux` que no existe (B1), referencia variables undefined `FILE_SETTINGS_OSX`/`FILE_SETTINGS_LINUX` (B2), código duplicado de `install.sh` con variables undefined en `repo.sh` (B3), `replace_files` usa `read` que no funciona en curl|bash (B4), `exit` sin código (B5), variable `$file` no definida en `do_backup` (B6), `$ret` sin default en `messages.sh` (B7), y chequea `pacman` en vez de `paru` para Arch Linux (B8). Esto rompe el bootstrap post-clone tanto en macOS como en CachyOS.

## What Changes

- **Bootstrap.sh**: Remover llamado a `setup::linux` que no existe (solo necesita sourcear `config/linux.sh`).
- **Config.sh**: Eliminar referencias a `FILE_SETTINGS_OSX`/`FILE_SETTINGS_LINUX` que nunca se definen — el sourcing de OS config ya lo hace `bootstrap.sh`.
- **Functions.sh**: `program_exists` usar `exit 1` con código. `do_backup` recibir `file` como parámetro. `dotfiles_install_factory` detectar `paru` en vez de `pacman`.
- **Messages.sh**: `success()` y `debug()` usar `${ret:-}` para no crashear con `set -u`.
- **Repo.sh**: Eliminar archivo completo — duplica lógica de `install.sh` con variables undefined.
- **Replace_files**: Para curl|bash, reemplazar el prompt `read` interactivo con flag automático o variable de entorno `DOTFILES_YES`.
- **Run.sh**: Simplificar — eliminar modo TEST (no usado), pasar flag a `replace_files`.

## Capabilities

### New Capabilities
- `provision-pipeline`: Pipeline post-clone autocontenido, sin bugs, que funciona tanto en curl|bash como en ejecución local.

### Modified Capabilities
- *(ninguna — no hay specs existentes que modificar)*

## Impact

- **provision/script/run.sh**: Simplificado — sin modo TEST, sin `read` bloqueante.
- **provision/script/bootstrap.sh**: Removido `setup::linux` inexistente.
- **provision/script/functions.sh**: Bugs fixeados (exit code, $file param, paru).
- **provision/script/messages.sh**: `${ret:-}` safe para set -u.
- **provision/script/repo.sh**: **BREAKING** — archivo eliminado (código muerto).
- **provision/script/config.sh**: Referencias a vars undefined eliminadas.
- Solo macOS (brew) y CachyOS (paru) — sin soporte para otras distros.
