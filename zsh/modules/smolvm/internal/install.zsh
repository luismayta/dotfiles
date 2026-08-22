# shellcheck shell=bash

# ──────────────────────────────────────────────
# Install helpers
# ──────────────────────────────────────────────

function smolvm::internal::checksum::verify {
  local file="$1"

  if [[ -z "$file" ]] || [[ ! -f "$file" ]]; then
    message_error "Checksum verification failed: file not found"
    return 1
  fi

  local actual
  case "${OSTYPE}" in
  darwin*)
    actual="$(shasum -a 256 "$file" | awk '{print $1}')"
    ;;
  *)
    actual="$(sha256sum "$file" | awk '{print $1}')"
    ;;
  esac

  if [[ "$actual" != "${ZSH_SMOLVM_SHA256}" ]]; then
    message_error "Checksum mismatch for ${ZSH_SMOLVM_PACKAGE_NAME}: expected ${ZSH_SMOLVM_SHA256}, got ${actual}"
    return 1
  fi

  message_success "Checksum verified for ${ZSH_SMOLVM_PACKAGE_NAME}"
  return 0
}

function smolvm::internal::install {
  if core::exists smolvm; then
    message_info "${ZSH_SMOLVM_PACKAGE_NAME} is already installed."
    return 0
  fi

  # The release is a directory distribution (smolvm-<version>-<asset>/)
  # containing the `smolvm` wrapper, `smolvm-bin`, `lib/`, `agent-rootfs/`,
  # `storage-template.ext4`, `overlay-template.ext4`, `checksums.txt` and
  # `README.txt`. The wrapper resolves paths relative to itself, so we extract
  # ALL of the content (--strip-components=1) to ~/.local/bin to keep them
  # together. This layout applies to all platform archives (linux, darwin).

  if [[ -z "${ZSH_SMOLVM_ASSET:-}" ]]; then
    message_error "No smolvm asset configured for this OS"
    return 1
  fi

  core::ensure curl

  # On macOS, prefer the system bsdtar over GNU tar from Nix/Homebrew.
  # GNU tar chokes on sparse archives (the upstream .ext4 templates are
  # stored as sparse entries), producing "Unexpected EOF in archive".
  # bsdtar handles them correctly.
  local tar_cmd="tar"
  if [[ "${OSTYPE}" == darwin* ]] && command -v /usr/bin/tar &>/dev/null; then
    tar_cmd="/usr/bin/tar"
  fi

  local tmpdir archive
  tmpdir="$(mktemp -d)" || {
    message_error "Failed to create temporary directory"
    return 1
  }
  archive="${tmpdir}/${ZSH_SMOLVM_PACKAGE_NAME}-${ZSH_SMOLVM_VERSION}-${ZSH_SMOLVM_ASSET}.tar.gz"

  message_info "Downloading ${ZSH_SMOLVM_PACKAGE_NAME} ${ZSH_SMOLVM_VERSION}..."
  if ! curl -fsSL "${ZSH_SMOLVM_INSTALL_URL}" -o "$archive"; then
    message_error "Failed to download ${ZSH_SMOLVM_PACKAGE_NAME} release"
    rm -rf "$tmpdir"
    return 1
  fi

  if ! smolvm::internal::checksum::verify "$archive"; then
    message_error "Aborting installation: checksum verification failed"
    rm -rf "$tmpdir"
    return 1
  fi

  mkdir -p "${ZSH_SMOLVM_BIN_PATH}"

  # Atomic extraction: unpack into a staging area inside the tmpdir and copy
  # in a single step to ~/.local/bin so we never leave a half-extracted tree.
  local staged="${tmpdir}/staged"
  mkdir -p "$staged"
  if ! $tar_cmd -xzf "$archive" -C "$staged" --strip-components=1; then
    message_error "Failed to extract ${ZSH_SMOLVM_PACKAGE_NAME} archive"
    rm -rf "$tmpdir"
    return 1
  fi

  if ! cp -R "$staged"/. "${ZSH_SMOLVM_BIN_PATH}/"; then
    message_error "Failed to install ${ZSH_SMOLVM_PACKAGE_NAME}"
    rm -rf "$tmpdir"
    return 1
  fi

  rm -rf "$tmpdir"

  # On fresh hosts ~/.local/bin may not have existed when core was loaded; the
  # function validates [ -e ] internally, so we re-add it before the check.
  core::path::prepend "${ZSH_SMOLVM_BIN_PATH}"

  if core::exists smolvm; then
    message_success "${ZSH_SMOLVM_PACKAGE_NAME} installed successfully"
    return 0
  fi
  message_warning "${ZSH_SMOLVM_PACKAGE_NAME} installed but binary not found in PATH"
  return 1
}