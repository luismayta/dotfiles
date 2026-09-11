## Why

El renderizado de diagramas mermaid con `mmdc` (mermaid-cli) requiere `chrome-headless-shell`, pero la instalación actual se realizó vía `npx @puppeteer/browsers` y vive en `/tmp` (efímera). Cada reinicio pierde el binario y el renderizado de diagramas deja de funcionar. Se necesita un setup reproducible y persistente en dotfiles (trazabilidad: RD-174).

## What Changes

- Agregar `@mermaid-js/mermaid-cli` (mmdc) al array `NODEJS_PACKAGES` en `zsh/modules/nodejs/config/base.zsh`, instalándose vía el mecanismo existente `bun install -g` (`nodejs::internal::packages::install`).
- Crear script de instalación persistente de `chrome-headless-shell` en `~/.local/share/chrome-headless-shell` vía `npx @puppeteer/browsers install chrome-headless-shell@stable --path`.
- Crear `puppeteer-config.json` con `executablePath` apuntando al binario persistente de `chrome-headless-shell`.
- Agregar auto-install guard en `zsh/modules/nodejs/internal/main.zsh` para `chrome-headless-shell` y `mmdc`.
- Exponer API pública en `zsh/modules/nodejs/pkg/base.zsh` (`nodejs::chrome::install`, `nodejs::mmdc::install`).
- Documentar el setup en `README.yaml` del módulo nodejs.

## Capabilities

### New Capabilities
- `mermaid-rendering`: Setup persistente de renderizado de diagramas mermaid — instalación de `chrome-headless-shell` en `~/.local/share/chrome-headless-shell`, configuración de `puppeteer-config.json` con `executablePath` correcto, y verificación de que `mmdc` renderiza sin errores.

### Modified Capabilities
- `nodejs-module`: El requirement "NPM package manager" cambia — `NODEJS_PACKAGES` ahora incluye `@mermaid-js/mermaid-cli` (mmdc), instalado vía el mecanismo global existente.

## Impact

- `zsh/modules/nodejs/config/base.zsh` — array `NODEJS_PACKAGES` + nuevas env vars (`CHROME_HEADLESS_SHELL_PATH`, `PUPPETEER_CONFIG_PATH`).
- `zsh/modules/nodejs/internal/base.zsh` — nuevas funciones de instalación (`chrome::install`, `puppeteer::config`, `mmdc::install`).
- `zsh/modules/nodejs/internal/main.zsh` — auto-install guards.
- `zsh/modules/nodejs/pkg/base.zsh` — API pública.
- `zsh/modules/nodejs/data/` — template `puppeteer-config.json`.
- `zsh/modules/nodejs/README.yaml` — documentación.
- Dependencia: `@puppeteer/browsers` (npx) para la instalación de `chrome-headless-shell`.