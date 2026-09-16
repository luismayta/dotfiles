#
# shellcheck shell=bash
# macOS-specific package config
#

# localip — show local IP
localip() {
  ipconfig getifaddr en0
}
