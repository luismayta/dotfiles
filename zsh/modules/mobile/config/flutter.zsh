# shellcheck shell=bash
# Flutter SDK configuration

export FLUTTER_PACKAGE_NAME=flutter
export FLUTTER_ROOT="${HOME}/google/flutter"
export FLUTTER_ROOT_BIN="${FLUTTER_ROOT}/bin"
export FLUTTER_DART_SDK="${FLUTTER_ROOT_BIN}/cache/dart-sdk"
export FLUTTER_DART_SDK_BIN="${FLUTTER_DART_SDK}/bin"
export FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable"
export FLUTTER_VERSION="${FLUTTER_VERSION:-3.13.9-stable}"
export PUB_BIN_PATH="${HOME}/.pub-cache/bin"
export PUB_PACKAGES=(webdev stagehand)
