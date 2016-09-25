#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=src/load.sh
[ -r "src/load.sh" ] && source "src/load.sh"

cd "${ROOT_DIR}" || exit

pyenv virtualenv "${PYTHON_VERSION}" "${PYENV_NAME}" > /dev/null