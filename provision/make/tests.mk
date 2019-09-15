test.help:
	@echo '    Tests:'
	@echo ''
	@echo '        test                      show help'
	@echo '        test run={module}         Run module test'
	@echo '        test.all   	             Run all module test'
	@echo '        test.picked               run test only commit'
	@echo '        test.lint                 Run all pre-commit'
	@echo '        test.lint.docker          Run all pre-commit in docker'
	@echo '        test.syntax               Run all syntax in code'
	@echo '        test.validate           Run all validation fixture dead in code'
	@echo ''

test: clean
	@echo $(MESSAGE) Running tests on the current Python interpreter with coverage $(END)
	@if [ -z "${run}" ]; then \
		make test.help;\
	fi
	@if [ -n "${run}" ]; then \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml run --rm \
			app bash -c "$(PIPENV_RUN) pytest ${run}" ; \
	fi

test.all: clean
	@echo $(MESSAGE) Running tests on the current Python interpreter with coverage $(END)
	$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml run --rm \
		app bash -c "$(PIPENV_RUN) pytest"

test.picked: clean
	$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml run --rm \
		app bash -c "$(PIPENV_RUN) pytest --picked"

test.validate: clean
	@echo $(MESSAGE) Running tests validation fixture $(END)
	$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml run --rm \
		app bash -c "$(PIPENV_RUN) pytest --dead-fixtures"

test.lint: clean
	$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml run --rm \
		app bash -c "$(PIPENV_RUN) pre-commit run --all-files --verbose"

test.lint.docker: clean
	$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/dev.yml \
		run --rm check sh -c "$(PIPENV_RUN) pre-commit run --all-files --verbose"

test.syntax: clean
	@echo $(MESSAGE) Running tests $(END)
