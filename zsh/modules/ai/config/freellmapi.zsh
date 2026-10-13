# shellcheck shell=bash
# freellmapi configuration variables (Docker Compose gateway, no PATH binary)

export ZSH_AI_FREELLMAPI_PACKAGE_NAME=freellmapi
export ZSH_AI_FREELLMAPI_INSTALL_URL="https://freellmapi.co/install.sh"
export ZSH_AI_FREELLMAPI_DIR="${HOME}/freellmapi"

# Runtime defaults (mirror upstream installer .env defaults)
export ZSH_AI_FREELLMAPI_PORT=3001
export ZSH_AI_FREELLMAPI_HOST_BIND=127.0.0.1
export ZSH_AI_FREELLMAPI_IMAGE=ghcr.io/tashfeenahmed/freellmapi:latest
export ZSH_AI_FREELLMAPI_HEALTH_URL="http://${ZSH_AI_FREELLMAPI_HOST_BIND}:${ZSH_AI_FREELLMAPI_PORT}/api/ping"
