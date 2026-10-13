# Task: Implementar tool freellmapi en el módulo ai

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Agregar freellmapi (router LLM local vía Docker Compose) como tool del módulo ai con arquitectura config/internal/pkg
- component: DevOps
- labels: [ai, dotfiles, zsh-module, docker]
- parentEpic: 
- issueKey: RD-233
- jpdSource: 

## Scenario

Como developer de dotfiles quiero gestionar el servicio freellmapi desde el módulo `ai`, con los mismos comandos que el resto de herramientas de IA, sin pasos manuales fuera del módulo.

freellmapi es un router/proxy LLM open source (MIT, Neu Software LLC) que agrega los free tiers de ~34-51 proveedores (Gemini, Groq, Cerebras, Mistral, OpenRouter, etc.) detrás de un único endpoint local compatible con OpenAI (`/v1`), además de `/v1/messages` (Anthropic) y emulación de Ollama. Se ejecuta como servicio Docker Compose con dashboard web.

Contexto técnico verificado (leyendo el instalador oficial completo):

- El instalador `https://freellmapi.co/install.sh` NO instala ningún binario en el PATH. Despliega un servicio Docker Compose: crea el directorio (default `~/freellmapi`, override con `FREELLMAPI_DIR`), escribe `.env` con un `ENCRYPTION_KEY` de 64 hex generado vía `openssl rand -hex 32` (fallback `/dev/urandom`), escribe `docker-compose.yml` fijado a `ghcr.io/tashfeenahmed/freellmapi:latest` con healthcheck `GET /api/ping`, volumen nombrado `freellmapi-data` y `restart: unless-stopped`, y luego ejecuta `docker compose pull` + `up -d`. Sondea el health endpoint hasta 60s.
- El script es idempotente: preserva un `.env` y una `ENCRYPTION_KEY` ya existentes. La actualización consiste en re-ejecutar el instalador.
- No hay shell hooks, completions ni exports de PATH.
- No existe subcomando `freellmapi install|upgrade|status|version`: el ciclo de vida es Docker puro (`docker compose up -d` / `down` / `ps` / `logs -f`), y el uninstall es `docker compose down -v && rm -rf ~/freellmapi`.
- Prerrequisitos: `bash`, `docker` con el plugin `docker compose` (o el binario legacy `docker-compose`), daemon corriendo, `curl`. `openssl` es opcional.
- Variables de entorno relevantes: `FREELLMAPI_DIR`, `PORT` (3001), `HOST_BIND` (127.0.0.1), `ENCRYPTION_KEY`, `WATCHTOWER_TOKEN`, `PROXY_URL`.
- La `ENCRYPTION_KEY` cifra las claves de proveedor en reposo (AES-256-GCM). Perderla obliga a reingresar todas las claves.
- Alcance acordado para esta task: SOLO el servicio Docker. El CLI npm `freellmapi` (bin homónimo, invocado vía `npx`/`bunx`, usado para configurar agentes como Claude Code / Codex) queda explícitamente fuera de alcance.


### Acceptance Tests

