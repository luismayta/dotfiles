# ruby show help commands.
.PHONY: ruby.help
ruby.help:
	@echo '    ruby:'
	@echo ''
	@echo '        ruby                 show help'
	@echo '        ruby.setup           install dependences to application'
	@echo ''

## Show commands ruby
.PHONY: ruby
ruby:
	@if [ -z "${command}" ]; then \
		make ruby.help;\
	fi

## setup download and install dependence.
.PHONY: ruby.setup
ruby.setup:
	@echo "==> setup ruby..."
	bundler install
	@echo ${MESSAGE_HAPPY}
