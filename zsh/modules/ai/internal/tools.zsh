# shellcheck shell=bash

# === Batch Install ===
# Batch installer — dispatches ZSH_AI_TOOLS entries to per-tool install functions (see internal/<tool>.zsh)

function ai::internal::packages::install {
    message_info "Installing required ai packages"
    for package in "${ZSH_AI_TOOLS[@]}"; do
        case "${package}" in
            opencode)
                ai::internal::opencode::install
                ;;
            fabric)
                ai::internal::fabric::install
                ;;
            ollama)
                ai::internal::ollama::install
                ;;
            shimmy)
                ai::internal::shimmy::install
                ;;
            hf)
                ai::internal::hf::install
                ;;
            openclaw)
                ai::internal::openclaw::install
                ;;
            codegraph)
                ai::internal::codegraph::install
                ;;
            tmuxai)
                ai::internal::tmuxai::install
                ;;
            rtk)
                ai::internal::rtk::install
                ;;
            hunk)
                ai::internal::hunk::install
                ;;
            pi)
                ai::internal::pi::install
                ;;
            graphify)
                ai::internal::graphify::install
                ;;
            skills)
                ai::internal::skills::install
                ;;
            *)
                core::install "${package}"
                ;;
        esac
    done
    message_success "Installed required ai packages"
}
