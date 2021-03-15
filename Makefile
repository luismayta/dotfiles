#
# See ./docs/contributing.md
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
PROJECT := dotfiles

PYTHON_VERSION=3.8.0
NODE_VERSION=14.15.5
PYENV_NAME="${PROJECT}"
GIT_IGNORES:=python,node,go,zsh
GI:=gi

# Configuration.
SHELL ?=/bin/bash
ROOT_DIR=$(shell pwd)
MESSAGE:=🍺️
MESSAGE_HAPPY?:="Done! ${MESSAGE}, Now Happy Hacking"
SCRIPT_DIR=$(ROOT_DIR)/provision/script
SOURCE_DIR=$(ROOT_DIR)
PROVISION_DIR:=$(ROOT_DIR)/provision
DOCS_DIR:=$(ROOT_DIR)/docs
README_TEMPLATE:=$(PROVISION_DIR)/templates/README.tpl.md

export README_FILE ?= README.md
export README_YAML ?= provision/generators/README.yaml
export README_INCLUDES ?= $(file://$(shell pwd)/?type=text/plain)

FILE_README:=$(ROOT_DIR)/README.md

PATH_DOCKER_COMPOSE:=docker-compose.yml -f provision/docker-compose
RUN:= $(SHELL) "${SCRIPT_DIR}"/run.sh

DOCKER_SERVICE_DEV:=app
DOCKER_SERVICE_TEST:=app

docker-compose:=$(PIPENV_RUN) docker-compose

docker-test:=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml
docker-dev:=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/dev.yml

docker-test-run:=$(docker-test) run --rm ${DOCKER_SERVICE_TEST}
docker-dev-run:=$(docker-dev) run --rm --service-ports ${DOCKER_SERVICE_DEV}
docker-yarn-run:=$(docker-dev) run --rm --service-ports ${DOCKER_SERVICE_YARN}

include provision/make/*.mk

help:
	@echo '${MESSAGE} Makefile for ${PROJECT}'
	@echo ''
	@echo 'Usage:'
	@echo '    environment               create environment with pyenv'
	@echo '    readme                    build README'
	@echo '    setup                     install requirements'
	@echo '    run                       install scripts'
	@echo ''
	@make alias.help
	@make docker.help
	@make docs.help
	@make test.help
	@make git.help
	@make utils.help
	@make python.help
	@make yarn.help

## Create README.md by building it from README.yaml
readme:
	@gomplate --file $(README_TEMPLATE) \
		--out $(README_FILE)

setup:
	@echo "==> install packages..."
	make python.setup
	make python.precommit
	@cp -rf provision/git/hooks/prepare-commit-msg .git/hooks/
	@[ -e ".env" ] || cp -rf .env.example .env
	make yarn.setup
	make git.setup
	@echo ${MESSAGE_HAPPY}

run:
	@echo "==> run ..."
	$(RUN)

environment:
	@echo "==> loading virtualenv ${PYENV_NAME}..."
	make python.environment
	@echo ${MESSAGE_HAPPY}
