# Makefile for dotfiles.

# Configuration.
SHELL = /bin/bash
ROOT_DIR = $(shell pwd)
BIN_DIR = $(ROOT_DIR)/bin
DATA_DIR = $(ROOT_DIR)/var
SCRIPT_DIR = $(ROOT_DIR)/script

WGET = wget

# Bin scripts
CLEAN = $(shell) $(SCRIPT_DIR)/clean.sh
GRIP = $(shell) $(SCRIPT_DIR)/grip.sh
PYENV = $(shell) $(SCRIPT_DIR)/pyenv.sh
INSTALL = $(shell) $(SCRIPT_DIR)/install.sh
SETUP = $(shell) $(SCRIPT_DIR)/setup.sh
TEST = $(shell) $(SCRIPT_DIR)/test.sh
SYNC = $(shell) $(SCRIPT_DIR)/sync.sh
LINGUIST = $(shell) $(SCRIPT_DIR)/linguist.sh
RUN = $(shell) $(SCRIPT_DIR)/run.sh

install:
	$(SETUP)


setup:
	$(INSTALL)


run:
	$(RUN)


clean:
	$(CLEAN)


distclean: clean
	rm -rf $(ROOT_DIR)/lib
	rm -rf $(ROOT_DIR)/*.egg-info
	rm -rf $(ROOT_DIR)/demo/*.egg-info


environment:
	$(PYENV)


grip:
	$(GRIP)


maintainer-clean: distclean
	rm -rf $(BIN_DIR)
	rm -rf $(ROOT_DIR)/lib/


sync:
	$(SYNC)


linguist:
	$(LINGUIST)


test:
	$(TEST)
