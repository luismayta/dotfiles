#
# See ./CONTRIBUTING.rst
#
PATH_DOCKER_COMPOSE:=provision/docker-compose
DOCKER_TEST := docker-compose -f docker-compose.yml -f "${PATH_DOCKER_COMPOSE}"/test.yml

test.help:
	@echo '    Tests:'
	@echo ''
	@echo '        test                      show help test'
	@echo '        test.all                  Run all test'
	@echo '        test.run                  Run module test'
	@echo '        test.lint                 Run all pre-commit'
	@echo '        test.syntax               Run all syntax in code'
	@echo ''

test: clean
	@if [[ -z "${run}" ]]; then \
		make test.help;\
	fi
	@if [[ -n "${run}" ]]; then \
		$(DOCKER_TEST) run --rm app bash -c "pytest tests/${run}";\
	fi

test.all: clean
	$(DOCKER_TEST) run --rm app bash -c "pytest "

test.lint: clean
	pre-commit run --all-files --verbose

test.syntax: clean
	@echo $(MESSAGE) Running tests $(END)
