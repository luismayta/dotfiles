# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::opencode::load {
    [ -e "${AI_OPENCODE_BIN_PATH}" ] && export PATH="${AI_OPENCODE_BIN_PATH}:${PATH}"
}

function ai::internal::opencode::sync_quiet {
    mkdir -p "${AI_OPENCODE_CONFIG_PATH}" "${AI_OPENCODE_RUNTIME_CONFIG_PATH}"
    rsync -a "${AI_OPENCODE_CONFIG_SOURCE_PATH}/" "${AI_OPENCODE_CONFIG_PATH}/" \
        && rsync -a --exclude "node_modules" "${AI_OPENCODE_RUNTIME_SOURCE_PATH}/" "${AI_OPENCODE_RUNTIME_CONFIG_PATH}/"
}

function ai::internal::shimmy::load {
    [ -e "${AI_SHIMMY_BIN_PATH}" ] && export PATH="${AI_SHIMMY_BIN_PATH}:${PATH}"
}

function ai::internal::openclaw::load {
    [ -e "${AI_OPENCLAW_BIN_PATH}" ] && export PATH="${AI_OPENCLAW_BIN_PATH}:${PATH}"
}

function ai::internal::codegraph::load {
    [ -e "${AI_CODEGRAPH_BIN_PATH}/codegraph" ] && export PATH="${AI_CODEGRAPH_BIN_PATH}:${PATH}"
}

function ai::internal::rtk::load {
    [ -e "${AI_RTK_BIN_PATH}/rtk" ] && export PATH="${AI_RTK_BIN_PATH}:${PATH}"
}

function ai::internal::hunk::load {
    [ -e "${AI_HUNK_BIN_PATH}/hunk" ] && export PATH="${AI_HUNK_BIN_PATH}:${PATH}"
}

function ai::internal::pi::load {
    [ -e "${AI_PI_BIN_PATH}/pi" ] && export PATH="${AI_PI_BIN_PATH}:${PATH}"
}

function ai::internal::graphify::load {
    [ -e "${AI_GRAPHIFY_BIN_PATH}/graphify" ] && export PATH="${AI_GRAPHIFY_BIN_PATH}:${PATH}"
}

# === Batch Install ===

