#!/usr/bin/env bash
# -*- coding: utf-8 -*-

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile="$( mktemp -t transferXXX )"
    curl --progress-bar --upload-file "$1" https://transfer.sh/"$(basename $1)" >> "$tmpfile";
    cat "$tmpfile";
    rm -f "$tmpfile";
}
