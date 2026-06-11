# shellcheck shell=bash

export PYENV_ROOT="${HOME}/.pyenv"
export PYENV_ROOT_BIN="${HOME}/.pyenv/bin"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_PACKAGE_NAME=pyenv
export PYENV_VERSIONS=(
    anaconda3-5.3.1
    miniconda3-4.3.30
    3.10.6
    3.11.5
)
export PYENV_VERSION_GLOBAL=3.11.5
export PYENV_MODULES=(
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

export ZSH_PYENV_LAZY_VIRTUALENV=true

export PYENV_INSTALL_URL="https://github.com/pyenv/pyenv.git"
