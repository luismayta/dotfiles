## 1. Limpiar variables muertas o redundantes en config/

- [x] 1.1 Eliminar `DEVOPS_KUBECTL_KUBE_EDITOR` de `config/base.zsh`
- [x] 1.2 Eliminar `DEVOPS_KUBECTL_LOCAL_PATH_BIN` de `config/base.zsh`
- [x] 1.3 Eliminar `DEVOPS_ARCHITECTURE_NAME` de `config/osx.zsh` y `config/linux.zsh`
- [x] 1.4 Eliminar `DEVOPS_APPLICATION_PATH` de `config/osx.zsh`
- [x] 1.5 Verificar que ninguna otra variable en devops tenga equivalente en core (ej. revisar `DEVOPS_K9S_CONF_PATH`, `DEVOPS_TFENV_ROOT`, paths generales)

## 2. Reemplazar manipulación manual de PATH por path::append/prepend

- [x] 2.1 En `internal/kubectl.zsh`: reemplazar `[ -e "${KREW_ROOT_BIN}" ] && export PATH="${KREW_ROOT_BIN}:${PATH}"` por `path::prepend "${KREW_ROOT_BIN}"`
- [x] 2.2 En `internal/tfenv.zsh`: reemplazar `[ -e "${DEVOPS_TFENV_ROOT_BIN}" ] && export PATH="${PATH}:${DEVOPS_TFENV_ROOT_BIN}"` por `path::append "${DEVOPS_TFENV_ROOT_BIN}"`

## 3. Unificar referencias a EDITOR

- [x] 3.1 En `pkg/k9s.zsh`: reemplazar uso de variable `EDITOR` (ya correcto) — verificar que `editk9s` usa `$EDITOR` sin depender de `DEVOPS_KUBECTL_KUBE_EDITOR`
- [x] 3.2 Confirmar que no hay otras referencias a `DEVOPS_KUBECTL_KUBE_EDITOR` en el módulo

## 4. Verificación post-cambio

- [x] 4.1 Ejecutar `lsp_diagnostics` en todos los archivos modificados
- [x] 4.2 Cargar el módulo en un shell y verificar que no hay errores
- [x] 4.3 Verificar que `kubectl`, `k9s`, `tfenv` siguen funcionando con `$EDITOR`
