# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ISSUES_PATH}/workflow/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ISSUES_PATH}/workflow/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ISSUES_PATH}/workflow/linux.zsh"
  ;;
esac

function issues::workflow::factory {
    # shellcheck source=/dev/null
    source "${ISSUES_PATH}/workflow/githubflow.zsh"
}

# Auto-detect on initial load
issues::workflow::factory
