## Show commands help gitflow
GITFLOW_PREFIX_FEATURE ?= "feature/"
.PHONY: gitflow.help

gitflow.help:
	@echo '    gitflow:'
	@echo ''
	@echo '        gitflow                 show help'
	@echo '        gitflow.install         install gitflow'
	@echo '        gitflow.setup           install gitflow setup'
	@echo '        gitflow.prefix          add dependences prefix for gitflow'
	@echo ''

## Show commands gitflow
.PHONY: gitflow
gitflow:
	@if [ -z "${command}" ]; then \
		make gitflow.help;\
	fi

## Setup all actions gitflow ignore.
.PHONY: gitflow.setup
gitflow.setup:
	@echo "==> setup gitflow..."
	make gitflow.prefix

## Install gitflow.
.PHONY: gitflow.install
gitflow.install:
	@echo "==> install gitflow..."
	@gitflow init -d

## Generate gitflow prefix of files.
.PHONY: gitflow.prefix
gitflow.prefix:
	@echo "==> gitflow prefix generated..."
	@git config gitflow.prefix.feature ${GITFLOW_PREFIX_FEATURE}
	@echo ${MESSAGE_HAPPY}
