#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

ansible-playbook "${FILE_PLAYBOOK}" -i "${PATH_INVENTORY}"  -v \
                 --user="${USER}"  --private-key="${PRIVATE_KEY}" \
                 --extra-vars "${EXTRA_VARS}" \
                 --vault-password-file ~/.vault_pass.txt
