#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=src/load.sh
[ -r "src/load.sh" ] && source "src/load.sh"

bundle exec linguist --breakdown
