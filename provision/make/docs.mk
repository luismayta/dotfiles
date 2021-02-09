#
# See ./CONTRIBUTING.rst
#

docs:
	make docs.help

docs.help:
	@echo '    Docs:'
	@echo ''
	@echo '        docs.show                  Show mkdocs'
	@echo '        docs.build                 build mkdocs'
	@echo ''

docs.show:
	$(PIPENV_RUN) mkdocs serve

docs.build:
	$(PIPENV_RUN) mkdocs build

