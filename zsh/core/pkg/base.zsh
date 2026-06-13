#
# shellcheck shell=bash
# Public API wrappers
#

core::install() {
  core::internal::core::install "${@}"
}

core::load() {
  core::internal::core::load "${@}"
}

core::exists() {
  core::internal::core::exists "${@}"
}

core::ensure() {
  core::exists "${1}" || core::install "${1}"
}

core::cargo::install() {
  core::internal::cargo::install "${@}"
}

core::packages::install() {
  core::internal::packages::install "${@}"
}

core::multiplatform::install() {
  core::internal::multiplatform::install
}

message_info() {
  core::internal::message::info "${@}"
}

message_error() {
  core::internal::message::error "${@}"
}

message_warning() {
  core::internal::message::warning "${@}"
}

message_success() {
  core::internal::message::success "${@}"
}
