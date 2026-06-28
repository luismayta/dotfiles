## 1. Remove provision/fonts/

- [x] 1.1 Eliminar directorio `provision/fonts/` completo
- [x] 1.2 Eliminar directorio `provision/fonts/samples/`

## 2. Remove resources/data/fonts/ y fonts sync

- [x] 2.1 Eliminar directorio `zsh/modules/resources/data/fonts/` completo
- [x] 2.2 Eliminar función `resources::fonts::sync` y `resources::sync` de `zsh/modules/resources/pkg/base.zsh`
- [x] 2.3 Eliminar variables `RESOURCES_FONTS_PATH` de `zsh/modules/resources/config/linux.zsh` y `zsh/modules/resources/config/osx.zsh`

## 3. Add macOS font casks

- [x] 3.1 Agregar los 3 fonts a `CORE_PACKAGES` en `zsh/core/config/osx.zsh`
- [x] 3.2 `CORE_CASK_PACKAGES` no es necesaria — `brew install` auto-detecta casks
