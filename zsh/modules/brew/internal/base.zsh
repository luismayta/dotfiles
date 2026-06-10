# shellcheck shell=bash
# shellcheck disable=SC2154 # brew_package_name defined in config/base.zsh
function brew::dependences::install {
    message_info "Installing Dependences for ${brew_package_name}"
    message_success "${brew_package_name} Dependences Installed"
}

function brew::dependences::checked {
    if ! type -p ruby > /dev/null; then
      message_error "Please install ruby with rvm for  ${brew_package_name}"
    fi
}

function brew::install::osx {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function brew::install::linux {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    brew vendor-install ruby
}

function brew::install {
    brew::dependences::checked
    message_info "Installing ${brew_package_name}"
    case "${OSTYPE}" in
    darwin*)
        brew::install::osx
        ;;
    linux*)
        brew::install::linux
      ;;
    esac
    message_success "${brew_package_name} Installed"
}

function brew::post_install {
    if type -p brew > /dev/null; then
        brew install gcc

      case "${OSTYPE}" in
        darwin*)
          brew install \
            jq \
            the_silver_searcher \
            tree
          ;;
        linux*)
          case "${DIST}" in
            Redhat | RedHat)
              brew install homebrew/dupes/gperf
              ;;
            Debian | Ubuntu | "")
              brew install \
                jq
              ;;
          esac
          ;;
      esac

    else
        brew::install
    fi
}
