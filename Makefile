#
# See ./CONTRIBUTING.rst
#

OS := $(shell uname)
.PHONY: help
.DEFAULT_GOAL := help

PROJECT := dotfiles

PYTHON_VERSION=3.7.3
PYENV_NAME="${PROJECT}"

# Configuration.
SHELL ?=/bin/bash
ROOT_DIR=$(shell pwd)
MESSAGE:=🍺️
MESSAGE_HAPPY:="Done! ${MESSAGE}, Now Happy Coding"
SCRIPT_DIR=$(ROOT_DIR)/extras/script
SOURCE_DIR=$(ROOT_DIR)/
PROVISION_DIR:=$(ROOT_DIR)/provision
FILE_README:=$(ROOT_DIR)/README.rst
PATH_DOCKER_COMPOSE:=docker-compose.yml -f provision/docker-compose
RUN:= $(SHELL) "${SCRIPT_DIR}"/run.sh
DOCKER_SERVICE:=app

pipenv_install:=pipenv install
docker-compose:=docker-compose

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
	@echo "$(TAG)"Cleaning up"$(END)"
ifneq (Darwin,$(OS))
	@sudo rm -rf .tox *.egg *.egg-info dist build .coverage .eggs .mypy_cache
	@sudo rm -rf docs/build
	@sudo find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.pyo' -delete -print -o -name '*~' -delete -print -o -name '*.tmp' -delete -print
else
	@rm -rf .tox *.egg *.egg-info dist build .coverage .eggs .mypy_cache
	@rm -rf docs/build
	@find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.pyo' -delete -print -o -name '*~' -delete -print -o -name '*.tmp' -delete -print
endif
	@echo

setup: clean
	@echo "=====> install packages..."
	$(pipenv_install) --dev
	@pre-commit install
	@cp -rf .hooks/prepare-commit-msg .git/hooks/
	@if [ ! -e ".env" ]; then \
		@cp -rf .env-sample .env;\
	fi

environment: clean
	@echo "=====> loading virtualenv ${PYENV_NAME}..."
	$(pipenv_install) --system --python ${PYTHON_VERSION}
