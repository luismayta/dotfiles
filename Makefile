#
# See ./CONTRIBUTING.rst
#

.PHONY: help
.DEFAULT_GOAL := help

PROJECT := dotfiles

PYTHON_VERSION ?=3.6.5
PYENV_NAME="${PROJECT}"

# Configuration.
SHELL ?= /bin/bash
ROOT_DIR=$(shell pwd)
MESSAGE:=🍺️
MESSAGE_HAPPY:="Done! ${MESSAGE} Now Happy Coding"
SCRIPT_DIR=$(ROOT_DIR)/extras/script
SOURCE_DIR=$(ROOT_DIR)/
REQUIREMENTS_DIR=$(ROOT_DIR)/requirements
PROVISION_DIR:=$(ROOT_DIR)/provision
FILE_README:=$(ROOT_DIR)/README.rst
PATH_DOCKER_COMPOSE:=provision/docker-compose
RUN:= $(SHELL) "${SCRIPT_DIR}"/run.sh

pip_install := pip install -r
docker-compose:=docker-compose -f docker-compose.yml

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
	@rm -rf .tox *.egg dist build .coverage .pytest_cache
	@rm -rf docs/build
	@find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.tmp' -delete -print

setup: clean
	$(pip_install) "${REQUIREMENTS_DIR}/setup.txt"
	@if [ -e "${REQUIREMENTS_DIR}/private.txt" ]; then \
			$(pip_install) "${REQUIREMENTS_DIR}/private.txt"; \
	fi
	pre-commit install
	cp -rf .hooks/prepare-commit-msg .git/hooks/
	@if [ ! -e ".env" ]; then \
		cp -rf .env-sample .env;\
	fi

environment: clean
	@echo "=====> loading virtualenv ${PYENV_NAME}..."
	@pyenv virtualenv ${PYTHON_VERSION} ${PYENV_NAME} >> /dev/null 2>&1; \
	@pyenv activate ${PYENV_NAME} >> /dev/null 2>&1 || echo $(MESSAGE_HAPPY)

run: clean
	@echo $(MESSAGE) "Install environment"
	$(RUN)
