#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

find $ROOT_DIR/ -name "*.pyc" -delete
find $ROOT_DIR/ -name "*.swp" -delete