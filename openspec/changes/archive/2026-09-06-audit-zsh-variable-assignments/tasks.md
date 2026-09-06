## 1. Verificación de helix

- [x] 1.1 Verificar que `helix/config/osx.zsh` usa `=` para `ZSH_HELIX_PACKAGE_NAME`
- [x] 1.2 Probar que helix detecta correctamente `hx` en macOS
- [x] 1.3 Verificar que `helix/config/base.zsh` mantiene `:=` para defaults

## 2. Auditoría de nvim

- [x] 2.1 Revisar `nvim/config/base.zsh` para confirmar uso correcto de `:=`
- [x] 2.2 Revisar `nvim/config/osx.zsh` para detectar si necesita override con `=`
- [x] 2.3 Corregir nvim si se encuentra el mismo patrón de bug

## 3. Documentación

- [x] 3.1 Actualizar README de helix con patrón de asignación de variables
- [x] 3.2 Actualizar README de nvim con patrón de asignación de variables
- [x] 3.3 Agregar comentario en `base.zsh` de helix explicando el patrón

## 4. Verificación final

- [x] 4.1 Ejecutar shellcheck en todos los archivos .zsh modificados
- [x] 4.2 Probar carga del módulo helix en macOS
- [x] 4.3 Probar carga del módulo nvim en macOS (si aplica)
