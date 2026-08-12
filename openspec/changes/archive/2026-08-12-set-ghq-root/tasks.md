## 1. Default determinista de GHQ_ROOT

- [x] 1.1 Reemplazar en `zsh/modules/ghq/config/base.zsh` (L8-9) el cálculo `ZSH_GHQ_ROOT="$(ghq root 2>/dev/null || echo "${PROJECTS:-${HOME}/projects}")"` por `ZSH_GHQ_ROOT="${ZSH_GHQ_ROOT:-${GHQ_ROOT:-${HOME}/Projects/src}}"` + `export ZSH_GHQ_ROOT`, respetando el patrón `${VAR:-default}` y el prefijo canónico `ZSH_GHQ_`
- [x] 1.2 Verificar que el alias backward-compat `GHQ_ROOT` (config/base.zsh L23) sigue apuntando al canónico `ZSH_GHQ_ROOT` y no introduce duplicación

## 2. Alinear post-install con el root exportado

- [x] 2.1 En `zsh/modules/ghq/pkg/base.zsh` (L20), si `ghq::post_install` usa el fallback genérico `${PROJECTS:-${HOME}/projects}`, cambiarlo a `"${ZSH_GHQ_ROOT}"` para que `git config --global ghq.root` quede consistente

## 3. Documentación

- [x] 3.1 Actualizar `zsh/modules/ghq/README.yaml` si documenta el default de `GHQ_ROOT` (valor `${HOME}/Projects/src`, override respetado)
- [x] 3.2 Regenerar `README.md` con `task readme` si el default quedó documentado en README.yaml

## 4. Verificación

- [x] 4.1 En una shell zsh nueva sin vars predefinidas: `echo $ZSH_GHQ_ROOT` y `echo $GHQ_ROOT` deben resolver a `${HOME}/Projects/src`
- [x] 4.2 Con `GHQ_ROOT=/tmp/x` exportado antes de cargar el módulo, el valor debe respetarse (`/tmp/x`) y `ZSH_GHQ_ROOT` debe reflejarlo
- [x] 4.3 Confirmar que la API pública sigue intacta: `type ghq::install`, `type ghq::sync`, `type ghq::setup` responden `function`
