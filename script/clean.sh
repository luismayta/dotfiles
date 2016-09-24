#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=src/load.sh
[ -r "src/load.sh" ] && source "src/load.sh"

find "${ROOT_DIR}/" -name "*.pyc" -delete
find "${ROOT_DIR}/" -name "*.swp" -delete
find "${ROOT_DIR}/" -name "__pycache__" -delete
