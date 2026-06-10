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
function docker::clean::process::dangling { docker::internal::process::stop::exited; }
function docker::clean::volume::all { docker::internal::volume::delete::all; }
function docker::clean::volume::dangling { docker::internal::volume::delete::dangling; }
function docker::clean::network::all { docker::internal::network::delete::all; }
function docker::clean::network::dangling { docker::internal::network::delete::all; }

function docker::process::list { docker::internal::process::list; }
function docker::process::stop::all { docker::internal::process::stop::all; }
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

# Docker CLI wrappers (migrated from devops)
awscli() {
  docker run --rm -it \
    -v "$(pwd):/home/nikovirtala" \
    -v "${HOME}/.aws:/home/nikovirtala/.aws" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    nikovirtala/awscli:latest "$@"
}

aws-shell() {
  docker run --rm -it \
    -v "$(pwd):/home/nikovirtala" \
    -v "${HOME}/.aws:/home/nikovirtala/.aws" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    nikovirtala/aws-shell:latest "$@"
}

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

komiser() {
  docker run --rm -d -p 3000:3000 \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    --name komiser mlabouardy/komiser:2.4.0
}

# Auto-install: check container app, install if missing, then load
container::internal::container::install
container::internal::container::load
