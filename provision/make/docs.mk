#
# See ./docs/contributing.md
#

docs:
	make docs.help

docs.help:
	@echo '    Docs:'
	@echo ''
	@echo '        docs.show                  Show grip readme'
	@echo '        docs.build                 Show mkdocs'
	@echo '        docs.serve                 server Make documentation'
	@echo ''

docs.show:
	$(PIPENV_RUN) grip

docs.build:
	$(PIPENV_RUN) mkdocs build

docs.serve:
	$(PIPENV_RUN) mkdocs serve
