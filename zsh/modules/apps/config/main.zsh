# shellcheck shell=bash
# shellcheck disable=SC1091
source "${ZSH_APPS_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_APPS_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZSH_APPS_PATH}/config/linux.zsh" ;;
esac

APPS_PACKAGES=(
    "${APPS_IDE_TOOLS[@]}"
    "${APPS_VPN_CLIENTS[@]}"
    "${APPS_JETBRAINS[@]}"
    "${APPS_COMMUNICATION[@]}"
    "${APPS_KNOWLEDGE[@]}"
    "${APPS_DEVOPS[@]}"
    "${APPS_BROWSER[@]}"
    "${APPS_ANDROID[@]}"
    "${APPS_MOBILE[@]}"
    "${APPS_DATABASE_CLIENTS[@]}"
    "${APPS_PROJECT_MANAGEMENT[@]}"
    "${APPS_WEB_APPS[@]}"
)
export APPS_PACKAGES
