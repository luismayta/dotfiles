#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Gomplate internal implementation

core::internal::gomplate::exists() {
  command -v gomplate > /dev/null && return 0
  [[ -x "${CORE_GOMPLATE_INSTALL_DIR}/gomplate" ]] && return 0
  return 1
}

core::internal::gomplate::load() {
  if ! core::internal::gomplate::exists; then
    return
  fi
  # gomplate is available on PATH
}

core::internal::gomplate::install() {
  if core::internal::gomplate::exists; then
    core::internal::message::info "gomplate already installed"
    return 0
  fi

  local arch
  local os="linux"
  
  # Detect architecture
  case "$(uname -m)" in
    x86_64)  arch="amd64" ;;
    aarch64) arch="arm64" ;;
    armv7l)  arch="armv7" ;;
    armv6l)  arch="armv6" ;;
    i686)    arch="386" ;;
    *)
      core::internal::message::error "Unsupported architecture: $(uname -m)"
      return 1
      ;;
  esac
  
  local url="https://github.com/hairyhenderson/gomplate/releases/download/v${CORE_GOMPLATE_VERSION}/gomplate_${os}-${arch}"
  local install_dir="${CORE_GOMPLATE_INSTALL_DIR}"
  local install_path="${install_dir}/gomplate"
  
  # Create install directory if it doesn't exist
  mkdir -p "${install_dir}"
  
  core::internal::message::info "Installing gomplate v${CORE_GOMPLATE_VERSION} for ${os}-${arch}..."
  
  # Download the binary
  if curl -fsSL "${url}" -o "${install_path}"; then
    chmod +x "${install_path}"
    core::internal::message::success "gomplate v${CORE_GOMPLATE_VERSION} installed to ${install_path}"
    
    # Ensure the directory is in PATH
    if [[ ":${PATH}:" != *":${install_dir}:"* ]]; then
      core::internal::message::warning "Add ${install_dir} to your PATH"
    fi
  else
    core::internal::message::error "Failed to download gomplate from ${url}"
    return 1
  fi
}

core::internal::gomplate::main::factory() {
  if ! core::internal::gomplate::exists; then
    core::internal::gomplate::install
  fi
}
