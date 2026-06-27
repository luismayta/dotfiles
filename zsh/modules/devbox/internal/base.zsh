# shellcheck shell=bash
# Devbox internal — install devbox via official curl script

devbox::internal::install() {
  curl -fsSL "${DEVBOX_INSTALL_URL}" | bash
}
