#
# See ./docs/contributing.md
#
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

# setup download and install dependence.
.PHONY: yarn.setup
yarn.setup:
	@echo "=====> setup dependence yarn..."
	yarn install
	@echo ${MESSAGE_HAPPY}

.PHONY: yarn.environment
yarn.environment:
	@echo "=====> enviroment yarn..."
	nvm use ${NODE_VERSION}
	@echo ${MESSAGE_HAPPY}

yarn.install:
	$(docker-yarn-run) yarn install

yarn.start:
	$(docker-yarn-run) yarn start

yarn.build:
	@if [ -z "${stage}" ]; then \
		$(docker-yarn-run) yarn build; \
	else \
		$(docker-yarn-run) yarn build:${stage}; \
	fi

yarn.dev:
	$(docker-yarn-run) yarn dev

yarn.export:
	$(docker-yarn-run) yarn export

yarn:
	@if [ -z "${command}" ]; then \
		make yarn.help;\
	fi
	@if [ -n "${command}" ]; then \
		mkdir -p public;\
		$(docker-yarn-run) yarn ${command};\
	fi
