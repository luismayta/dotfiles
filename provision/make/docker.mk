# Docker
.PHONY: docker.help
DOCKER_NETWORK = $(PROJECT)_network

docker: docker.help

docker.help:
	@echo '    Docker:'
	@echo ''
	@echo '        docker.build         build all or one example: make docker.build service={services}  args=(--pull|...)'
	@echo '        docker.down          down services docker-compose'
	@echo '        docker.exec          exec command in container by {services} {command}'
	@echo '        docker.ssh           connect by ssh to container'
	@echo '        docker.stop          stop services by stage'
	@echo '        docker.log           log {service} {stage}'
	@echo '        docker.verify_network           verify network'
	@echo '        docker.up             up services of docker-compose'
	@echo '        docker.run            run {service} {stage}'
	@echo '        docker.restart        restart by {stage}'
	@echo '        docker.list           list services of docker'
	@echo ''

docker.run:
	@if [ -z "${stage}" ]; then \
		$(docker-dev) run --rm ${service} bash; \
	else \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml run --rm ${service} bash; \
	fi

docker.restart:
	@if [ -z "${stage}" ]; then \
		$(docker-dev) restart; \
	else \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml restart; \
	fi

docker.build:
	@echo $(MESSAGE) "Building stage: ${stage} ${service}"
	@if [ -z "${stage}" ] && [ -z "${service}" ]; then \
		$(docker-dev) build ${args}; \
	elif [ -z "${stage}" ] && [ -n "${service}" ]; then \
		$(docker-dev) build ${service} ${args}; \
	elif [ -n "${stage}" ] && [ -z "${service}" ]; then \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml build ${args}; \
	elif [ -n "${stage}" ] && [ -n "${service}" ]; then \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml build ${service} ${args}; \
	fi

docker.log:
	@echo $(MESSAGE) "Building environment: ${stage} ${service}"
	@if [ -z "${stage}" ] && [ -z "${service}" ]; then \
		$(docker-dev) logs -f ; \
	elif [ -z "${stage}" ] && [ -n "${service}" ]; then \
		$(docker-dev) logs -f ${service}; \
	elif [ -n "${stage}" ] && [ -z "${service}" ]; then \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml logs -f; \
	elif [ -n "${stage}" ] && [ -n "${service}" ]; then \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml logs -f ${service} ; \
	fi

docker.down:
	@echo $(MESSAGE) "Down Services Stage: ${stage}"
	@if [ -z "${stage}" ]; then \
		$(docker-dev) down --remove-orphans; \
		$(docker-test) down --remove-orphans; \
	else \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml down --remove-orphans; \
	fi

docker.exec:
	@echo $(MESSAGE) "Exec Services Stage: ${stage}"
	@if [ -z "${stage}" ]; then \
		$(docker-dev) exec ${service} ${command} ; \
	else \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml exec ${service} ${command} ; \
	fi

docker.stop:
	@echo $(MESSAGE) "Stop Services: ${stage}"
	@if [ "${stage}" == "" ]; then \
		$(docker-dev) stop; \
	else \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml stop; \
	fi

docker.verify_network: ## Verify network
	@if [ -z $$(docker network ls | grep $(DOCKER_NETWORK) | awk '{print $$2}') ]; then\
		(docker network create $(DOCKER_NETWORK));\
	fi

docker.up:
	@echo $(MESSAGE) "Up Services: ${stage}"
	@if [ -z "${stage}" ]; then \
		$(docker-dev) up --remove-orphans; \
	else \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml up --remove-orphans; \
	fi

docker.list:
	@echo $(MESSAGE) "List Services: ${stage}"
	@if [ -z "${stage}" ]; then \
		$(docker-dev) ps; \
	else \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml ps; \
	fi
