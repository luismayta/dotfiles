#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export PROJECT_NAME=dotfiles
# Vars Dir
export ROOT_DIR="`pwd`"
export RESOURCES_DIR="$ROOT_DIR/resources"
export PROVISION_DIR="$ROOT_DIR/provision/ansible"

export DEPLOY_ACCOUNT=ubuntu
export PATH_INVENTORY="$PROVISION_DIR/inventories/sandbox/local"
export USER=$DEPLOY_ACCOUNT
export PRIVATE_KEY="$KEY_FILE"
export EXTRA_VARS="user=ubuntu"
