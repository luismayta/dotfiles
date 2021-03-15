test.help:
	@echo '    Tests:'
	@echo ''
	@echo '        test                      show help'
	@echo '        test.all   	             Run all module test'
	@echo '        test.lint                 Run all pre-commit'
	@echo ''

test:
	@echo $(MESSAGE) Running tests on the current Python interpreter with coverage $(END)
	make test.help

test.all:
	@echo $(MESSAGE) Running all tests $(END)
	make test.lint

test.lint:
	@echo $(MESSAGE) Running validator for pre-commit $(END)
	$(PIPENV_RUN) pre-commit run --all-files --verbose
