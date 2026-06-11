# shellcheck shell=bash
export RVM_PACKAGE_NAME=rvm
export RVM_ROOT="${HOME}"/.rvm
export RVM_CACHE_DIR="${HOME}/.cache/rvm"
export RVM_VERSIONS=(
    3.4.3
)
export RVM_VERSION_GLOBAL=3.4.3
export RVM_PACKAGES=(
    tmuxinator
    cocoapods
    terminal-notifier
    solargraph
    bundler
)
export RVM_INSTALL_URL="https://get.rvm.io"
export RVM_INSTALL_URL_MPAPIS="https://rvm.io/mpapis.asc"
export RVM_INSTALL_URL_PKUCZYNSKI="https://rvm.io/pkuczynski.asc"
