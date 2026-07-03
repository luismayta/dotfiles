## 1. Config — Variables de entorno

- [x] 1.1 Agregar `AI_PI_BIN_PATH` apuntando a `~/.local/bin` en `config/base.zsh`
- [x] 1.2 Agregar `AI_PI_CONFIG_PATH` apuntando a `~/.pi/agent` en `config/base.zsh`
- [x] 1.3 Agregar `AI_PI_CONFIG_SOURCE_PATH` apuntando a `$AI_PATH/data/pi` en `config/base.zsh`
- [x] 1.4 Agregar `AI_INSTALL_URL_PI` con `https://pi.dev/install.sh` en `config/base.zsh`
- [x] 1.5 Agregar `pi` al array `AI_TOOLS` en `config/base.zsh`

## 2. Internal — PATH loading, instalación y sync de config

- [x] 2.1 Agregar función `ai::internal::pi::load` que añade `~/.local/bin` al PATH si `pi` existe
- [x] 2.2 Agregar función `ai::internal::pi::install` que ejecuta `curl -fsSL <URL> | sh`
- [x] 2.3 Agregar función `ai::internal::pi::config::sync` que rsync `data/pi/` a `~/.pi/agent/`
- [x] 2.4 Agregar case `pi)` en `ai::internal::packages::install`
- [x] 2.5 Agregar llamada `ai::internal::pi::load` en `internal/main.zsh`

## 3. Data files — Configuración base de Pi con OpenCode Zen

- [x] 3.1 Crear `data/pi/settings.json` con provider default OpenCode Zen
- [x] 3.2 Crear `data/pi/models.json` con OpenCode Zen como provider y modelo `opencode/big-pickle`

## 4. Public API — Wrappers

- [x] 4.1 Agregar `ai::pi::install` en `pkg/helper.zsh`
- [x] 4.2 Agregar `ai::pi::config::sync` en `pkg/helper.zsh`
- [x] 4.3 Agregar `ai::pi::config::sync` en `ai::sync` en `pkg/helper.zsh`
