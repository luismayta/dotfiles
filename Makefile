# Makefile for slide-git-flow-developer development.
# See INSTALL for details.

# Configuration.
SHELL = /bin/bash
ROOT_DIR = $(shell pwd)
BIN_DIR = $(ROOT_DIR)/bin
DATA_DIR = $(ROOT_DIR)/var
SCRIPT_DIR = $(ROOT_DIR)/script

WGET = wget
BUILDOUT_CFG = $(ROOT_DIR)/etc/buildout.cfg
BUILDOUT_DIR = $(ROOT_DIR)/lib/buildout
BUILDOUT_VERSION = 2.2.1
BUILDOUT_BOOTSTRAP_URL = https://raw.github.com/buildout/buildout/$(BUILDOUT_VERSION)/bootstrap/bootstrap.py
BUILDOUT_BOOTSTRAP = $(BUILDOUT_DIR)/bootstrap.py
BUILDOUT_BOOTSTRAP_ARGS = -c $(ROOT_DIR)/etc/buildout.cfg --version=$(BUILDOUT_VERSION) buildout:directory=$(ROOT_DIR)
BUILDOUT = $(BIN_DIR)/buildout
BUILDOUT_ARGS = -N buildout:directory=$(ROOT_DIR)
VIRTUALENV_DIR = $(ROOT_DIR)/lib/virtualenv
PIP = $(VIRTUALENV_DIR)/bin/pip
NOSE = $(BIN_DIR)/nosetests
PYTHON = $(VIRTUALENV_DIR)/bin/python

# Bin scripts

CLEAN = $(shell) $(SCRIPT_DIR)/clean.sh
ANSIBLE_PROVISION= $(shell) $(SCRIPT_DIR)/provision.sh
ANSIBLE_DEPLOY= $(shell) $(SCRIPT_DIR)/deploy.sh
ROLES_ANSIBLE = $(shell) $(SCRIPT_DIR)/roles_ansible.sh


install:
	echo 'pass install'


roles:
	$(ROLES_ANSIBLE)


ansible_provision:
	$(ANSIBLE_PROVISION)


ansible_deploy:
	$(ANSIBLE_DEPLOY)


clean:
	$(CLEAN)


deploy:
	$(ANSIBLE_PROVISION)
	$(ANSIBLE_DEPLOY)


distclean: clean
	rm -rf $(ROOT_DIR)/lib
	rm -rf $(ROOT_DIR)/*.egg-info
	rm -rf $(ROOT_DIR)/demo/*.egg-info


maintainer-clean: distclean
	rm -rf $(BIN_DIR)
	rm -rf $(ROOT_DIR)/lib/