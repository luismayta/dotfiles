#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::caddy::install {
    devops::caddy::internal::install
}

function devops::caddy::upgrade {
    devops::caddy::internal::upgrade
}

function devops::caddy::sync {
    devops::caddy::internal::sync
}

function devops::caddy::run {
    devops::caddy::internal::run
}

function devops::caddy::reload {
    devops::caddy::internal::reload
}

function devops::caddy::post_install {
    message_info "Caddy usage guidance:"
    message_info "  devops::caddy::sync    # symlink your dotfiles Caddyfile -> ~/.config/caddy/Caddyfile"
    message_info "  devops::caddy::run     # run Caddy in the foreground with the managed Caddyfile"
    message_info "  devops::caddy::reload  # hot-reload Caddy with the managed Caddyfile"
    message_info "  caddy file-server      # serve files from the current directory over HTTP"
    message_info "  caddy reverse-proxy    # reverse proxy (e.g. --from :8080 --to localhost:9000)"
}
