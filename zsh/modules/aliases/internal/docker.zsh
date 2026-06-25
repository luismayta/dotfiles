#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function awscli { devops::awscli "$@"; }

function aws-shell { devops::aws_shell "$@"; }

function nyancat {
    docker run -it --rm supertest2014/nyan;
}

function ytd-mp3 {
    docker run --rm -v "${PWD}":/data vimagick/youtube-dl --extract-audio --audio-format mp3 "$@"
}

function ytdl {
    docker run --rm -v "${PWD}":/data vimagick/youtube-dl "$@"
}

function youtube-dl {
    docker run --rm -v "${PWD}":/data vimagick/youtube-dl "$@"
}

function pandoc {
    docker run --rm -v "${PWD}":/source jagregory/pandoc "$@"
}