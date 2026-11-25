# shellcheck shell=bash

function core::proxy::on() {
  export HTTP_PROXY="http://127.0.0.1:8118"
  export HTTPS_PROXY="http://127.0.0.1:8118"
  export NO_PROXY="localhost,127.0.0.1"

  export http_proxy="$HTTP_PROXY"
  export https_proxy="$HTTPS_PROXY"
  export no_proxy="$NO_PROXY"

  opencode service set env HTTP_PROXY http://127.0.0.1:8118
  opencode service set env HTTPS_PROXY http://127.0.0.1:8118
  opencode service set env NO_PROXY localhost,127.0.0.1,::1

  opencode service set env http_proxy http://127.0.0.1:8118
  opencode service set env https_proxy http://127.0.0.1:8118
  opencode service set env no_proxy localhost,127.0.0.1,::1

  opencode service restart

  print -P "%F{green}HTTP proxy enabled: 127.0.0.1:8118%f"
}

function core::proxy::off() {
  unset HTTP_PROXY HTTPS_PROXY NO_PROXY
  unset http_proxy https_proxy no_proxy

  opencode service unset env HTTP_PROXY
  opencode service unset env HTTPS_PROXY
  opencode service unset env NO_PROXY

  opencode service unset env http_proxy
  opencode service unset env https_proxy
  opencode service unset env no_proxy

  opencode service restart

  print -P "%F{yellow}HTTP proxy disabled%f"
}
