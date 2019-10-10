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
	@echo '        test.validate             Run all validation fixture dead in code'
	@echo ''

test: clean
	@echo $(MESSAGE) Running tests on the current Python interpreter with coverage $(END)
	@if [ -z "${run}" ]; then \
		make test.help;\
	fi
	@if [ -n "${run}" ]; then \
		$(DOCKER_COMPOSE_TEST) run --rm $(SERVICE_APP) bash -c \
			"$(PIPENV_RUN) py.test ${run}";\
	fi

test.all: clean
	@echo $(MESSAGE) Running tests on the current Python interpreter with coverage $(END)
	$(DOCKER_COMPOSE_TEST) run --rm $(SERVICE_APP) bash -c \
		"$(PIPENV_RUN) pytest"

test.picked: clean
	$(DOCKER_COMPOSE_TEST) run --rm $(SERVICE_APP) bash -c \
		"$(PIPENV_RUN) pytest --picked"

test.validate: clean
	@echo $(MESSAGE) Running tests validation fixture $(END)
	$(DOCKER_COMPOSE_TEST) run --rm $(SERVICE_APP) bash -c \
		"$(PIPENV_RUN) pytest --dead-fixtures"

test.lint: clean
	$(PIPENV_RUN) pre-commit run --all-files --verbose

test.lint.docker: clean
	$(DOCKER_COMPOSE_TEST) run --rm $(SERVICE_CHECK) bash -c \
		"$(PIPENV_RUN) pre-commit run --all-files --verbose"

test.syntax: clean
	@echo $(MESSAGE) Running tests $(END)
