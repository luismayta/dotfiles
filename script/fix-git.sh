#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

git filter-branch --force --commit-filter '
    if [ ! "$GIT_COMMITTER_EMAIL" = "slovacus@gmail.com" ];then
        GIT_COMMITTER_NAME="@slovacus";
        GIT_AUTHOR_NAME="@slovacus";
        GIT_COMMITTER_EMAIL="slovacus@gmail.com";
        GIT_AUTHOR_EMAIL="slovacus@gmail.com";
        git commit-tree "$@";
    else
        git commit-tree "$@";
    fi' HEAD
