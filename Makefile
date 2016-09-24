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
GVM = $(shell) $(SCRIPT_DIR)/gvm.sh
PYENV = $(shell) $(SCRIPT_DIR)/pyenv.sh
SETUP = $(shell) $(SCRIPT_DIR)/setup.sh
INSTALL = $(shell) $(SCRIPT_DIR)/install.sh
TEST = $(shell) $(SCRIPT_DIR)/test.sh
RUNSERVER = $(shell) $(SCRIPT_DIR)/runserver.sh
SYNC = $(shell) $(SCRIPT_DIR)/sync.sh
LINGUIST = $(shell) $(SCRIPT_DIR)/linguist.sh

install:
	$(INSTALL)


clean:
	$(CLEAN)


distclean: clean
	rm -rf $(ROOT_DIR)/lib
	rm -rf $(ROOT_DIR)/*.egg-info
	rm -rf $(ROOT_DIR)/demo/*.egg-info


environment:
	$(PYENV)
	$(GVM)


maintainer-clean: distclean
	rm -rf $(BIN_DIR)
	rm -rf $(ROOT_DIR)/lib/


runserver:
	$(RUNSERVER)


sync:
	$(SYNC)


linguist:
	$(LINGUIST)
