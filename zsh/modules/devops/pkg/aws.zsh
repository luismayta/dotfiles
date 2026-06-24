#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::awscli {
  docker run --rm -it \
    -v "$(pwd):/home/nikovirtala" \
    -v "${HOME}/.aws:/home/nikovirtala/.aws" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    nikovirtala/awscli:latest "$@"
}

function devops::aws_shell {
  docker run --rm -it \
    -v "$(pwd):/home/nikovirtala" \
    -v "${HOME}/.aws:/home/nikovirtala/.aws" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    nikovirtala/aws-shell:latest "$@"
}
