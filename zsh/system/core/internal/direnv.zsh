# shellcheck shell=bash
# direnv — hook de integración con zsh

core::internal::direnv::load() {
    if core::internal::core::exists direnv; then
        eval "$(direnv hook zsh)"
    fi
}
