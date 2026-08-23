# shellcheck shell=bash
ZSH_PYTHON_ENABLED="${ZSH_PYTHON_ENABLED:-true}"

export PYTHON_UV_ENABLED="${PYTHON_UV_ENABLED:-true}"

export PYTHON_INSTALL_URL="https://astral.sh/uv/install.sh"

export PYTHON_PACKAGE_NAME=uv

export PYTHON_VIRTUALENV_DISABLE_PROMPT=1
export PYTHON_VERSIONS=(
    3.11
    3.12
    3.13
    3.14
)
export PYTHON_VERSION_GLOBAL=3.14
export PYTHON_MODULES=(
    lastversion
    ansible
    ansible-lint
    checkov
    pip
    pipx
    pyright
    opencv-python
    pycodestyle
    pylint
    beautysh
    poetry
    pipenv-poetry-migrate
    jupyterlab
    notebook
    voila
    faster-whisper
)

# poetry
export POETRY_VIRTUALENVS_IN_PROJECT=true

export ZSH_PYTHON_LAZY_VIRTUALENV=true
