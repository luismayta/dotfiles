# shellcheck shell=bash
ZSH_PYTHON_ENABLED="${ZSH_PYTHON_ENABLED:-true}"

export PYTHON_PYENV_ENABLED="${PYTHON_PYENV_ENABLED:-true}"
export PYTHON_UV_ENABLED="${PYTHON_UV_ENABLED:-true}"

export PYTHON_ROOT="${HOME}/.pyenv"
export PYTHON_ROOT_BIN="${HOME}/.pyenv/bin"
export PYTHON_VIRTUALENV_DISABLE_PROMPT=1
export PYTHON_PACKAGE_NAME=pyenv
export PYTHON_VERSIONS=(
    anaconda3-5.3.1
    miniconda3-4.3.30
    3.10.6
    3.11.5
)
export PYTHON_VERSION_GLOBAL=3.11.5
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
)

# poetry
export POETRY_VIRTUALENVS_IN_PROJECT=true

export ZSH_PYTHON_LAZY_VIRTUALENV=true

export PYTHON_INSTALL_URL="https://github.com/pyenv/pyenv.git"
