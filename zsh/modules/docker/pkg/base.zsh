#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::login { docker::internal::login; }
function docker::clean::all { docker::internal::clean::all; }

function docker::clean::dangling {
    docker::clean::images::dangling
    docker::clean::volume::dangling
}

function docker::clean::images::all { docker::internal::images::delete::all; }
function docker::clean::images::dangling { docker::internal::images::delete::dangling; }
function docker::clean::process::all { docker::internal::process::delete::all; }
function docker::clean::process::exited { docker::internal::process::stop::exited; }
function docker::clean::volume::all { docker::internal::volume::delete::all; }
function docker::clean::volume::dangling { docker::internal::volume::delete::dangling; }
function docker::clean::network::all { docker::internal::network::delete::all; }
function docker::process::list { docker::internal::process::list; }
function docker::process::stop::exited { docker::internal::process::stop::exited; }
function docker::process::delete::all { docker::internal::process::delete::all; }

function docker::volume::delete::all { docker::internal::volume::delete::all; }
function docker::volume::list::all { docker::internal::volume::list::all; }
function docker::volume::delete::exited { docker::internal::volume::delete::exited; }
function docker::volume::delete::dangling { docker::internal::volume::delete::dangling; }

function docker::container::delete::all { docker::internal::container::delete::all; }
function docker::container::stop::all { docker::internal::container::stop::all; }
function docker::container::delete::dangling { docker::internal::container::stop::dangling; }

function docker::network::delete::all { docker::internal::network::delete::all; }

function docker::images::delete::dangling { docker::internal::images::delete::dangling; }
function docker::images::delete::all { docker::internal::images::delete::all; }

nyancat() {
  docker run -it --rm supertest2014/nyan
}

ytd-mp3() {
  docker run --rm -v "${PWD}":/data hadenlabs/youtube-dl --extract-audio --audio-format mp3 "$@"
}

ytdl() {
  docker run --rm -v "${PWD}":/data hadenlabs/youtube-dl "$@"
}

youtube-dl() {
  docker run --rm -v "${PWD}":/data hadenlabs/youtube-dl "$@"
}
