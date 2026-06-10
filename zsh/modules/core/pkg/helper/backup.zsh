#
# shellcheck shell=bash
# Public backup convenience wrapper
#

core::snapshot() {
  core::backup::snapshot
}
