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

TEAM := luismayta
REPOSITORY_DOMAIN:=github.com
REPOSITORY_OWNER:=${TEAM}
AWS_VAULT ?= ${TEAM}
KEYBASE_OWNER ?= ${TEAM}
KEYBASE_PATH_TEAM_NAME ?=private
PROJECT := dotfiles
PROJECT_PORT := 3000

PYTHON_VERSION=3.8.0
NODE_VERSION=12.14.1
TERRAFORM_VERSION=0.12.20
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
KEYBASE_VOLUME_PATH ?= /Keybase
KEYBASE_TEAM_PATH ?=${KEYBASE_VOLUME_PATH}/${KEYBASE_PATH_TEAM_NAME}/${KEYBASE_OWNER}
KEYBASE_PROJECT_PATH ?= ${KEYBASE_TEAM_PATH}/${REPOSITORY_DOMAIN}/${REPOSITORY_OWNER}/${PROJECT}

PATH_DOCKER_COMPOSE:=docker-compose.yml -f provision/docker-compose
RUN:= $(SHELL) "${SCRIPT_DIR}"/run.sh

DOCKER_SERVICE_DEV:=app
DOCKER_SERVICE_TEST:=app

docker-compose:=$(PIPENV_RUN) docker-compose

docker-test:=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml
docker-dev:=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/dev.yml

docker-test-run:=$(docker-test) run --rm ${DOCKER_SERVICE_TEST}
docker-dev-run:=$(docker-dev) run --rm --service-ports ${DOCKER_SERVICE_DEV}

terragrunt:=terragrunt

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
	@make keybase.help
	@make utils.help

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
	make keybase.setup
	@pipenv --venv || $(PIPENV_INSTALL) --python=${PYTHON_VERSION} --skip-lock
	@echo ${MESSAGE_HAPPY}
