# Docker
.PHONY: docker.build docker.test docker.pkg

DOCKER_NETWORK = $(PROJECT_NAME)_network

docker.run: clean
	@if [ "${env}" == "" ]; then \
		docker-compose run --rm --service-ports "${service}" bash; \
	else \
		docker-compose -f docker-compose.yml -f docker-compose/"${env}".yml run --rm --service-ports "${service}" bash; \
	fi

docker.build: clean
	@echo $(MESSAGE) "Building environment: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose build --pull --no-cache; \
	else \
		docker-compose -f docker-compose.yml -f docker-compose/"${env}".yml build --pull --no-cache; \
	fi

docker.down: clean
	@echo $(MESSAGE) "Down Services Environment: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose -p "${PROJECT_NAME}" down --remove-orphans; \
	else \
		docker-compose -f docker-compose.yml -f docker-compose/"${env}".yml down --remove-orphans; \
	fi

docker.ssh: clean
	docker exec -it $(CONTAINER) bash

docker.stop: clean
	@echo $(MESSAGE) "Stop Services: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose -p "${PROJECT_NAME}" stop; \
	else \
		docker-compose -f docker-compose.yml -f docker-compose/"${env}".yml stop; \
	fi

docker.verify_network: ## Verify network
	@if [ -z $$(docker network ls | grep $(DOCKER_NETWORK) | awk '{print $$2}') ]; then\
		(docker network create $(DOCKER_NETWORK));\
	fi

docker.up: clean
	@echo $(MESSAGE) "Up Services: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose -p "${PROJECT_NAME}" up --remove-orphans; \
	else \
		docker-compose -f docker-compose.yml -f docker-compose/"${env}".yml up --remove-orphans; \
	fi

docker.list: clean
	@echo $(MESSAGE) "List Services: ${env}"
	@if [ "${env}" == "" ]; then \
		docker-compose -p "${PROJECT_NAME_DEV}" ps; \
	else \
		docker-compose -f docker-compose.yml -f docker-compose/"${env}".yml ps; \
	fi
