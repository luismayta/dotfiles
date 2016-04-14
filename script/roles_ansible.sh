#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

ansible-galaxy install -r roles.txt \
               --roles-path $PROVISION_DIR/roles/contrib --force