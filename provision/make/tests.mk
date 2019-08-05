docker_test=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml

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
		$(docker_test) run --rm $(DOCKER_SERVICE) bash -c "pipenv run py.test ${run}";\
	fi

test.all: clean
	@echo $(MESSAGE) Running tests on the current Python interpreter with coverage $(END)
	$(docker_test) run --rm $(DOCKER_SERVICE) bash -c "pipenv run py.test"

test.picked: clean
	$(docker_test) run --rm $(DOCKER_SERVICE) bash -c "pipenv run py.test --picked"

test.validate: clean
	@echo $(MESSAGE) Running tests validation fixture $(END)
	$(docker_test) run --rm $(DOCKER_SERVICE) bash -c "pipenv run py.test --dead-fixtures"

test.lint: clean
	pre-commit run --all-files --verbose

test.lint.docker: clean
	$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/dev.yml \
		run --rm check sh -c "pipenv run pre-commit run --all-files --verbose"

test.syntax: clean
	@echo $(MESSAGE) Running tests $(END)
