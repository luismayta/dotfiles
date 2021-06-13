# vagrant show help commands.
.PHONY: vagrant.help
vagrant.help:
	@echo '    vagrant:'
	@echo ''
	@echo '        vagrant                 show help'
	@echo '        vagrant.setup           install dependences for vagrant'
	@echo '        vagrant.plugins         install plugins for vagrant'
	@echo '        vagrant.environment     environment for vagrant'
	@echo ''

## Show commands vagrant
.PHONY: vagrant
vagrant:
	@if [ -z "${command}" ]; then \
		make vagrant.help;\
	fi

## setup download and install dependences plugins.
.PHONY: vagrant.plugins
vagrant.plugins:
	@echo "==> install vagrant plugins..."
	vagrant plugin install vagrant-vbguest
	@echo ${MESSAGE_HAPPY}

## setup download and install dependences.
.PHONY: vagrant.setup
vagrant.setup:
	@echo "==> install vagrant setup..."
	make vagrant.plugins
	@echo ${MESSAGE_HAPPY}

## environment make for vagrant.
.PHONY: vagrant.environment
vagrant.environment:
	@echo "==> environment vagrant..."
	@echo ${MESSAGE_HAPPY}
