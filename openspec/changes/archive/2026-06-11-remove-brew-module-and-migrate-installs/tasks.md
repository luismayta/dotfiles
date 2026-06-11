## 1. Migrate Direct `brew install` Calls to `core::install`

- [x] 1.1 Replace `brew install git` with `core::install git` in `zsh/modules/git/internal/base.zsh` (línea 11)
- [x] 1.2 Replace `brew install "${GHQ_PACKAGE_NAME}"` with `core::install "${GHQ_PACKAGE_NAME}"` in `zsh/modules/ghq/internal/base.zsh` (línea 7) — eliminar el `if core::exists brew` previo
- [x] 1.3 Replace `brew install --cask ghostty` with `core::install ghostty` in `zsh/modules/ghostty/internal/base.zsh` (línea 16)
- [x] 1.4 Replace `brew install eza` with `core::install eza` in `zsh/modules/aliases/internal/eza.zsh` (línea 10)

## 2. Remove Brew Module

- [x] 2.1 Eliminar el directorio `zsh/modules/brew/` completo

## 3. Update References

- [x] 3.1 Actualizar `CORE_MESSAGE_BREW` en `zsh/core/config/env.zsh` (línea 6) — cambiar referencia de `zsh/modules/brew` a `core::install`
- [x] 3.2 Actualizar el spec principal `openspec/specs/core-messages/spec.md` — escenario `CORE_MESSAGE_BREW is defined`: cambiar referencia de `zsh/modules/brew` a `core::install`

## 4. Verification

- [x] 4.1 Confirmar que `zsh/modules/brew/` ya no existe
- [x] 4.2 Confirmar cero ocurrencias de `brew install` directo en `zsh/modules/` (permitir solo comentarios y mensajes echo)
- [x] 4.3 Confirmar que `core::install` sigue funcionando revisando que `zsh/core/pkg/base.zsh` y sus implementaciones por OS están intactas