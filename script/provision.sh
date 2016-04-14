#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

echo "execute Provision"

FILE_PLAYBOOK="$PROVISION_DIR/provision.yml"

ansible-playbook $FILE_PLAYBOOK -i $PATH_INVENTORY  -v \
                 --user=$USER  --private-key=$PRIVATE_KEY \
                --extra-vars $EXTRA_VARS
