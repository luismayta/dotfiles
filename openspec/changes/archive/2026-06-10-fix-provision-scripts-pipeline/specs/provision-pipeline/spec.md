# provision-pipeline

## Requirements

### REQ-PP-001: Pipeline post-clone ejecutable sin errores
- `run.sh` debe poder ser sourceado desde `install.sh` sin crashear.
- Todas las variables utilizadas deben estar definidas o tener default (`${var:-}`).
- `set -euo pipefail` debe poder estar activo sin causar errores.

### REQ-PP-002: Sin código muerto ni duplicado
- `repo.sh` debe ser eliminado (duplica lógica de `install.sh` con bugs).
- `config.sh` debe ser eliminado (referencia variables undefined).
- Funciones no llamadas deben ser eliminadas.

### REQ-PP-003: replace_files sin bloqueo en curl|bash
- Si se ejecuta en terminal interactiva (`-t 0`), preguntar y/n.
- Si se ejecuta en pipe (curl|bash), leer `DOTFILES_YES` env var.
- Si no hay terminal ni `DOTFILES_YES`, abortar con mensaje instructivo.

### REQ-PP-004: exit con código numérico explícito
- Todo `exit` debe tener código explícito: `exit 0` o `exit 1`.
- `program_exists` en `functions.sh` debe usar `exit 1`.

### REQ-PP-005: Funciones con variables locales explícitas
- `do_backup` debe recibir el filename como parámetro, no depender de variables del caller.
- `success()` y `debug()` en `messages.sh` deben usar `${ret:-0}`.

### REQ-PP-006: Detección de paru para Arch/CachyOS
- `dotfiles_install_factory` debe detectar `paru`, no `pacman`.
- Si paru no existe pero pacman sí, instalarlo con `sudo pacman -S --noconfirm paru`.

### REQ-PP-007: Sin referencias a funciones undefined
- `bootstrap.sh` no debe llamar `setup::linux` (no existe).
- `config::factory` para Linux solo debe sourcear `config/linux.sh`.