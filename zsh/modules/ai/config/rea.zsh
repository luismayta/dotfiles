# shellcheck shell=bash
# REA (Reverse Engineer Anything) configuration variables

# Pinned package spec — the MCP template and the installer must agree on the same version
export ZSH_AI_REA_PACKAGE_NAME="rea-agents"
export ZSH_AI_REA_VERSION="6.7.0"
export ZSH_AI_REA_PACKAGE_SPEC="${ZSH_AI_REA_PACKAGE_NAME}@${ZSH_AI_REA_VERSION}"

# Install method: curl (default), npm or bun
export ZSH_AI_REA_INSTALL_METHOD="${ZSH_AI_REA_INSTALL_METHOD:-curl}"

# Upstream installer (used by the curl method)
export ZSH_AI_REA_INSTALL_URL="https://raw.githubusercontent.com/morluto/rea/main/install.sh"

# Local paths
export ZSH_AI_REA_BIN_PATH="${HOME}/.local/bin"
export ZSH_AI_REA_SKILLS_DIR="${HOME}/.agents/skills"
export ZSH_AI_REA_SKILL_NAME="reverse-engineer-anything"
export ZSH_AI_REA_STATE_DIR="${HOME}/.rea"
