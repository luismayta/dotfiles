# git
.PHONY: git.help


git.help:
	@echo '    git:'
	@echo ''
	@echo '        git                 show help'
	@echo '        git.setup            install dependences to application'
	@echo '        git.ignore           install dependences to application'
	@echo '        git.reviews          add revieweers to git config'
	@echo ''

git:
	@if [ -z "${command}" ]; then \
		make git.help;\
	fi


# setup all actions git ignore.
.PHONY: git.setup
git.setup:
	@echo "==> setup git..."
	make git.ignore
	make git.reviews

.PHONY: git.ignore
git.ignore:
	@echo "==> git ignore generated..."
	@$(GI) ${GIT_IGNORES} > .gitignore
	@echo ${MESSAGE_HAPPY}

.PHONY: git.reviews
git.reviews:
	@echo "==> add issues revievers..."
	@git config github.reviews "${REVIEWERS}"
	@echo ${MESSAGE_HAPPY}
