## 1. Config — env vars y NODEJS_PACKAGES

- [x] 1.1 Agregar `CHROME_HEADLESS_SHELL_PATH="${HOME}/.local/share/chrome-headless-shell"` y `PUPPETEER_CONFIG_PATH="${HOME}/.puppeteer-config.json"` a `zsh/modules/nodejs/config/base.zsh`
- [x] 1.2 Agregar `@mermaid-js/mermaid-cli` al array `NODEJS_PACKAGES` en `zsh/modules/nodejs/config/base.zsh`

## 2. Internal — funciones de instalación

- [x] 2.1 Crear función `nodejs::internal::chrome::install` en `zsh/modules/nodejs/internal/base.zsh`: ejecutar `npx @puppeteer/browsers install chrome-headless-shell@stable --path "${CHROME_HEADLESS_SHELL_PATH}"` solo si el directorio no existe (idempotente)
- [x] 2.2 Crear función `nodejs::internal::chrome::load` en `zsh/modules/nodejs/internal/base.zsh`: verificar existencia del binario en `CHROME_HEADLESS_SHELL_PATH` y reportar disponibilidad
- [x] 2.3 Crear función `nodejs::internal::puppeteer::config` en `zsh/modules/nodejs/internal/base.zsh`: generar `${PUPPETEER_CONFIG_PATH}` con `{ "executablePath": "<path-al-binario-chrome-headless-shell>" }` si no existe
- [x] 2.4 Agregar auto-install guard en `zsh/modules/nodejs/internal/main.zsh`: `if [ ! -d "${CHROME_HEADLESS_SHELL_PATH}" ]; then nodejs::internal::chrome::install && nodejs::internal::puppeteer::config; fi` — ejecutar después del guard de fnm/bun

## 3. Pkg — API pública

- [x] 3.1 Exponer `nodejs::chrome::install` y `nodejs::chrome::load` en `zsh/modules/nodejs/pkg/base.zsh`

## 4. Documentación

- [x] 4.1 Agregar sección de mermaid rendering a `zsh/modules/nodejs/README.yaml` (features: chrome-headless-shell persistente, puppeteer-config.json, mmdc via NODEJS_PACKAGES)
- [x] 4.2 Ejecutar `task readme` desde la raíz de dotfiles para regenerar `zsh/modules/nodejs/README.md`

## 5. Verificación

- [x] 5.1 Ejecutar `nodejs::internal::chrome::install` y verificar que `~/.local/share/chrome-headless-shell` contiene el binario
- [x] 5.2 Ejecutar `bun install -g @mermaid-js/mermaid-cli` y verificar que `mmdc` está en PATH
- [x] 5.3 Renderizar un diagrama mermaid de prueba con `mmdc -i test.mmd -o test.png -p "${PUPPETEER_CONFIG_PATH}"` y verificar que el archivo de salida se genera sin errores