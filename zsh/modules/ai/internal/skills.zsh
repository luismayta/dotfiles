# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::skills::load {
    [ -e "${ZSH_AI_SKILLS_BIN_PATH}" ] && export PATH="${ZSH_AI_SKILLS_BIN_PATH}:${PATH}"
}

# === Skills Install ===

function ai::internal::skills::install {
    if core::exists skills; then
        return 0
    fi

    message_info "Installing skills CLI..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_SKILLS}" | bash; then
        message_success "skills CLI installed successfully"
    else
        message_error "Failed to install skills CLI"
        return 1
    fi
}

# === Skills Commands ===

function ai::internal::skills::add {
    local source="${1}"
    if [[ -z "${source}" ]]; then
        message_error "Usage: ai::skills::add <source>"
        return 1
    fi

    message_info "Adding skill from ${source} globally for opencode and pi..."
    if bunx skills add "${source}" -g -a opencode -a pi -y; then
        message_success "Skill added successfully"
    else
        message_error "Failed to add skill"
        return 1
    fi
}

function ai::internal::skills::use {
    local source="${1}"
    if [[ -z "${source}" ]]; then
        message_error "Usage: ai::skills::use <source>"
        return 1
    fi

    message_info "Using skill from ${source}..."
    if bunx skills use "${source}"; then
        message_success "Skill prompt generated"
    else
        message_error "Failed to use skill"
        return 1
    fi
}

function ai::internal::skills::list {
    message_info "Listing installed global skills..."
    if bunx skills list -g; then
        message_success "Skills listed"
    else
        message_error "Failed to list skills"
        return 1
    fi
}

function ai::internal::skills::update {
    message_info "Updating global skills..."
    if bunx skills update -g -y; then
        message_success "Skills updated"
    else
        message_error "Failed to update skills"
        return 1
    fi
}

function ai::internal::skills::search {
    local query="${1}"
    if [[ -z "${query}" ]]; then
        message_error "Usage: ai::skills::search <query>"
        return 1
    fi

    message_info "Searching for skills: ${query}"
    if bunx skills search "${query}"; then
        message_success "Search complete"
    else
        message_error "Failed to search skills"
        return 1
    fi
}

function ai::internal::skills::publish {
    local skill_path="${1}"
    if [[ -z "${skill_path}" ]]; then
        message_error "Usage: ai::skills::publish <skill-path>"
        return 1
    fi

    message_info "Publishing skill from ${skill_path}..."
    if bunx skills publish "${skill_path}"; then
        message_success "Skill published"
    else
        message_error "Failed to publish skill"
        return 1
    fi
}

# === Skills Helpers ===

# Resolve the variable name for a repo's skills
# e.g., "vercel-labs/agent-skills" -> "ZSH_AI_SKILLS_VERCEL"
# shellcheck disable=SC2034,SC2296 # zsh parameter flags (U) not supported by shellcheck
function ai::internal::skills::_repo_var {
    local repo="$1"
    local short="${repo##*/}"
    echo "ZSH_AI_SKILLS_${(U)short}"
}

# Install all skills from a single repo in one CLI call
# shellcheck disable=SC2034,SC2296 # zsh parameter flags (P) not supported by shellcheck
function ai::internal::skills::_install_repo {
    local repo="$1"
    local var_name
    var_name="$(ai::internal::skills::_repo_var "$repo")"
    local -a skills=("${(@P)var_name}")

    if [[ ${#skills[@]} -eq 0 ]]; then
        message_warning "No skills defined for ${repo}, skipping"
        return 1
    fi

    local -a cmd=(bunx skills add "$repo" -g -a opencode -a pi -y)

    if [[ "${skills[1]}" == "*" ]]; then
        cmd+=(--all)
        message_info "Installing all skills from ${repo}..."
    else
        for skill in "${skills[@]}"; do
            cmd+=(-s "$skill")
        done
        message_info "Installing ${#skills[@]} skills from ${repo}..."
    fi

    if "${cmd[@]}"; then
        message_success "Installed skills from ${repo}"
        return 0
    else
        message_warning "Failed to install skills from ${repo}"
        return 1
    fi
}

function ai::internal::skills::setup {
    local -i success=0 fail=0
    local -a failed_repos=()

    message_info "Installing default skills globally for opencode and pi..."

    for repo in "${ZSH_AI_SKILLS_REPOS[@]}"; do
        if ai::internal::skills::_install_repo "$repo"; then
            ((success++))
        else
            ((fail++))
            failed_repos+=("$repo")
        fi
    done

    if (( fail > 0 )); then
        message_warning "Skills setup completed with ${fail} failure(s):"
        for r in "${failed_repos[@]}"; do
            message_warning "  Failed: ${r}"
        done
        return 1
    fi

    message_success "All ${success} skill repos installed successfully"
    return 0
}
