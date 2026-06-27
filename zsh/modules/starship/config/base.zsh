#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
ZSH_STARSHIP_ENABLED="${ZSH_STARSHIP_ENABLED:-true}"

export ZSH_HOME_CONF_PATH="${HOME}/.config"
export STARSHIP_PACKAGE_NAME=starship
export STARSHIP_FILE_SETTINGS="${ZSH_HOME_CONF_PATH}"/starship.toml
export STARSHIP_CACHE="${HOME}/.cache/starship"
export ZSH_STARSHIP_DATA_PATH="${ZSH_STARSHIP_PATH}/data"
