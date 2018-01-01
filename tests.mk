#
# See ./CONTRIBUTING.rst
#

test.help:
	@echo '    Tests:'
	@echo ''
	@echo '        test                      Run all test'
	@echo '        test.lint                 Run all pre-commit'
	@echo '        test.syntax               Run all syntax in code'
	@echo ''

test: clean
	@echo $(MESSAGE) Running tests $(END)

test.lint: clean
	pre-commit run --all-files --verbose

test.syntax: clean
	@echo $(MESSAGE) Running tests $(END)
