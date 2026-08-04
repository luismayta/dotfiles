# Task: Crear módulo smolvm siguiendo la guía de creación de módulos

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Crear el módulo zsh `smolvm` en los dotfiles siguiendo la guía de creación de módulos
- component:
- labels: []
- parentEpic: RD-30
- issueKey: RD-62

## Scenario

Crear un nuevo módulo zsh con el nombre `smolvm` en `zsh/modules/`, siguiendo la guía de creación de módulos del repositorio (`docs/guides/create-module.md`), que documenta la arquitectura tri-capa `config/`, `internal/`, `pkg/` más `data/` y el entry point `plugin.zsh`.

El módulo debe gestionar la herramienta `smolvm` (microVM engine de smol-machines, Apache-2.0) que el plugin herdr `smolbox` (carze/herdr-smolmachine) usa para correr coding agents en microVMs efímeras. La adopción decidida: pin **smolvm 1.3.2** (versión validada por el plugin), binario en `~/.local/bin`, KVM ya verificado funcional en el host (CachyOS, `/dev/kvm` 666 + flag vmx).

Referencia de estructura existente: módulo `zsh/modules/herdr/` (mismo patrón: `plugin.zsh` como único punto de carga, `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`, guard de idempotencia, enable/disable vía variable `ZSH_SMOLVM_ENABLED`).

### Acceptance Tests

- [ ] 1. Estructura del módulo creada en `zsh/modules/smolvm/` con `plugin.zsh`, `config/`, `internal/`, `pkg/` y `data/` según `docs/guides/create-module.md`
- [ ] 2. `plugin.zsh` es el único archivo sourceado por zshrc; encadena `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh` con guard de idempotencia (`__ZSH_SMOLVM_LOADED`)
- [ ] 3. Módulo deshabilitable: si `ZSH_SMOLVM_ENABLED != true`, no se carga (patrón del módulo herdr)
- [ ] 4. Instalación de `smolvm` v1.3.2 en `internal/install.zsh`: descarga del release oficial, verificación de checksum SHA256, instalación en `~/.local/bin`, `core::ensure` de dependencias
- [ ] 5. Verificación post-instalación: `smolvm --version` reporta 1.3.2 y `smolvm machine run --help` responde
- [ ] 6. `bash -n` y shellcheck limpios en todos los archivos nuevos del módulo
- [ ] 7. `README.md` del módulo generado desde el template compartido (`provision/templates/README.module.tpl.md`)

### Sources

- `docs/guides/create-module.md`
- `docs/guides/implement-tool-in-module.md`
- `zsh/modules/herdr/` (referencia de estructura)
- `https://github.com/smol-machines/smolvm` (releases v1.3.2)
- https://github.com/codiplab/dotfiles.git