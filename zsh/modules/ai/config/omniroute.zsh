#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# OmniRoute configuration variables

export ZSH_AI_OMNIROUTE_PACKAGE_NAME=omniroute
export ZSH_AI_OMNIROUTE_INSTALL_CMD="bun add -g"
export ZSH_AI_OMNIROUTE_CONFIG_DIR="${HOME}/.omniroute"
export ZSH_AI_OMNIROUTE_DATA_PATH="${ZSH_AI_PATH}/data/omniroute"

# Runtime defaults (mirror OmniRoute .env defaults)
export ZSH_AI_OMNIROUTE_PORT=20128
export ZSH_AI_OMNIROUTE_HOST=0.0.0.0
export ZSH_AI_OMNIROUTE_BASE_URL="http://localhost:${ZSH_AI_OMNIROUTE_PORT}"
export ZSH_AI_OMNIROUTE_DATA_DIR="${ZSH_AI_OMNIROUTE_CONFIG_DIR}"
export ZSH_AI_OMNIROUTE_REQUIRE_API_KEY=false
export ZSH_AI_OMNIROUTE_CLI_OPENCODE_BIN=opencode
