#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

cd "${ROOT_DIR}" || exit

pyenv virtualenv "${PYTHON_VERSION}" "${PYENV_NAME}" > /dev/null