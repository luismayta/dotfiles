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
AWS_VAULT ?= luismayta
PROJECT := dotfiles
PROJECT_PORT := 8000

PYTHON_VERSION=3.8.0
NODE_VERSION=v12.14.1
PYENV_NAME="${PROJECT}"

# Configuration.
SHELL ?=/bin/bash
ROOT_DIR=$(shell pwd)
MESSAGE:=🍺️
MESSAGE_HAPPY:="Done! ${MESSAGE}, Now Happy Hacking"
SCRIPT_DIR=$(ROOT_DIR)/provision/script
SOURCE_DIR=$(ROOT_DIR)/
PROVISION_DIR:=$(ROOT_DIR)/provision
FILE_README:=$(ROOT_DIR)/README.rst
KEYBASE_PATH ?= /keybase/team/${TEAM}
KEYS_DIR:=${KEYBASE_PATH}/pem/
PASSWORD_DIR:=${KEYBASE_PATH}/password/
PATH_DOCKER_COMPOSE:=docker-compose.yml -f provision/docker-compose
RUN:= $(SHELL) "${SCRIPT_DIR}"/run.sh

DOCKER_SERVICE_DEV:=app
DOCKER_SERVICE_TEST:=app

docker-compose:=$(PIPENV_RUN) docker-compose

docker-test:=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml
docker-dev:=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/dev.yml

docker-test-run:=$(docker-test) run --rm ${DOCKER_SERVICE_TEST}
docker-dev-run:=$(docker-dev) run --rm --service-ports ${DOCKER_SERVICE_DEV}

include provision/make/*.mk

help:
	@echo '${MESSAGE} Makefile for ${PROJECT}'
	@echo ''
	@echo 'Usage:'
	@echo '    environment               create environment with pyenv'
	@echo '    setup                     install requirements'
	@echo '    run                       install scripts'
	@echo ''
	@make alias.help
	@make docker.help
	@make docs.help
	@make test.help


setup:
	@echo "=====> install packages..."
	pyenv local ${PYTHON_VERSION}
	yarn
	$(PIPENV_INSTALL) --dev --skip-lock
	$(PIPENV_RUN) pre-commit install
	$(PIPENV_RUN) pre-commit install -t pre-push
	@cp -rf provision/git/hooks/prepare-commit-msg .git/hooks/
	@[ -e ".env" ] || cp -rf .env.example .env
	@echo ${MESSAGE_HAPPY}

run:
	@echo "=====> run ..."
	$(RUN)

environment:
	@echo "=====> loading virtualenv ${PYENV_NAME}..."
	pyenv local ${PYTHON_VERSION}
	@pipenv --venv || $(PIPENV_INSTALL) --python=${PYTHON_VERSION} --skip-lock
	@echo ${MESSAGE_HAPPY}
