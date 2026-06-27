## 1. Preparación y constantes

- [x] 1.1 Agregar `readonly ZSH_PATH=$(command -v zsh)` al inicio del script
- [x] 1.2 Mejorar trap: incluir `$(date)` en mensaje de error

## 2. Refactor de funciones

- [x] 2.1 Crear `setup::packages::common` con `zsh`, `git`, `rsync`, `ksh`, `fd`
- [x] 2.2 Llamar `setup::packages::common` desde `setup::mac` y `setup::linux`
- [x] 2.3 Reemplazar loop `for package in ... paru -S` con `paru -S --noconfirm "${packages[@]}"` en Linux
- [x] 2.4 Renombrar `upgrade_repo` → `update_repo` y actualizar sus call sites

## 3. Idempotencia y flags

- [x] 3.1 Agregar guard `SKIP_NIX` al inicio de `setup::nix`
- [x] 3.2 Hacer `chsh` condicional: solo ejecutar si `$SHELL != $ZSH_PATH`
- [x] 3.3 Reemplazar paths hardcodeados de zsh por `$ZSH_PATH`

## 4. Validación

- [x] 4.1 Ejecutar `bash -n install.sh` para verificar sintaxis
- [x] 4.2 Ejecutar `task validate` para pasar pre-commit hooks
- [x] 4.3 Commit del cambio
