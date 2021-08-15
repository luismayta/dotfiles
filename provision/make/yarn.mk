#
# See ./docs/contributing.md
#

## show commands help.
.PHONY: yarn.help
yarn.help:
	@echo '    yarn:'
	@echo ''
	@echo '        yarn                       command=(build|dev|start|export)'
	@echo '        yarn.setup                 Install dependences of project'
	@echo '        yarn.install               Install dependences'
	@echo '        yarn.dev                   dev project'
	@echo '        yarn.start                 run project'
	@echo '        yarn.export                export project'
	@echo '        yarn.build                 build or with stage=(prod)'
	@echo ''

## Show commands yarn.
.PHONY: yarn
yarn:
	@if [ -z "${command}" ]; then \
		make yarn.help;\
	fi
	@if [ -n "${command}" ]; then \
		mkdir -p public;\
		$(docker-yarn-run) yarn ${command};\
	fi

## Setup download and install dependence.
.PHONY: yarn.setup
yarn.setup:
	@echo "==> setup dependence yarn..."
	yarn install
	@echo ${MESSAGE_HAPPY}

## Setup environment nvm version node.
.PHONY: yarn.environment
yarn.environment:
	@echo "==> environment yarn..."
	nvm use ${NODE_VERSION}
	@echo ${MESSAGE_HAPPY}

## Install dependences in docker.
.PHONY: yarn.install
yarn.install:
	$(docker-yarn-run) yarn install

## Start yarn docker package.
.PHONY: yarn.start
yarn.start:
	$(docker-yarn-run) yarn start

## Build yarn docker package.
.PHONY: yarn.build
yarn.build:
	@if [ -z "${stage}" ]; then \
		$(docker-yarn-run) yarn build; \
	else \
		$(docker-yarn-run) yarn build:${stage}; \
	fi

## Run yarn dev docker.
.PHONY: yarn.dev
yarn.dev:
	$(docker-yarn-run) yarn dev

## Run yarn export with docker.
.PHONY: yarn.export
yarn.export:
	$(docker-yarn-run) yarn export
