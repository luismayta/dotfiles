#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::komiser {
  message_info "Komiser is running at http://localhost:${DEVOPS_KOMISER_PORT}"
  docker run --rm -d -p "${DEVOPS_KOMISER_PORT}:3000" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    --name komiser mlabouardy/komiser:2.4.0
}
