## Context

El módulo `zsh/modules/nodejs/` gestiona la toolchain de Node.js en dotfiles: fnm (version manager), bun (package manager), versiones de Node.js, y paquetes npm globales. El array `NODEJS_PACKAGES` en `config/base.zsh` define qué paquetes se instalan globalmente vía `bun install -g` (`nodejs::internal::packages::install`). Actualmente contiene 39 paquetes.

chrome-headless-shell y mmdc (mermaid-cli) son herramientas que el módulo nodejs necesita para el renderizado de diagramas mermaid. chrome-headless-shell requiere una instalación persistente separada (no es un paquete npm estándar), mientras mmdc sí es un paquete npm instalable vía bun.

Constraint: la instalación de chrome-headless-shell es efímera actualmente (vive en `/tmp` via npx). Debe ser persistente para que el renderizado funcione tras reinicios.

## Goals / Non-Goals

**Goals:**
- Instalar chrome-headless-shell de forma persistente en `~/.local/share/chrome-headless-shell`
- Generar `puppeteer-config.json` con `executablePath` apuntando al binario persistente
- Integrar mmdc al array `NODEJS_PACKAGES` para instalarse via `bun install -g`
- Mantener idempotencia: instalación solo si no existe
- Documentar el setup en `README.yaml`

**Non-Goals:**
- Modificar el comportamiento de `nodejs::internal::packages::install` (solo agregar paquete al array)
- Implementar un sistema de actualización automática de chrome-headless-shell (instalación manual o via Taskfile futuro)
- Soporte multi-plataforma para chrome-headless-shell (asumimos Linux/macOS con arquitectura compatible)
- Modificar el template `prompt.md.tpl` de jira-start-task (bug de gomplate 5.2.0 es un issue separado)

## Decisions

### 1. chrome-headless-shell: `npx @puppeteer/browsers` con `--path` a ubicación persistente
**Rationale**: El comando oficial de Puppeteer descarga el binario a una ubicación específica. Usar `--path ~/.local/share/chrome-headless-shell` lo persiste. Alternativa considerada: symlink desde `/tmp` — rechazada porque el path efímero puede cambiar entre sesiones.

### 2. puppeteer-config.json como template en `data/` sincronizado via rsync
**Rationale**: Sigue el patrón existente del módulo: `data/sync/.npmrc` se sincroniza a `~/` via `rsync`. El `puppeteer-config.json` puede seguir el mismo patrón, o generarse in-place durante la instalación de chrome-headless-shell. Se opta por generación in-place porque el `executablePath` depende de la ubicación instalada.

### 3. mmdc como miembro de NODEJS_PACKAGES (no instalador separado)
**Rationale**: mmdc es un paquete npm estándar. Agregarlo al array `NODEJS_PACKAGES` reutiliza el mecanismo existente de `bun install -g` sin código adicional. Alternativa considerada: script de instalación separado — rechazada por innecesaria.

### 4. Auto-install guard para chrome-headless-shell en `internal/main.zsh`
**Rationale**: Sigue el patrón del módulo: `if ! core::exists <binary>; then install; fi`. El guard verifica la existencia del directorio `~/.local/share/chrome-headless-shell` antes de intentar la instalación.

## Risks / Trade-offs

- **[Risk]** `npx @puppeteer/browsers` puede requerir `npm` o `npx` disponible → **Mitigation**: fnm ya instala npm globalmente; el módulo nodejs garantiza que fnm está cargado antes de ejecutar installs.
- **[Risk]** Tamaño del binario chrome-headless-shell (~150MB) → **Mitigation**: Instalación única, no afecta tiempo de shell startup (solo se ejecuta si no existe).
- **[Trade-off]** `executablePath` hardcodeado en puppeteer-config.json → Si chrome-headless-shell cambia de versión/path, el config debe regenerarse. Aceptado: es un setup manual, no un sistema de actualización continua.
- **[Trade-off]** Sin verificación de versiones → Si el usuario instala chrome-headless-shell manualmente en otro path, el config puede apuntar al lugar equivocado. Aceptado: el setup es controlado por el módulo.