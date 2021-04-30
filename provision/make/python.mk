# python show help commands.
.PHONY: python.help
python.help:
	@echo '    python:'
	@echo ''
	@echo '        python                 show help'
	@echo '        python.environment     make environment for python'
	@echo '        python.lint            lint python'
	@echo '        python.fix             fix code'
	@echo '        python.precommit       precommit install hooks'
	@echo '        python.setup           install dependences to application'
	@echo ''

## Show commands python
.PHONY: python
python:
	@if [ -z "${command}" ]; then \
		make python.help;\
	fi

## Run linter
.PHONY: python.lint
python.lint:
	@echo "==> lint python..."
	@echo ${MESSAGE_HAPPY}

## Fix lint violations
.PHONY: python.fix
python.fix:
	@echo "==> fix python..."
	@echo ${MESSAGE_HAPPY}

## setup download and install dependence.
.PHONY: python.setup
python.setup:
	@echo "==> setup python..."
	$(PIPENV_INSTALL) --dev --skip-lock
	@echo ${MESSAGE_HAPPY}

## environment make for python.
.PHONY: python.environment
python.environment:
	@echo "==> environment python..."
	pipenv --venv || $(PIPENV_INSTALL) --skip-lock
	@echo ${MESSAGE_HAPPY}

## python pre-commit make for python.
.PHONY: python.precommit
python.precommit:
	@echo "==> install hooks for pre-commit..."
	$(PIPENV_RUN) pre-commit install
	$(PIPENV_RUN) pre-commit install -t pre-push
	@echo ${MESSAGE_HAPPY}
