#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

grip --pass "${GITHUB_API_TOKEN}" ${GRIP_PORT}