1. Crear `zsh/modules/ai/config/freellmapi.zsh` con cabecera `# shellcheck shell=bash`, declarando variables con prefijo `ZSH_AI_FREELLMAPI_`. Usar el patrón de `config/omp.zsh` y `config/tuicr.zsh`, y el sufijo moderno `<TOOL>_INSTALL_URL` (no el legacy `ZSH_AI_INSTALL_URL_<TOOL>`): `ZSH_AI_FREELLMAPI_PACKAGE_NAME`, `ZSH_AI_FREELLMAPI_INSTALL_URL`, `ZSH_AI_FREELLMAPI_DIR`, `ZSH_AI_FREELLMAPI_PORT`, `ZSH_AI_FREELLMAPI_HOST_BIND`, `ZSH_AI_FREELLMAPI_IMAGE`, `ZSH_AI_FREELLMAPI_HEALTH_URL`.
2. Crear `zsh/modules/ai/internal/freellmapi.zsh` usando el namespace real del módulo `ai::internal::freellmapi::*` (NO `ai::freellmapi::internal::*`, que es nomenclatura del módulo `devops`).
3. `ai::internal::freellmapi::load` no debe prepender nada al PATH (no hay binario). Debe ser un no-op seguro y no fallar si el directorio aún no existe.
4. El guard de "ya instalado" NO debe usar `core::exists freellmapi` (el instalador no crea binario). Debe verificar la existencia de `${ZSH_AI_FREELLMAPI_DIR}/docker-compose.yml` y/o que el daemon de Docker responde.
5. `ai::internal::freellmapi::install` debe validar prerrequisitos (`core::exists docker`, `core::exists curl`, plugin compose disponible) y abortar con `message_error` si faltan; luego ejecutar `curl -fsSL "${ZSH_AI_FREELLMAPI_INSTALL_URL}" | bash`; cerrar con `message_success`.
6. `ai::internal::freellmapi::upgrade` debe re-ejecutar el instalador (mismo mecanismo, preserva `.env` y la `ENCRYPTION_KEY`).
7. `ai::internal::freellmapi::status` debe reportar el estado del servicio (`docker compose ps` dentro de `${ZSH_AI_FREELLMAPI_DIR}` y/o `GET /api/ping`) usando `message_info` / `message_success` / `message_warning`.
8. Toda salida al usuario debe usar `message_*`. Prohibido `echo`.
9. Crear `zsh/modules/ai/pkg/freellmapi.zsh` con wrappers públicos de una línea (`ai::freellmapi::install`, `ai::freellmapi::upgrade`, `ai::freellmapi::status`) delegando a `ai::internal::freellmapi::*`.
10. Registrar el tool en los 4 puntos obligatorios del módulo:
    - `zsh/modules/ai/config/base.zsh`: añadir el `source "${ZSH_AI_PATH}/config/freellmapi.zsh"` respetando el orden de dependencias, y añadir `freellmapi` al array `ZSH_AI_TOOLS` (actualmente la última entrada es `omniroute`, línea 73, justo antes del `)` de cierre en la 74).
    - `zsh/modules/ai/internal/main.zsh`: añadir el `source` de `internal/freellmapi.zsh` y su llamada `ai::internal::freellmapi::load` en el bloque inferior de invocaciones de load.
    - `zsh/modules/ai/pkg/main.zsh`: añadir el `source` de `pkg/freellmapi.zsh`.
    - `zsh/modules/ai/internal/tools.zsh`: añadir la rama `freellmapi) ai::internal::freellmapi::install ;;` al `case` de `ai::internal::packages::install`. CRÍTICO: sin esta rama el `case` cae en `*) core::install "${package}"` y el instalador curl nunca se ejecuta.
11. No crear `data/freellmapi/` salvo que se implemente sync. El módulo `ai` no usa el patrón gomplate `render` (gomplate solo se usa en `zsh/modules/notify/`).
12. No usar rutas absolutas: solo `${HOME}` y `${ZSH_AI_PATH}`. No usar prefijos `DEVOPS_*` ni `AI_*`.
13. Verificación: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh` no debe emitir errores; `type ai::freellmapi::install` y `type ai::freellmapi::upgrade` deben devolver `function`; `ai::freellmapi::install` en una máquina limpia debe crear `${ZSH_AI_FREELLMAPI_DIR}` y dejar el contenedor `up`; una segunda invocación debe ser no-op (idempotencia confirmada por el propio script).
14. `ai::freellmapi::post_install` debe indicar los próximos pasos: abrir el dashboard en `http://${ZSH_AI_FREELLMAPI_HOST_BIND}:${ZSH_AI_FREELLMAPI_PORT}`, agregar las claves de proveedor desde la sección Keys, apuntar los clientes al endpoint `/v1` (y `/v1/messages` para Anthropic), y advertir que perder la `ENCRYPTION_KEY` obliga a reingresar todas las claves.
15. Si se documenta la tool en `zsh/modules/ai/README.yaml` (fuente de verdad; `README.md` es generado por gomplate vía `Taskfile.yml`), editar SOLO el YAML. Nunca editar `README.md` directamente.


### Sources

- https://freellmapi.co/install.sh — instalador oficial (leído completo)
- https://freellmapi.co — sitio oficial
- https://github.com/tashfeenahmed/freellmapi — repositorio open source (MIT, Neu Software LLC)
- https://raw.githubusercontent.com/tashfeenahmed/freellmapi/main/docs/en/install/01-install.md — guía de instalación
- https://raw.githubusercontent.com/tashfeenahmed/freellmapi/main/cli/README.md — referencia del CLI npm (fuera de alcance)
- docs/guides/implement-tool-in-module.md — guía de tres capas. ADVERTENCIA: usa nomenclatura `DEVOPS_*` / `devops::<tool>::internal::*`; hay que adaptarla a `ZSH_AI_*` / `ai::internal::<tool>::*` para el módulo `ai`
- zsh/modules/ai/config/omp.zsh, zsh/modules/ai/internal/omp.zsh, zsh/modules/ai/pkg/omp.zsh — referencia principal: instalador curl + rsync de `data/`
- zsh/modules/ai/config/tuicr.zsh, zsh/modules/ai/internal/tuicr.zsh, zsh/modules/ai/pkg/tuicr.zsh — referencia secundaria: instalador curl con guard explícito de `curl`

- https://github.com/luismayta/dotfiles.git