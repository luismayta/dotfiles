# git
.PHONY: git.help


git.help:
	@echo '    git:'
	@echo ''
	@echo '        git                 show help'
	@echo '        git.setup           install dependences to application'
	@echo '        git.ignore           install dependences to application'
	@echo ''

git:
	@if [ -z "${command}" ]; then \
		make git.help;\
	fi


# setup all actions git ignore.
.PHONY: git.setup
git.setup:
	@echo "=====> setup git..."
	make git.ignore

# setup all actions git ignore.
.PHONY: git.ignore
git.ignore:
	@echo "=====> git ignore generated..."
	@$(GI) ${GIT_IGNORES} > .gitignore
	@echo ${MESSAGE_HAPPY}
