# Docker
.PHONY: docker.help docker.build docker.test docker.pkg
PATH_DOCKER_COMPOSE:=provision/docker-compose
DOCKER_NETWORK = $(PROJECT)_network

docker.help:
	@echo '    Docker:'
	@echo ''
	@echo '        docker.build         build all services with docker-compose'
	@echo '        docker.down          down services docker-compose'
	@echo '        docker.ssh           connect by ssh to container'
	@echo '        docker.stop          stop services by env'
	@echo '        docker.verify_network           verify network'
	@echo '        docker.up             up services of docker-compose'
	@echo '        docker.run            run {service} {env}'
	@echo '        docker.list           list services of docker'
	@echo ''

docker.run: clean
	@if [ "${env}" == "" ]; then \
		docker-compose run --rm --service-ports "${service}" bash; \
	else \
		docker-compose -f docker-compose.yml -f "${PATH_DOCKER_COMPOSE}"/"${env}".yml run --rm --service-ports "${service}" bash; \
	fi

docker.build: clean
	@echo $(MESSAGE) "Building environment: ${env}"
	@if [ "${env}" == "" ]; then \
		docker volume create "${PROJECT}"-db; \
		docker volume create "${PROJECT}"-broker; \
		docker-compose build; \
	else \
		docker volume create "${PROJECT}-${env}"-db; \
		docker volume create "${PROJECT}-${env}"-broker; \
		docker-compose -f docker-compose.yml -f "${PATH_DOCKER_COMPOSE}"/"${env}".yml build; \
	fi

docker.down: clean
	@echo $(MESSAGE) "Down Services Environment: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose -p "${PROJECT}" down --remove-orphans; \
	else \
		docker-compose -f docker-compose.yml -f "${PATH_DOCKER_COMPOSE}"/"${env}".yml down --remove-orphans; \
	fi

docker.ssh: clean
	docker exec -it $(CONTAINER) bash

docker.stop: clean
	@echo $(MESSAGE) "Stop Services: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose -p "${PROJECT}" stop; \
	else \
		docker-compose -f docker-compose.yml -f "${PATH_DOCKER_COMPOSE}"/"${env}".yml stop; \
	fi

docker.verify_network: ## Verify network
	@if [ -z $$(docker network ls | grep $(DOCKER_NETWORK) | awk '{print $$2}') ]; then\
		(docker network create $(DOCKER_NETWORK));\
	fi

docker.up: clean
	@echo $(MESSAGE) "Up Services: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose -p "${PROJECT}" up --remove-orphans; \
	else \
		docker-compose -f docker-compose.yml -f "${PATH_DOCKER_COMPOSE}"/"${env}".yml up --remove-orphans; \
	fi

docker.list: clean
	@echo $(MESSAGE) "List Services: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose -p "${PROJECT_DEV}" ps; \
	else \
		docker-compose -f docker-compose.yml -f "${PATH_DOCKER_COMPOSE}"/"${env}".yml ps; \
	fi
