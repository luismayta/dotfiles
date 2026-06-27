# shellcheck shell=bash
# Devbox internal — checks Nix first, then installs via package manager

devbox::internal::devbox::install() {
  # Pre-flight: ensure Nix is available
  core::nix::ensure

  if core::exists devbox; then
    return 0
  fi

  case "${OSTYPE}" in
    darwin*)
      if core::exists brew; then
        brew install devbox
      else
        core::internal::message::warning "Homebrew not found. Install devbox manually: curl -fsSL https://get.jetify.com/devbox | bash"
        return 1
      fi
      ;;
    linux*)
      if core::exists paru; then
        paru -S --noconfirm devbox-bin
      else
        core::internal::message::warning "paru not found. Install devbox manually: curl -fsSL https://get.jetify.com/devbox | bash"
        return 1
      fi
      ;;
    *)
      core::internal::message::error "Devbox installation not supported on ${OSTYPE}"
      return 1
      ;;
  esac
}
