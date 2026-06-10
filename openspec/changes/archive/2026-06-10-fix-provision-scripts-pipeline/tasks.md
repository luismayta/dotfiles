## 1. Eliminar código muerto

- [x] 1.1 Eliminar archivo `provision/script/repo.sh` (duplica install.sh con bugs)
- [x] 1.2 Eliminar archivo `provision/script/config.sh` (vars undefined)
- [x] 1.3 Actualizar `bootstrap.sh:58` — remover `config` y `repo` del source loop (solo dejar `messages` y `functions`)

## 2. Fix bootstrap.sh

- [x] 2.1 Remover `setup::linux` de `config::factory` (línea 47) — solo sourcear `config/linux.sh`
- [x] 2.2 Verificar que `config::factory` para Linux solo setee FONTS_DIR

## 3. Fix functions.sh

- [x] 3.1 `program_exists`: cambiar `exit` a `exit 1` (línea 53)
- [x] 3.2 `do_backup`: recibir filename como `$2`, derivar backup path del parámetro, no de `$file`
- [x] 3.3 `dotfiles_install_factory`: cambiar `type -p pacman` a `type -p paru`, con fallback a `sudo pacman -S --noconfirm paru`
- [x] 3.4 Eliminar función `is_program_exist` (no usada, duplica program_exists)

## 4. Fix messages.sh

- [x] 4.1 `success()`: cambiar `${ret}` a `${ret:-0}`
- [x] 4.2 `debug()`: cambiar `${ret}` a `${ret:-0}` y `${FUNCNAME[$i+1]}` a `${FUNCNAME[1]:-}` (variable `$i` undefined)

## 5. Fix replace_files (curl|bash compatible)

- [x] 5.1 Si stdin es terminal (`-t 0`), preguntar y/n como antes
- [x] 5.2 Si no es terminal, leer `DOTFILES_YES` env var — si es `true`, ejecutar `initialize` directo
- [x] 5.3 Si no hay terminal ni `DOTFILES_YES`, mostrar mensaje instructivo: "Run with DOTFILES_YES=true to skip confirmation"
