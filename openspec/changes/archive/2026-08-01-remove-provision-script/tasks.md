## 1. Eliminación de provision/script

- [x] 1.1 Ejecutar `git rm -r provision/script` para eliminar el directorio completo (bootstrap.sh, run.sh, test.sh, config/, functions.sh)

## 2. Actualización de install.sh

- [x] 2.1 Reemplazar `exec bash "${PATH_REPO}/provision/script/run.sh"` por copia directa de `zsh/zshrc` → `$HOME/.zshrc` y `zsh/zshenv` → `$HOME/.zshenv` (con `msg::success` si las funciones de mensajería están sourceadas; si no, `echo` simple)

## 3. Actualización de comentarios

- [x] 3.1 Actualizar el comentario de `config/packages.sh:4` para que ya no mencione "provision scripts" y refleje solo "Sourced by install.sh"

## 4. Verificación

- [x] 4.1 Ejecutar `bash -n install.sh` para validar sintaxis
- [x] 4.2 Ejecutar `grep "provision/script"` sobre el código vivo (excluyendo `.git`, `openspec`, `graphify-out`, `.codi`) y confirmar 0 resultados
- [x] 4.3 Ejecutar `git status` y confirmar que no hay rastros de `provision/script`
