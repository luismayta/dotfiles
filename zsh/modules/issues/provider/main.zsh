# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ISSUES_PATH}/provider/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ISSUES_PATH}/provider/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ISSUES_PATH}/provider/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${ISSUES_PATH}/provider/alias.zsh"

function issues::provider::factory {
    local provider
    provider=$(issues::internal::git::provider::detect)
    case "${provider}" in
    github)
        # shellcheck source=/dev/null
        source "${ISSUES_PATH}/provider/github.zsh"
        ;;
    gitlab)
        # shellcheck source=/dev/null
        source "${ISSUES_PATH}/provider/gitlab.zsh"
        ;;
    esac
}

# Auto-detect on initial load
issues::provider::factory
