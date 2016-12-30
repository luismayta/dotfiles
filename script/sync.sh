#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

echo $(date)

echo 'Progress'

rsync --chmod=ug=rwX -e "ssh -i $KEY_FILE" -axv \
      $DEPLOY_SOURCE_DIR $DEPLOY_ACCOUNT@$DEPLOY_SERVER:$DEPLOY_DEST_DIR --progress
