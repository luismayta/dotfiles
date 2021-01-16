# python
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

python:
	@if [ -z "${command}" ]; then \
		make python.help;\
	fi


.PHONY: python.lint
python.lint: ## Run linter
	@echo "=====> lint python..."
	@echo ${MESSAGE_HAPPY}

.PHONY: python.fix
python.fix: ## Fix lint violations
	@echo "=====> fix python..."
	@echo ${MESSAGE_HAPPY}

# setup download and install dependence.
.PHONY: python.setup
python.setup:
	@echo "=====> setup python..."
	$(PIPENV_INSTALL) --dev --skip-lock
	@echo ${MESSAGE_HAPPY}

# environment make for python.
.PHONY: python.environment
python.environment:
	@echo "=====> environment python..."
	pipenv --venv || $(PIPENV_INSTALL) --python=${PYTHON_VERSION} --skip-lock
	@echo ${MESSAGE_HAPPY}

# python pre-commit make for python.
.PHONY: python.precommit
python.precommit:
	@echo "=====> install hooks for pre-commit..."
	$(PIPENV_RUN) pre-commit install
	$(PIPENV_RUN) pre-commit install -t pre-push
	@echo ${MESSAGE_HAPPY}
