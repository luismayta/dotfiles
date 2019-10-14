#
# See ./CONTRIBUTING.rst
#

OS := $(shell uname)
.PHONY: help
.DEFAULT_GOAL := help

HAS_PIP := $(shell command -v pip;)
HAS_PIPENV := $(shell command -v pipenv;)

ifdef HAS_PIPENV
	PIPENV_RUN:=pipenv run
	PIPENV_INSTALL:=pipenv install
else
	PIPENV_RUN:=
	PIPENV_INSTALL:=
endif

TEAM := private
PROJECT := dotfiles
PROJECT_PORT := 8000

PYTHON_VERSION=3.7.3
PYENV_NAME="${PROJECT}"

# Configuration.
SHELL ?=/bin/bash
ROOT_DIR=$(shell pwd)
MESSAGE:=🍺️
MESSAGE_HAPPY:="Done! ${MESSAGE}, Now Happy Coding"
SCRIPT_DIR=$(ROOT_DIR)/provision/script
SOURCE_DIR=$(ROOT_DIR)/
PROVISION_DIR:=$(ROOT_DIR)/provision
FILE_README:=$(ROOT_DIR)/README.rst
KEYBASE_PATH ?= /keybase/team/${TEAM}
KEYS_DIR:=${KEYBASE_PATH}/pem/
PASSWORD_DIR:=${KEYBASE_PATH}/password/
PATH_DOCKER_COMPOSE:=docker-compose.yml -f provision/docker-compose
RUN:= $(SHELL) "${SCRIPT_DIR}"/run.sh

DOCKER_COMPOSE:=$(PIPENV_RUN) docker-compose
DOCKER_COMPOSE_DEV=$(DOCKER_COMPOSE) -f ${PATH_DOCKER_COMPOSE}/dev.yml
DOCKER_COMPOSE_TEST=$(DOCKER_COMPOSE) -f ${PATH_DOCKER_COMPOSE}/test.yml

SERVICE_APP:=app
SERVICE_CHECK:=check

include provision/make/*.mk

help:
	@echo '${MESSAGE} Makefile for ${PROJECT}'
	@echo ''
	@echo 'Usage:'
	@echo '    environment               create environment with pyenv'
	@echo '    clean                     remove files of build'
	@echo '    setup                     install requirements'
	@echo '    run                       install scripts'
	@echo ''
	@make docker.help
	@make docs.help
	@make test.help

clean:
	@echo "=====> clean files unnecessary for ${TEAM}..."
ifneq (Darwin,$(OS))
	@sudo rm -rf .tox *.egg *.egg-info dist build .coverage .eggs .mypy_cache
	@sudo rm -rf docs/build
	@sudo find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.pyo' -delete -print -o -name '*~' -delete -print -o -name '*.tmp' -delete -print
else
	@rm -rf .tox *.egg *.egg-info dist build .coverage .eggs .mypy_cache
	@rm -rf docs/build
	@find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.pyo' -delete -print -o -name '*~' -delete -print -o -name '*.tmp' -delete -print
endif
	@echo "=====> end clean files unnecessary for ${TEAM}..."

setup: clean
	@echo "=====> install packages..."
	$(PIPENV_INSTALL) --dev --skip-lock
	$(PIPENV_RUN) pre-commit install
	@cp -rf provision/git/hooks/prepare-commit-msg .git/hooks/
	@[[ -e ".env" ]] || cp -rf .env.example .env
	@echo ${MESSAGE_HAPPY}

environment: clean
	@echo "=====> loading virtualenv ${PYENV_NAME}..."
	@pipenv --venv || $(PIPENV_INSTALL) --python ${PYTHON_VERSION} --skip-lock