function ai::internal::packages::install {
    message_info "Installing required ai packages"
    for package in "${AI_TOOLS[@]}"; do
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

# === Tool Install Functions ===

function ai::internal::opencode::install {
    if core::exists opencode; then
        return 0
    fi

    message_info "Installing opencode..."
    if curl -fsSL "${AI_INSTALL_URL_OPENCODE}" | bash; then
        message_success "opencode installed successfully"
    else
        message_error "Failed to install opencode"
        return 1
    fi
}

function ai::internal::hunk::install {
    if core::exists hunk; then
        return 0
    fi

    if ! core::exists npm; then
        message_error "npm is not installed"
        return 1
    fi

    message_info "Installing hunk..."
    if npm install -g hunkdiff; then
        message_success "hunk installed successfully"
    else
        message_error "Failed to install hunk"
        return 1
    fi
}

function ai::internal::opencode::sync {
    if ! core::exists rsync; then
        message_error "rsync is not installed"
        return 1
    fi

    message_info "Syncing opencode config from ${AI_OPENCODE_CONFIG_SOURCE_PATH} to ${AI_OPENCODE_CONFIG_PATH}..."

    if ai::internal::opencode::sync_quiet; then
        message_success "opencode config synced successfully"
    else
        message_error "Failed to sync opencode config"
        return 1
    fi
}

function ai::internal::fabric::install {
    if core::exists fabric; then
        return 0
    fi

    message_info "Installing fabric..."
    if curl -fsSL "${AI_INSTALL_URL_FABRIC}" | bash; then
        message_success "fabric installed successfully"
    else
        message_error "Failed to install fabric"
        return 1
    fi
}

function ai::internal::ollama::install {
    if core::exists ollama; then
        return 0
    fi

    message_info "Installing ollama..."
    if curl -fsSL "${AI_INSTALL_URL_OLLAMA}" | sh; then
        message_success "ollama installed successfully"
    else
        message_error "Failed to install ollama"
        return 1
    fi
}

function ai::internal::shimmy::install {
    if core::exists shimmy; then
        return 0
    fi

    mkdir -p "${AI_SHIMMY_BIN_PATH}"

    if curl -fsSL "${AI_INSTALL_URL_SHIMMY}" -o "${AI_SHIMMY_BIN_PATH}/shimmy"; then
        chmod +x "${AI_SHIMMY_BIN_PATH}/shimmy"
        message_success "shimmy installed successfully"
    else
        message_error "Failed to install shimmy"
        return 1
    fi
}

function ai::internal::hf::install {
    if core::exists hf; then
        return 0
    fi

    message_info "Installing hf CLI..."
    if curl -fsSL "${AI_INSTALL_URL_HF}" | bash; then
        message_success "hf installed successfully"
    else
        message_error "Failed to install hf"
        return 1
    fi
}

function ai::internal::openclaw::install {
    if core::exists openclaw; then
        return 0
    fi

    mkdir -p "${AI_OPENCLAW_BIN_PATH}"

    message_info "Installing openclaw..."

    if curl -fsSL "${AI_INSTALL_URL_OPENCLAW}" | bash; then
        message_success "openclaw installed successfully"
    else
        message_error "Failed to install openclaw"
        return 1
    fi
}

function ai::internal::codegraph::install {
    if core::exists codegraph; then
        return 0
    fi

    message_info "Installing codegraph..."
    if curl -fsSL "${AI_INSTALL_URL_CODEGRAPH}" | sh; then
        message_success "codegraph installed successfully"
    else
        message_error "Failed to install codegraph"
        return 1
    fi
}

function ai::internal::tmuxai::install {
    if core::exists tmuxai; then
        return 0
    fi

    if ! core::exists curl; then
        message_error "curl is not installed"
        return 1
    fi

    if ! core::exists bash; then
        message_error "bash is not installed"
        return 1
    fi

    message_info "Installing tmuxai..."
    if curl -fsSL "${AI_INSTALL_URL_TMUXAI}" | bash; then
        message_success "tmuxai installed successfully"
    else
        message_error "Failed to install tmuxai"
        return 1
    fi
}

function ai::internal::rtk::install {
    if core::exists rtk; then
        return 0
    fi

    message_info "Installing rtk..."
    if curl -fsSL "${AI_INSTALL_URL_RTK}" | sh; then
        message_success "rtk installed successfully"
    else
        message_error "Failed to install rtk"
        return 1
    fi
}

function ai::internal::rtk::config::sync {
    local src="${AI_RTK_CONFIG_SOURCE_PATH}"
    local dst="${AI_RTK_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "rtk config synced"
    else
        message_warning "no rtk config source at ${src}"
    fi
}

function ai::internal::pi::config::sync {
    local src="${AI_PI_CONFIG_SOURCE_PATH}"
    local dst="${AI_PI_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "pi config synced"
    else
        message_warning "no pi config source at ${src}"
    fi
}

function ai::internal::pi::install {
    if core::exists pi; then
        return 0
    fi

    message_info "Installing pi (AI coding agent)..."
    if curl -fsSL "${AI_INSTALL_URL_PI}" | sh; then
        message_success "pi installed successfully"
    else
        message_error "Failed to install pi"
        return 1
    fi
}

function ai::internal::graphify::install {
    if core::exists graphify; then
        return 0
    fi

    if ! core::exists uv; then
        message_error "uv is not installed. Please install uv first: curl -LsSf https://astral.sh/uv/install.sh | sh"
        return 1
    fi

    message_info "Installing graphify..."
    if uv tool install "graphifyy[all]" --force; then
        message_success "graphify installed successfully"
        ai::internal::graphify::register_skill
    else
        message_error "Failed to install graphify"
        return 1
    fi
}

function ai::internal::skills::load {
    [ -e "${AI_SKILLS_BIN_PATH}" ] && export PATH="${AI_SKILLS_BIN_PATH}:${PATH}"
}

function ai::internal::skills::install {
    if core::exists skills; then
        return 0
    fi

    message_info "Installing skills CLI..."
    if curl -fsSL "${AI_INSTALL_URL_SKILLS}" | bash; then
        message_success "skills CLI installed successfully"
    else
        message_error "Failed to install skills CLI"
        return 1
    fi
}

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

# Resolve the variable name for a repo's skills
# e.g., "vercel-labs/agent-skills" -> "AI_SKILLS_VERCEL"
# shellcheck disable=SC2034,SC2296 # zsh parameter flags (U) not supported by shellcheck
function ai::internal::skills::_repo_var {
    local repo="$1"
    local short="${repo##*/}"
    echo "AI_SKILLS_${(U)short}"
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

    for repo in "${AI_SKILLS_REPOS[@]}"; do
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

function ai::internal::graphify::upgrade {
    if ! core::exists uv; then
        message_error "uv is not installed. Please install uv first: curl -LsSf https://astral.sh/uv/install.sh | sh"
        return 1
    fi

    message_info "Upgrading graphify..."
    if uv tool install "graphifyy[all]" --force; then
        message_success "graphify upgraded successfully"
        ai::internal::graphify::register_skill
    else
        message_error "Failed to upgrade graphify"
        return 1
    fi
}

function ai::internal::graphify::register_skill {
    if core::exists graphify; then
        message_info "Registering graphify skill with OpenCode..."
        if graphify install --platform opencode; then
            message_success "graphify skill registered"
        else
            message_warning "Failed to register graphify skill (graphify is still installed)"
        fi
    fi
}

function ai::internal::graphify::setup {
    if ! core::exists graphify; then
        message_error "graphify is not installed. Run ai::graphify::install first."
        return 1
    fi
    message_info "Setting up graphify for current project..."
    if graphify install --platform opencode --project; then
        message_success "graphify project setup complete"
    else
        message_error "Failed to set up graphify for project"
        return 1
    fi
}

# === OpenSpec Functions ===

function ai::internal::openspec::load {
    true
}

function ai::internal::openspec::install {
    if core::exists openspec; then
        return 0
    fi

    if ! core::exists bun; then
        message_error "bun is not installed"
        return 1
    fi

    message_info "Installing openspec..."
    if bun add -g @fission-ai/openspec@latest; then
        message_success "openspec installed successfully"
        ai::internal::openspec::register_skill
    else
        message_error "Failed to install openspec"
        return 1
    fi
}

function ai::internal::openspec::upgrade {
    if ! core::exists bun; then
        message_error "bun is not installed"
        return 1
    fi

    message_info "Upgrading openspec..."
    if bun add -g @fission-ai/openspec@latest --force; then
        message_success "openspec upgraded successfully"
        ai::internal::openspec::register_skill
    else
        message_error "Failed to upgrade openspec"
        return 1
    fi
}

function ai::internal::openspec::register_skill {
    if core::exists openspec; then
        message_info "Registering openspec skill with OpenCode..."
        if openspec install --platform opencode; then
            message_success "openspec skill registered"
        else
            message_warning "Failed to register openspec skill (openspec is still installed)"
        fi
    fi
}

function ai::internal::openspec::init {
    if ! core::exists openspec; then
        message_error "openspec is not installed. Run ai::openspec::install first."
        return 1
    fi
    message_info "Initializing OpenSpec..."
    if openspec init --tools opencode; then
        message_success "openspec initialized successfully"
    else
        message_error "Failed to initialize openspec"
        return 1
    fi
}

function ai::internal::openspec::update {
    if ! core::exists openspec; then
        message_error "openspec is not installed. Run ai::openspec::install first."
        return 1
    fi
    message_info "Updating OpenSpec..."
    if openspec update; then
        message_success "openspec updated successfully"
    else
        message_error "Failed to update openspec"
        return 1
    fi
}

function ai::internal::openspec::setup {
    if ! core::exists openspec; then
        message_error "openspec is not installed. Run ai::openspec::install first."
        return 1
    fi
    message_info "Setting up openspec for current project..."
    if [[ -d ".openspec" ]]; then
        ai::internal::openspec::update
    else
        ai::internal::openspec::init
    fi
}